(ns lib.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]
            [lib.model.model :as dbc]
            [lib.pages.pages :as pages]))


(def conn (dbc/db-connect))


(defn render-doc [id] 
  (pages/render-page-doc {:doc (dbc/get-doc conn id)}))
  ;; (pages/render-page :doc {:doc (dbc/get-doc conn id)}))

(defn render-home []
  (pages/render-page-home {}))
  ;; (pages/render-page :home {}))



(defroutes app-routes
  (GET "/" [] (render-home))
  (GET "/doc" [id] (render-doc id))
  (route/not-found "Not Found"))




(def app
  (wrap-defaults app-routes site-defaults))

