package webapp

import (
	// "embed"
	// "io"
	"os"
	"time"
	"fmt"
	"net/http"
	"context"
	// "go.mongodb.org/mongo-driver/bson"
	"html/template"
	"strings"
	"github.com/gin-gonic/gin"
	// "lib/data/mongo"
	"lib/config"
	// . "lib/data/types"
	"lib/data"
)

type App struct {
	// conn *mongo.MongoDB
	config *config.Config
	router *gin.Engine
}

// go:embed templates/**/*
// var embeddedTemplates embed.FS

func GetApp(cnf *config.Config, repository *data.Repository) *App {
	// uri := cnf.MongoString
	// mdb, err := mongo.ConnectMongoDB(uri)
	// return nil

	router := gin.Default()

	router.SetFuncMap(template.FuncMap{
        // "htmlEscape": func(text string) string {
        //     return html.EscapeString(text)
        // },
        "nl2br": func(text string) template.HTML {
            // return template.HTML(strings.ReplaceAll(html.EscapeString(text), "\n", "<br>"))
            return template.HTML(strings.ReplaceAll(text, "\n", "<br>"))
        },
        // "escapeAndNl2br": func(text string) template.HTML {
        //     escaped := html.EscapeString(text)
        //     return template.HTML(strings.ReplaceAll(escaped, "\n", "<br>"))
        // },
    })

	router.LoadHTMLGlob("templates/**/*")

	// tmpl := template.Must(template.New("").ParseFS(embeddedTemplates, "templates/**/*"))
	// router.SetHTMLTemplate(tmpl)


    // funcMap := template.FuncMap{
    //     "nl2br": func(text string) template.HTML {
    //         return template.HTML(strings.ReplaceAll(text, "\n", "<br>"))
    //     },
    // }
    // tmpl := template.New("").Funcs(funcMap)
    // tmpl = template.Must(tmpl.ParseFS(embeddedTemplates, "templates/**/*"))
    // router.SetHTMLTemplate(tmpl)



	// router.Static("/static", "./public")
	router.Static("/static", "./static")
	
	router.GET("/", routeHandler(cnf, repository, renderHome))
	router.GET("/doc", routeHandler(cnf, repository, renderDoc))
	router.GET("/file", routeHandler(cnf, repository, renderFile))
	router.GET("/search", routeHandler(cnf, repository, renderSearch))
	router.NoRoute(routeHandler(cnf, repository, renderNotFound))

	// port := os.Getenv("PORT")
	// if port == "" {
	// 	port = "8080"
	// }
	// router.Run(":" + port)


	return &App{
		// conn: mdb,
		config: cnf,
		router: router,
	}
}


func (a *App) Run() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	a.router.Run(":" + port)
}








type Handler func(*gin.Context, *config.Config, *data.Repository)

func routeHandler(cnf *config.Config, repository *data.Repository, f Handler) func(c *gin.Context) {
	return func(c *gin.Context) {
		f(c, cnf, repository)
	}
}

func callCancelable(f func(context.Context)) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	f(ctx)
}

func renderNotFound(c *gin.Context, cnf *config.Config, repository *data.Repository) {
	c.HTML(http.StatusNotFound, "404.tmpl", gin.H{
		"MenuItems": cnf.MenuItems,
	})
}

func renderHome(c *gin.Context, cnf *config.Config, repository *data.Repository) {
	c.HTML(http.StatusOK, "home.tmpl", gin.H{
		"MenuItems": cnf.MenuItems,
	})
}

func renderDoc(c *gin.Context, cnf *config.Config, repository *data.Repository) {
	id := c.Query("id")

	callCancelable((func(ctx context.Context) {
		doc, err := repository.GetDoc(ctx, id)
		if err != nil {
			renderNotFound(c, cnf, repository)
			return
		}

		citationMetatags, _ := doc.GetCitationMetatags(cnf)

		title := doc.Info.Title
		description := doc.Info.Abstract

		c.HTML(http.StatusOK, "doc.tmpl", gin.H{
			"MenuItems": cnf.MenuItems,
			"doc": doc,
			"PageTitle": title,
    		"PageDescription": description,
			"CitationMetatags": citationMetatags,
		})
	}))
}

func renderSearch(c *gin.Context, cnf *config.Config, repository *data.Repository) {
	query := c.Query("q")

	callCancelable((func(ctx context.Context) {
		results, _ := repository.DoSearch(ctx, query)

		c.HTML(http.StatusOK, "search.tmpl", gin.H{
			"PageTitle": "Search results",
			"SearchResults": results,
			"SearchQuery":   query,
			"MenuItems": cnf.MenuItems,
		})
	}))

}

func renderFile(c *gin.Context, cnf *config.Config, repository *data.Repository) {
	id := c.Query("id")

	callCancelable((func(ctx context.Context) {
		fileInfo, err := repository.GetFileInfo(ctx, id)
		if err != nil {
			renderNotFound(c, cnf, repository)
			return
		}

		contentType := "application/octet-stream"
		if ct := fileInfo.ContentType; ct!="" {
			contentType = ct
		}

		filename := "file"
		if fn := fileInfo.OriginalFilename; fn!="" {
			filename = fn
		}

		c.Header("Content-Type", contentType)
		c.Header("Content-Disposition", fmt.Sprintf("attachment; filename=\"%s\"", filename))
		c.Header("Cache-Control", "no-cache, must-revalidate, post-check=0, pre-check=0")

		if err := repository.FileToWriter(ctx, id, c.Writer); err != nil {
			c.AbortWithStatus(http.StatusInternalServerError)
		}
	}))

}

