(ns lib.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]
            [ring.middleware.json :refer [json-response wrap-json-response wrap-json-body]]
            [ring.middleware.cors :refer [wrap-cors]]
            ;; [ring.middleware.defaults :refer [wrap-defaults site-defaults wrap-resource]]
            [ring.middleware.resource :refer [wrap-resource]]
            [ring.util.response :as r]
            [lib.model.model :as dbc]
            [lib.pages.pages :as pages]
            ;; [lib.rpc.rpc :as rpc]
            ))


(def conn (dbc/db-connect))


(defn render-not-found []
  (route/not-found
  (pages/render-page-not-found {})))


(defn render-doc [id] 
  (let [doc (dbc/get-doc conn id)]
    (if (some? doc)
      (pages/render-page-doc {:doc doc})
      (render-not-found)
      )
    )
  
  
  
  )

(defn render-search [q]
  (pages/render-page-search {
                             :res (dbc/search conn q)
                             :search-query q
                             }))

(defn render-file [id]
  (let
   [file (dbc/get-file-by-id conn id)]
    
(if (some? file)
  (let [writer (:writer file)
        info (:info file)]
    (->
     (r/response (ring.util.io/piped-input-stream (fn [ostream] (writer ostream))))
     (r/content-type (info "contentType"))
     (r/header "Cache-Control" "no-cache, must-revalidate, post-check=0, pre-check=0")
     (r/header "Content-Disposition" (format "attachment; filename=\"%s\"" (info "original_filename")))))


  (render-not-found))



    
    
    
    )
  
  
  )
  

(defn render-gfs [id]
  (dbc/gfs-test conn id))



(defn render-home []
  (pages/render-page-home {}))




(defn call-rpc [req]
  
)








(defn wrap-rpc [f]
  (-> f
      (wrap-json-response)
      (wrap-json-body)
      (wrap-cors
       :access-control-allow-origin [#".*"]
       :access-control-allow-methods [:get :put :post :delete :options])))

;; (defn call-rpc [method payload]
;;   {:id "4321"
;;    :title "Paper Title"
;;    :request {:method method
;;              :payload payload}})

(defn call-rpc [method payload]
  (let [result (dbc/call-rpc conn method payload)]
    result))





(defroutes app-routes
  (GET "/" [] (render-home))
  (GET "/doc" [id] (render-doc id))
  (GET "/file" [id] (render-file id))
  (GET "/gfs" [id] (render-gfs id))
  (GET "/search" [q] (render-search q))


  ;; (OPTIONS "/rpc" []
  ;;   (wrap-rpc
  ;;    (fn [request]
  ;;      (r/response ""))))

  ;; (POST "/rpc" []
  ;;   (wrap-rpc
  ;;    (fn handler [request]
  ;;      (println request)
  ;;      (r/response
  ;;       (let [body (:body request)]
  ;;         (call-rpc
  ;;          (get body "method")
  ;;          (get body "payload")))))))





  (render-not-found))


;; (def app
;;   (wrap-defaults (wrap-resource app-routes "public") site-defaults))

(def app
  (wrap-defaults (wrap-resource app-routes "public") 
                 (assoc-in site-defaults [:security :anti-forgery] false)
                 ))


;; (wrap-defaults app-routes (assoc-in site-defaults [:security :anti-forgery] false))

;; (def app
;;   (wrap-defaults app-routes site-defaults))
