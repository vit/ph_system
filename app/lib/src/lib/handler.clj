(ns lib.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]
            [ring.util.response :as r]
            [lib.model.model :as dbc]
            [lib.pages.pages :as pages]))


(def conn (dbc/db-connect))

(defn render-doc [id] 
  (pages/render-page-doc {:doc (dbc/get-doc conn id)}))

(defn render-search [q]
  (pages/render-page-search {:res (dbc/search conn q)}))

(defn render-file [id]
  (let
   [file (dbc/get-file-by-id conn id)
    writer (:writer file)
    info (:info file)]
    (->
     (r/response (ring.util.io/piped-input-stream (fn [ostream] (writer ostream))))
     (r/content-type (info "contentType"))
     (r/header "Cache-Control" "no-cache, must-revalidate, post-check=0, pre-check=0")
     (r/header "Content-Disposition" (format "attachment; filename=\"%s\"" (info "original_filename"))))))
  

(defn render-gfs [id]
  (dbc/gfs-test conn id))



(defn render-home []
  (pages/render-page-home {}))

(defroutes app-routes
  (GET "/" [] (render-home))
  (GET "/doc" [id] (render-doc id))
  (GET "/file" [id] (render-file id))
  (GET "/gfs" [id] (render-gfs id))
  (GET "/search" [q] (render-search q))
  (route/not-found "Not Found"))




(def app
  (wrap-defaults app-routes site-defaults))

