package data

import (
	// "errors"
	// "fmt"
	// "time"
	"io"
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"lib/data/mongo"
	"lib/config"
	. "lib/data/types"
)

type Repository struct {
	conn *mongo.MongoDB
	// config *config.Config
}

func GetRepository(cnf *config.Config) (*Repository, error) {
	// uri := "mongodb://root:example@ph_system_mongo_development:27017"
	uri := cnf.MongoString
	mdb, err := mongo.ConnectMongoDB(uri)
	return &Repository{
		conn: mdb,
		// config: cnf,
	}, err
}

func (c *Repository) Close(ctx context.Context) {
	c.conn.Client.Disconnect(ctx)
}

func (c *Repository) GetDoc(ctx context.Context, id string) (*Document, error) {
	results, err := c.conn.FindFullDoc(ctx, id)
	return results, err
}

func (c *Repository) DoSearch(ctx context.Context, query string) ([]Document, error) {
	results, err := c.conn.FindDocs(ctx, bson.M{"$text": bson.M{"$search": query}}, bson.D{})
	if err != nil {
		results = []Document{}
	}
	return results, err
}

func (c *Repository) GetFileInfo(ctx context.Context, id string) (FileInfo, error) {
	var fileInfo FileInfo
	err := c.conn.Files.FindOne(ctx, bson.M{"_id": id}).Decode(&fileInfo)
	return fileInfo, err
}

func (c *Repository) FileToWriter(ctx context.Context, id string, w io.Writer) error {
	return c.conn.DownloadFile(ctx, id, w)
}

// func (d *Document) ToMetatags(cnf *config.Config) ([]MetaTag, error) {
// 	var tags []MetaTag

// 	// Проверка обязательных полей
// 	if d.Info.Title == "" {
// 		return nil, errors.New("document title is required")
// 	}

// 	// Citation title
// 	tags = append(tags, MetaTag{
// 		Name:    "citation_title",
// 		Content: d.Info.Title,
// 	})

// 	// Citation publication date
// 	if !d.Meta.CTime.IsZero() {
// 		tags = append(tags, MetaTag{
// 			Name:    "citation_publication_date",
// 			Content: d.Meta.CTime.Format("2006/01/02"),
// 		})
// 	}

// 	// Citation PDF URL (если есть file info)
// 	if d.FileInfo.ID != "" {
// 		domain := cnf.MyDomain
// 		tags = append(tags, MetaTag{
// 			Name:    "citation_pdf_url",
// 			Content: fmt.Sprintf("http://%s/file?id=%s", domain, d.FileInfo.ID),
// 		})
// 	}

// 	// Citation authors
// 	for _, author := range d.Authors {
// 		if author.Lname != "" || author.Fname != "" {
// 			tags = append(tags, MetaTag{
// 				Name:    "citation_author",
// 				Content: fmt.Sprintf("%s, %s", author.Lname, author.Fname),
// 			})
// 		}
// 	}

// 	return tags, nil
// }
