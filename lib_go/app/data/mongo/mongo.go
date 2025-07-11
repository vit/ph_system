package mongo

import (
	"io"
	"context"
	"time"
	// "log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/gridfs"
	"go.mongodb.org/mongo-driver/mongo/options"

	. "lib/data/types"
)

type MongoDB struct {
	Client   *mongo.Client
	DB       *mongo.Database
	Docs     *mongo.Collection
	Files    *mongo.Collection
	GridFS   *gridfs.Bucket
}

func ConnectMongoDB(uri string) (*MongoDB, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, options.Client().ApplyURI(uri))
	if err != nil {
		return nil, err
	}

	dbName := "ph3"

	db := client.Database(dbName)
	bucket, err := gridfs.NewBucket(db, options.GridFSBucket().SetName("docs"))
	if err != nil {
		return nil, err
	}

	return &MongoDB{
		Client: client,
		DB:     db,
		Docs:   db.Collection("docs"),
		Files:  db.Collection("docs.files"),
		GridFS: bucket,
	}, nil
}

func (db *MongoDB) FindFullDoc(ctx context.Context, id string) (*Document, error) {
	var (
		doc Document
		fileInfo FileInfo
	)

	err := db.Docs.FindOne(ctx, bson.M{"_id": id}).Decode(&doc)
	if err != nil { return nil, err }

	err = db.Files.FindOne(ctx, bson.M{"_meta.parent": id}).Decode(&fileInfo)
	if err == nil { doc.FileInfo = fileInfo }

	doc.Children, _ = db.FindDocs(ctx, bson.M{"_meta.parent": id}, bson.D{{"_meta.ctime", -1}})
	doc.Breadcrumbs, _ = db.GetDocBreadcrumbs(ctx, id)

	return &doc, nil
}


func (db *MongoDB) FindDocs(ctx context.Context, filter bson.M, sort bson.D) ([]Document, error) {
	opts := options.Find().SetSort(sort)
	cursor, err := db.Docs.Find(ctx, filter, opts)
	if err != nil {
		return nil, err
	}

	var results []Document
	if err = cursor.All(ctx, &results); err != nil {
		return nil, err
	}
	return results, nil
}

func (db *MongoDB) GetDocBreadcrumbs(ctx context.Context, id string) ([]Breadcrumb, error) {
	var (
		doc Document
		result []Breadcrumb
		currentId = id
	)
	for {
		err := db.Docs.FindOne(ctx, bson.M{"_id": currentId}).Decode(&doc)
		if err != nil { return nil, err }

		current := Breadcrumb{ID: currentId, Title: doc.Info.Title}
		result = append([]Breadcrumb{current}, result...)

		currentId = doc.Meta.Parent
		if currentId=="" { break }
	}
	return result, nil
}

func (db *MongoDB) DownloadFile(ctx context.Context, id string, w io.Writer) error {
	stream, err := db.GridFS.OpenDownloadStream(id)
	if err != nil {
		return err
	}
	defer stream.Close()

	_, err = io.Copy(w, stream)
	return err
}
