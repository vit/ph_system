(ns lib.pages.doc.meta-citation
  (:require
   [hiccup2.core :as h]))

(defn meta-authors [authors]
  (h/html
   (let [author_strings (for [a authors] (str (a "lname") ", " (a "fname")))]
     (for [a author_strings]
       [:meta {:name "citation_author" :content a}]))))

(defn meta-title [title]
  (h/html
   [:meta {:name "citation_title" :content title}]))

(defn meta-citation [doc]
  (let [info (doc "info")
        title (info "title")
        subtitle (info "subtitle")
        abstract (info "abstract")
        authors (doc "authors")
        children (doc "children")
        ancestors (doc "ancestors")]
    (h/html
     (meta-authors authors)
     (meta-title title))))
