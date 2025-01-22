(defproject lib "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.10.0"]
                 [compojure "1.6.1"]
                 [ring/ring-defaults "0.3.2"]
                 [ring/ring-json "0.5.1"]
                 [ring-cors/ring-cors "0.1.13"]
                 [selmer "1.12.61"]
                 [hiccup "2.0.0-RC3"]
                 ;; The underlying driver -- any newer version can also be used
                 [org.mongodb/mongodb-driver-sync "4.11.1"]
                 ;; This wrapper library
                 [mongo-driver-3 "0.8.0"]]
  :plugins [[lein-ring "0.12.5"]]
  :ring {:handler lib.handler/app}
  :profiles
  {:dev {:dependencies [[javax.servlet/servlet-api "2.5"]
                        [ring/ring-mock "0.3.2"]]}})
