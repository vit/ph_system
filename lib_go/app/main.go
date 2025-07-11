package main

import (
	"context"
	"lib/config"
	"lib/data"
	"lib/webapp"
)

func main() {

	cnf, err := config.GetConfig()
	if err != nil {
		panic("Failed to load Config: " + err.Error())
	}

	repository, err2 := data.GetRepository(cnf)
	if err2 != nil {
		panic("Failed to start Repository: " + err2.Error())
	}

	defer repository.Close( context.Background() )

	app := webapp.GetApp(cnf, repository)
	app.Run()

}
