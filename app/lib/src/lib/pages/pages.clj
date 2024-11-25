;; (ns lib.pages.pages
(ns lib.pages.pages
  (:require 
   [lib.pages.top-menu :as tm]
   [lib.pages.doc.meta-citation :as mc]
   [hiccup2.core :as h]
   [hiccup.util :as hu]
   ))



(defn author_to_text [author]
  (str (author "fname") " " (author "lname")))


(defn render-authors [authors]
  (h/html
   (let [author_strings (for [a authors] (author_to_text a))]
     [:span (clojure.string/join ", " author_strings)])))



(defn render-one-child [elm]
  (let [id (elm "_id")
        info (elm "info")
        authors (elm "authors")
        title (info "title") 
        subtitle (info "subtitle")
        ]
    (h/html
     [:div {:style "font-family: serif; font-weight: 900; font-size: 0.85em;"} (render-authors authors)]
     [:div
      [:a {:href (format "/doc?id=%s" id)} title]]
     [:div
      [:i subtitle]])))

(defn render-children [children]
  (h/html
   [:ul
    (for [c children]
      [:li {:style "margin-top: 0.3rem;"}
       (render-one-child c)])]))




(defn page-home [args]
  (h/html
          [:div {:class "doc-page"
                 :style "text-align: center; padding-top: 2rem;"}
           [:div {:class "top_dirs"}
            [:div {:class "block" :style "padding: 1rem;"}
             [:div {:class "link" :style "padding: 0.2rem;"}
              [:b
               [:a {:href "/doc?id=b80d5dcef9f3"} "Conferences proceedings"]]
              [:div {:class "info" :style "padding: 0.2rem;"}
               [:i "See "
                [:a {:href "http://conf.physcon.ru/"} "conferences list"]
                [:span " for extra information about past and future IPACS conferences."]]]]]
            [:div {:class "block" :style "padding: 1rem;"}
             [:div {:class "link" :style "padding: 0.2rem;"}
              [:b
               [:a {:href "/doc?id=29e59dce4f11"} "CYBERNETICS AND PHYSICS Journal"]]
              [:div {class "info" :style "padding: 0.2rem;"}
               [:i "See "
                [:a {:href "http://cap.physcon.ru/"} "journal site"]
                [:span " for more information."]]]]]
            [:div {:class "block" :style "padding: 1rem;"}
             [:div {:class "link" :style "padding: 0.2rem;"}
              [:b
               [:a {:href "/doc?id=8bb18b51f9a0"} "Open Archive"]]
              [:div {:class "info" :style "padding: 0.2rem;"}
               [:i "The documents, submitted by IPACS members"]]]]]]))
         

(defn page-not-found [args]
  (h/html
   [:div {:class "doc-page"
          :style "text-align: center; padding-top: 5rem;"}
    [:div {:class "top_dirs"}
     [:div {:class "block" :style "padding: 1rem; font-size: 4rem;"}
      "404"]
     [:div {:class "block" :style "padding: 1rem; font-size: 2rem;"}
      "Page not found"]]]))
         






(defn render-breadcrumbs [breadcrumbs]
  [:p
   [:a {:href "/"} "Root"]
   (for [a breadcrumbs]
     [:span " / "
      [:a {:href (str "/doc?id=" (a :id))} (a :title)]])])

(defn page-doc [args]
  (h/html
   (let [doc (args :doc)
         info (doc "info")
         title (info "title")
         subtitle (info "subtitle")
         abstract (info "abstract")
         authors (doc "authors")
         file-info (doc "file-info")
         file-id (if (some? file-info) (file-info "_id") nil)
         children (doc "children")
         breadcrumbs (doc "breadcrumbs")]
     [:div {:class "doc-page"
            :sstyle "text-align: center;"}
          ;;  [:p (str "args: " args)]
      ;; [:p (str "doc: " doc)]
          ;;  [:p (str "info: " info)]
      [:div {:style ""} (render-breadcrumbs breadcrumbs)]
      [:h2 {:style "text-align: center;"} title]
      [:p {:style "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 0.85em; text-align: center;"} subtitle]
      [:p {:style "font-family: serif; font-weight: 900; font-size: 0.85em; text-align: center;"} (render-authors authors)]
      ;; [:p {:style "font-family: Verdana, Arial, Helvetica, sans-serif;"} abstract]
      [:p {:style "font-family: Verdana, Arial, Helvetica, sans-serif;"} 
       (hu/raw-string
       (clojure.string/replace
        (hu/escape-html
        abstract
         )
        #"\r\n|\n|\r" "<br />\n")
)
       
       
       ]
      ;; (if (some? file-info)
      ;;   [:p {:style "font-family: Verdana, Arial, Helvetica, sans-serif;"} file-info])
      (if (some? file-id)
        [:p {:style "font-family: Verdana, Arial, Helvetica, sans-serif;"} "File: "
         [:a {:href (str "/file?id=" file-id)} "download"]])
      [:div {:style ""} (render-children children)]])))





(defn page-search [args]
  (h/html
   (let [res (args :res)
         ]
     [:div {:class "doc-page"
       :sstyle "text-align: center;"}
 [:h2 {:style "text-align: center;"} "Search results"]
     [:div {:class "doc-page"
            :sstyle "text-align: center;"}
      [:div {:style ""} (render-children res)]
      ]])))









(defn render-top-menu-block []
  (h/html
   [:div {:class "" :style "background-color: #fff;"}
    [:nav {:class "" :style ""}
     [:div {:style "display: flex; justify-content: space-between; margin-right: auto; margin-left: auto; align-items: center;"}
      [:div {:style "display: flex; align-items: center;"}
       [:ul {:style "margin: 10px; padding-left: 0;"}
        (for [mi tm/menu]
          (let [bg-style (if (= (mi :id) "lib") "background-color: #357edd;" "")
                text-style (if (= (mi :id) "lib") "color: rgba(255, 255, 255, .9);" "")]
            [:li {:style (format "margin: 0px; padding: 10px; display: inline-block; font-weight: 400; font-size: 1.25rem; %s", bg-style)}
             [:a  {:style (format "text-decoration: none; font-size: 1.25rem; color: rgba(0, 0, 0, .9); %s" text-style)
                   :href (mi :url)} (mi :name)]]))]]]]]))


(defn render-title-block [args]
  (h/html
 [:div {:class "" :style "background-color: #357edd;"}
  [:nav {:class "" :style "padding-left: 2rem; padding-right: 2rem; padding-top: 1rem; padding-bottom: 1rem;"}
   [:div {:style "display: flex; justify-content: space-between; margin-right: auto; margin-left: auto; align-items: center;"}
    [:a {:href "/" :style "font-size: 1.5rem; text-decoration: none; font-weight: 200; display: inline-block; color: rgba(255, 255, 255, .9);"}
     "IPACS Electronic library"]

        [:div {:style "display: flex; align-items: center; justify-content: center; width: 50%;"}
         [:form {:action "/search" :method "get" :style "display: flex; align-items: center; justify-content: center; margin: 0; width: 100%;"}
          [:input {
                   :name "q"
                   :placeholder "Search"
                   :style "font-size: 1.25rem; display: flex; align-items: center; justify-content: center; width: 100%; min-width: 100px;"
                   :value (let [search-query (args :search-query)]
                            (if (not-empty search-query) search-query ""))
                   }
           ]
         ]
         
         ]
        [:div {:style "display: flex; align-items: center;"} ""]



    ;; [:div {:style "display: flex; align-items: center;"}
    ;;  [:ul {:style "margin: 10px; padding-left: 0;"}
    ;;   (for [mi tm/menu]
    ;;     [:li {:style "margin: 0px; padding: 10px; display: inline-block; font-weight: 400; font-size: 1.25rem;"}
    ;;      [:a  {:style "text-decoration: none; font-size: 1.25rem; color: rgba(0, 0, 0, .9);"
    ;;            :href (mi :url)} (mi :name)]])]]
    ]]])
  )




;; (defn render-layout [args]
(defn render-layout [{:keys [page-title page-description page-body] :as args}]
  (h/html
   [:html {:style "line-height: 1.15;"}
    [:head
     [:meta {:charset "utf-8"}]
     [:meta {:name "viewport" :content "width=device-width,minimum-scale=1"}]


     [:title {} (str
                 (if (not-empty page-title) (str page-title " | ") "")
                 "IPACS Electronic Library")]

     (if (not-empty page-description)
       [:meta {:name "description" :content page-description}] "")

     (args :meta-tags)]

    [:body {:style "margin: 0; background-color: #f4f4f4; font-family: avenir next, avenir, sans-serif;"}
     [:header
      (render-top-menu-block)
      (render-title-block args)]

     [:main {:style "padding-bottom: 1rem;"}
      [:div {:style "display: flex; margin-right: auto; margin-left: auto; margin-top: .5rem; max-width: 64rem;"}
       [:article {:style "margin-right: auto; margin-left: auto; padding-left: 2rem; padding-right: 2rem; ppadding-top: 4rem; padding-bottom: 4rem; max-width: 48rem;"}
        [:div {:style "font-size: 1.25rem;"} page-body]]]]

     [:footer {:style "padding: 1rem; background-color: #357edd;"}
      [:div {:style "display: flex; justify-content: space-between; background-color: transparent;"}
       [:a {:style "display: inline-block; font-size: 1.25rem; text-decoration: none; padding-left: 1rem; padding-right: 1rem; padding-top: .5rem; padding-bottom: .5rem; color: rgba(255, 255, 255, .7); font-weight: 400; background-color: transparent;"
            :href "https://www.ipme.ru/ipme/labs/ccs/"}
        "©  The Laboratory \"Control of Complex Systems\", IPME RAS 2003 — 2024"]]]]]))




(defn doc-meta-tags [args]
  (let [doc (args :doc)]
    (if doc
      (mc/meta-tags-citation doc) nil)))

(defn doc-page-title [args]
  (let [doc (args :doc)
        info (doc "info")
        title (info "title")]
    title))

(defn doc-page-description [args]
  (let [doc (args :doc)
        info (doc "info")
        description (info "abstract")]
    (if (not-empty description) description nil)))


(defn render-page-home
  [args]
  (str (h/html
        (render-layout {:page-body (page-home args)
                        :meta-tags nil}
                ))))

(defn render-page-not-found
  [args]
  (str (h/html
        (render-layout {:page-body (page-not-found args)}))))



(defn render-page-doc [args]
  (let [meta-tags (doc-meta-tags args)
        page-title (doc-page-title args)
        page-description (doc-page-description args)
        page-body (page-doc args)
        ]
    (str (h/html
          (render-layout
           {:page-body page-body
            :meta-tags meta-tags
            :page-title page-title
            :page-description page-description
            }
           )))))

(defn render-page-search [args]
  (let [meta-tags (doc-meta-tags args)
        page-body (page-search args)]
    (str (h/html
          (render-layout
           {:page-body page-body
            :meta-tags meta-tags
            :page-title "Search results"
            :search-query (args :search-query)
            })))))


