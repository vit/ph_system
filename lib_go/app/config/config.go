package config

import (
	"os"
    // "log"
)

type Config struct {
	MenuItems []MenuItem
	MongoString string
    // UrlBase string
    MyDomain string
}

func GetConfig() (*Config, error) {
    // log.Println("GetConfig()")
	return &Config{
		MenuItems: getMenuItems(),
		MongoString: getMongoString(),
        // UrlBase myURLBase(),
        MyDomain: myDomain(),
	}, nil
}

type MenuItem struct {
	ID   string
	Name string
	URL  string
}

func myDomain() string {
    domain := os.Getenv("LIB_DOMAIN_NAME")
    if domain == "" {
        domain = "lib.physcon.ru"
    }
    // return "http://" + domain
    return domain
}

func makeURL(envVar string) string {
    domain := os.Getenv(envVar)
    if domain == "" {
        return "#" // или какое-то значение по умолчанию
    }
    return "http://" + domain
}

func getMenuItems() []MenuItem {
    return []MenuItem{
        {ID: "ipacs", Name: "IPACS Home", URL: makeURL("IPACS_DOMAIN_NAME")},
        {ID: "coms", Name: "CoMS", URL: makeURL("COMS_DOMAIN_NAME")},
        {ID: "cap", Name: "CAP Journal", URL: makeURL("CAP_DOMAIN_NAME")},
        {ID: "lib", Name: "Library", URL: makeURL("LIB_DOMAIN_NAME")},
        {ID: "conferences", Name: "Conferences", URL: makeURL("CONF_DOMAIN_NAME")},
        {ID: "album", Name: "Album", URL: makeURL("ALBUM_DOMAIN_NAME")},
    }
}

func getMongoString() string {
    mongo := os.Getenv("MONGO_URI")
    if mongo == "" {
        mongo = "mongodb://root:example@mongo:27017"
    }
    println("MONGO_URI = ", mongo)
    return mongo
}
