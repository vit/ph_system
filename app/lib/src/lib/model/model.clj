(ns lib.model.model
  (:require
   [mongo-driver-3.client :as mcl]
   [mongo-driver-3.collection :as mc])
  (:import (com.mongodb.client.gridfs GridFSBuckets)))

(defn mongo-string [s] (org.bson.BsonString. s))
(defn mongo-grid-fs [db coll-name] (GridFSBuckets/create db coll-name))

(defn mongo-find [conn coll-name query] (mc/find (conn :db) coll-name query {:keywordize? false}))
(defn mongo-find-one [conn coll-name query] (mc/find-one (conn :db) coll-name query {:keywordize? false}))

(defn mongo-write-file-to-stream [conn id ostream]
  (.downloadToStream (conn :gfs) (mongo-string id) ostream))


(defn find-doc [conn query] (mongo-find-one conn "docs" query))
(defn find-file-info [conn query] (mongo-find-one conn "docs.files" query))
(defn find-docs [conn query] (mongo-find conn "docs" query))


(defn get-file-by-id [conn id]
  {:writer (fn [ostream] (mongo-write-file-to-stream conn id ostream))
   :info (find-file-info conn {"_id" id})})


(defn get-doc-breadcrumbs [conn doc]
  (let [id (doc "_id")
        meta (doc "_meta")
        info (doc "info")
        title (info "title")
        d {:id id :title title}
        parent (meta "parent")]
    (if (nil? parent) [d]
        (let [parent-doc (find-doc conn {:_id parent})
              parent-rez (get-doc-breadcrumbs conn parent-doc)]
          (conj parent-rez d)))))

(defn get-doc [conn id]
  (let [doc (find-doc conn {:_id id})]
    (assoc
     doc
     "file-info" (find-file-info conn {"_meta.parent" id})
     "children" (find-docs conn {"_meta.parent" id})
     "breadcrumbs" (get-doc-breadcrumbs conn doc))))


(defn db-connect []
  (let [mongo (mcl/connect-to-db "mongodb://root:example@mongo:27017/admin")
        client (get mongo :client)
        db (mcl/get-db client "ph3")
        gfs (mongo-grid-fs db "docs")]
    {:db db
     :gfs gfs}))


(defn search [conn q]
  (let [docs (find-docs conn {"$text" {"$search" q}})]
    docs))




;; For debug purposes

(defn gfs-test [conn id]
  (let [;; obj-id (org.bson.types.ObjectId. id)
        bucket (conn :gfs)
        bucket-name (.getBucketName bucket)
        bucket-string (.toString bucket)
        files-iterable (.find bucket)
        ;; files-iterable (.find bucket (org.bson.Document. {"id" (mongo-string "02f7ded2623f")}))
        ;; file-stream (.openDownloadStream bucket (mongo-string "02f7ded2623f"))
        file-stream (.openDownloadStream bucket (mongo-string id))

        file-stream-first-byte (.read file-stream)

        ;; files-string (.toString files-iterable)
        files-strings-list (map (fn [f] (.toString f)) files-iterable)
        ;; files-count (count files-strings-list)
        ]
    (str
     "Hello gfs-test"
     "<br>"
     "id: " id
     "<br>"
     "bucket-name: " bucket-name
     "<br>"
     "bucket-string: " bucket-string
     "<br>"
     "file-stream-first-byte: " file-stream-first-byte
     "<br>"

     "files-strings-list:<br>"
     (apply str files-strings-list)
     "<br>"))
  ;;  (let [obj-id (org.bson.types.ObjectId. id)] (.class obj-id))
  ;; (let [obj-id (org.bson.types.ObjectId. id)
  ;;       bucket (conn :gfs)]
  ;;   (.downloadToStream bucket obj-id ostream)
  ;;   (spit ostream (.class (.find bucket nil)))
    ;; .forEach (gridFSFile -> System.out.println (gridFSFile.getFilename ()));
;; (spit ostream "Hello from model!!!")    
    ;; )
  )
