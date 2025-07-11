package types

import (
	"time"

    // "errors"
	"fmt"
	"lib/config"
)

type Document struct {
    ID      string    `bson:"_id"`
    Meta    Meta      `bson:"_meta"`
    Info    Info      `bson:"info"`
    Authors    []Author      `bson:"authors"`
	FileInfo	FileInfo
	Children	[]Document
	Breadcrumbs	[]Breadcrumb
}

type Meta struct {
    Parent  string    `bson:"parent,omitempty"`
    CTime   time.Time `bson:"ctime"`
    MTime   time.Time `bson:"mtime"`
}

type Info struct {
    Title   string    `bson:"title"`
    Subtitle   string    `bson:"subtitle"`
    Abstract   string    `bson:"abstract"`
}

type Author struct {
    Fname   string    `bson:"fname"`
    Lname   string    `bson:"lname"`
}

type Breadcrumb struct {
    ID    string `bson:"_id"`
    Title string `bson:"info.title"`
}

type FileInfo struct {
    ID      string    `bson:"_id"`
    Meta    FileMeta  `bson:"_meta"`
	ContentType	string	`bson:"contentType"`
	Length		int	`bson:"length"`
	OriginalFilename	string	`bson:"original_filename"`
}

type FileMeta struct {
    Parent  string    `bson:"parent,omitempty"`
    CTime   time.Time `bson:"ctime"`
    MTime   time.Time `bson:"mtime"`
}

type MetaTag struct {
    Name string
    Content string
}

func (d *Document) GetCitationMetatags(cnf *config.Config) ([]MetaTag, error) {
	var tags []MetaTag

	// Проверка обязательных полей
	// if d.Info.Title == "" {
	// 	return nil, errors.New("document title is required")
	// }

	// Citation title
	tags = append(tags, MetaTag{
		Name:    "citation_title",
		Content: d.Info.Title,
	})

	// Citation publication date
	if !d.Meta.CTime.IsZero() {
		tags = append(tags, MetaTag{
			Name:    "citation_publication_date",
			Content: d.Meta.CTime.Format("2006/01/02"),
		})
	}

	// Citation PDF URL (если есть file info)
	if d.FileInfo.ID != "" {
		domain := cnf.MyDomain
		tags = append(tags, MetaTag{
			Name:    "citation_pdf_url",
			Content: fmt.Sprintf("http://%s/file?id=%s", domain, d.FileInfo.ID),
		})
	}

	// Citation authors
	for _, author := range d.Authors {
		if author.Lname != "" || author.Fname != "" {
			tags = append(tags, MetaTag{
				Name:    "citation_author",
				Content: fmt.Sprintf("%s, %s", author.Lname, author.Fname),
			})
		}
	}

	return tags, nil
}
