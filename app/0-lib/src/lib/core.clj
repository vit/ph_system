(ns lib.core
  (:require [compojure.core :refer :all]
          [compojure.route :as route])
  (:gen-class))



(defroutes app
  (GET "/" [] "<h1>Hello World</h1>")
  (route/not-found "<h1>Page not found</h1>"))



;; (defn -main
;;   "I don't do a whole lot ... yet."
;;   [& args]
;;   (println "Hello, World 123!"))



;; (defn app
;;   [request]
;;   (let [{:keys [uri request-method]} request]
;;     {:status 200
;;      :headers {"Content-Type" "text/plain"}
;;      :body (format "You requested %s %s"
;;                    (name request-method)
;;                    uri)}))




(defn page-index
  [request]
  {:status 200
   :headers {:content-type "text/plain"}
   :body "Learning Web for Clojure"})

(defn page-hello
  [request]
  {:status 200
   :headers {:content-type "text/plain"}
   :body "Hi there and keep trying!"})

(defn page-404
  [request]
  {:status 404
   :headers {:content-type "text/plain"}
   :body "No such a page."})



;; (require '[compojure.core
;;            :refer [GET defroutes]])

;; (defroutes app
;;   ;; (GET "/"      request (page-index request))
;;   ;; (GET "/hello" request (page-hello request))
;;   page-404)




;; (:require [compojure.core :refer :all]
;;           [compojure.route :as route])

;; (defroutes app
;;   (GET "/" [] "<h1>Hello World</h1>")
;;   (route/not-found "<h1>Page not found</h1>"))





(println "Hello Again!")

(require '[ring.adapter.jetty :refer [run-jetty]])
(run-jetty app {:port 8080 :join? true})


