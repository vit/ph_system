(ns lib.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]
            [lib.model.model :as dbc]
            [lib.pages.pages :as pages]))


(def conn (dbc/db-connect))


(defn render-doc [id] 
  (pages/render-page-doc {:doc (dbc/get-doc conn id)}))

;; (defn render-file [id] 
;; (ring.util.io/piped-input-stream
;;  (fn [ostream]
;;   ;;  (spit ostream "Hello!!!")
;;    (dbc/write_doc_file_to_stream conn id ostream)
;;    ))
;; )


(defn render-file [id]
  (let
   [file (dbc/get-file-by-id conn id)
    writer (:writer file)]
    (ring.util.io/piped-input-stream
     (fn [ostream]
       (writer ostream)))))
  





(defn render-gfs [id]
     (dbc/gfs-test conn id))


(defn render-home []
  (pages/render-page-home {}))

(defroutes app-routes
  (GET "/" [] (render-home))
  (GET "/doc" [id] (render-doc id))
  (GET "/file" [id] (render-file id))
  (GET "/gfs" [id] (render-gfs id))
  (route/not-found "Not Found"))




(def app
  (wrap-defaults app-routes site-defaults))

