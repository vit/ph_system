(ns lib.model.model
  (:require
   [mongo-driver-3.client :as mcl]
   [mongo-driver-3.collection :as mc]))


;; (defn find-doc [c id]
;;   (mc/find-one (c :db) "docs" {:_id id} {:keywordize? false}))


(defn get-ancestors [conn doc]
  (let [id (doc "_id")
        meta (doc "_meta")
        info (doc "info")
        title (info "title")
        d {:id id :title title}
        parent (meta "parent")]
    (if (nil? parent) [d]
        (let [parent-doc (mc/find-one (conn :db) "docs" {:_id parent} {:keywordize? false})
              parent-rez (get-ancestors conn parent-doc)]
          (conj parent-rez d))))
)


(defn get-file-id [conn doc-id]
  (let [
        file (mc/find-one (conn :db) "docs.files" {"_meta.parent" doc-id} {:keywordize? false})
        file-id (if (nil? file) nil (file "_id"))
  ] file-id))



(defn get-doc [conn id]
  (let [doc (mc/find-one (conn :db) "docs" {:_id id} {:keywordize? false})
        children (mc/find (conn :db) "docs" {"_meta.parent" id} {:keywordize? false})
        ancestors (get-ancestors conn doc)
        file-id (get-file-id conn id)]
    (assoc
     doc
     "children" children
     "ancestors" ancestors
     "file-id" file-id)))


(defn db-connect
  []
  (def m (mcl/connect-to-db "mongodb://root:example@mongo:27017/admin"))

  (def client (get m :client))
  (def db (mcl/get-db client "ph3"))
  {:db db})

;; (defn get-doc [conn id]
;;   (find-doc conn id))



;; (defn get_doc_children id
;; 			@docs.find(
;; 				{'_meta.class' => LIB_DOC_CLASS, '_meta.parent' => id}
;; 			#).map do |d|
;; 			).sort( [[ '_meta.ctime', -1]] ).map do |d|
;; 				{
;; 					'_id' => d['_id'],
;; 					'info' => d['info'],
;; 					'authors' => d['authors']
;; 				}
;; 			end
;; 		end
