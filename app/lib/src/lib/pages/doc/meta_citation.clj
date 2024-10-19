(ns lib.pages.doc.meta-citation
  (:require
   [hiccup2.core :as h]
   [clj-time.format :as t]

   ))

(defn meta-title [title]
  (h/html
   [:meta {:name "citation_title" :content title}]))

(defn meta-publication-date [date]
  (h/html
   [:meta {:name "citation_publication_date" :content date}]))

(defn meta-pdf-url [id]
  (h/html
   [:meta {:name "citation_pdf_url" :content (str "http://" (System/getenv "LIB_DOMAIN_NAME") "/file?id=" id)}]))

(defn meta-authors [authors]
  (h/html
   (let [author_strings (for [a authors] (str (a "lname") ", " (a "fname")))]
     (for [a author_strings]
       [:meta {:name "citation_author" :content a}]))))



(defn meta-tags-citation [doc]
  (let [id (doc "_id")
        meta (doc "_meta")
        ctime (meta "ctime")
        info (doc "info")
        title (info "title")
        subtitle (info "subtitle")
        abstract (info "abstract")
        authors (doc "authors")
        children (doc "children")
        ancestors (doc "ancestors")

        pub-time (t/unparse (t/formatter "YYYY/mm/dd") (t/parse ctime))
        ]
    (h/html
     (meta-title title)
     (meta-publication-date pub-time)
    ;;  (meta-publication-date ctime)
     (meta-pdf-url id)
     (meta-authors authors)
     )))

