;; (ns lib.pages.pages
(ns lib.pages.pages
  (:require 
  ;;  [selmer.parser :as s]
   [lib.pages.top-menu :as tm]
   [hiccup2.core :as h]
   ))



(defn author_to_text [author]
  (str (author "fname") " " (author "lname")))


(defn render-authors [authors]
  (h/html
   (let [author_strings
         (for [a authors]
           (author_to_text a))
         author_strings_separated
         (interpose ", " author_strings)]
     [:span (clojure.string/join ", " author_strings)])))



(defn render-one-child [elm]
  (let [id (elm "_id")
        info (elm "info")
        title (info "title")]
    (h/html
     [:div
      [:a {:href (format "/doc?id=%s" id)} title]])))

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
         





(defn render-ancestors [ancestors]
  [:p
   [:a {:href "/"} "Root"]
   (for [a ancestors]
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
         children (doc "children")
         ancestors (doc "ancestors")]
     [:div {:class "doc-page"
            :sstyle "text-align: center;"}
          ;;  [:p (str "args: " args)]
      ;; [:p (str "doc: " doc)]
          ;;  [:p (str "info: " info)]
      [:div {:style ""} (render-ancestors ancestors)]
      [:h2 {:style "text-align: center;"} title]
      [:p {:style "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 0.85em; text-align: center;"} subtitle]
      [:p {:style "font-family: serif; font-weight: 900; font-size: 0.85em; text-align: center;"} (render-authors authors)]
      [:p {:style "font-family: Verdana, Arial, Helvetica, sans-serif;"} abstract]
      [:div {:style ""} (render-children children)]])))







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


(defn render-title-block []
  (h/html
 [:div {:class "" :style "background-color: #357edd;"}
  [:nav {:class "" :style "padding-left: 2rem; padding-right: 2rem; padding-top: 1rem; padding-bottom: 1rem;"}
   [:div {:style "display: flex; justify-content: space-between; margin-right: auto; margin-left: auto; align-items: center;"}
    [:a {:href "/" :style "font-size: 1.5rem; text-decoration: none; font-weight: 200; display: inline-block; color: rgba(255, 255, 255, .9);"}
     "IPACS Electronic library"]

    ;; [:div {:style "display: flex; align-items: center;"}
    ;;  [:ul {:style "margin: 10px; padding-left: 0;"}
    ;;   (for [mi tm/menu]
    ;;     [:li {:style "margin: 0px; padding: 10px; display: inline-block; font-weight: 400; font-size: 1.25rem;"}
    ;;      [:a  {:style "text-decoration: none; font-size: 1.25rem; color: rgba(0, 0, 0, .9);"
    ;;            :href (mi :url)} (mi :name)]])]]
    ]]])
  )




(defn render-layout [args page]
  (h/html
   [:html {:style "line-height: 1.15;"}
    [:head
     [:meta {:charset "utf-8"}]
     [:title {} "************* | IPACS Electronic Library"]
     [:meta {:name "viewport" :content "width=device-width,minimum-scale=1"}]
     [:meta {:name "description" :content "****************"}]]
    [:body {:style "margin: 0; background-color: #f4f4f4; font-family: avenir next, avenir, sans-serif;"}
     [:header
        (render-top-menu-block)
        (render-title-block)
      ]
    ;;  [:div "bredcrumbs 1"]
     [:main {:style "padding-bottom: 16rem;"}
      ;; [:div "bredcrumbs 2"]
      [:div {:style "display: flex; margin-right: auto; margin-left: auto; margin-top: .5rem; max-width: 64rem;"}
       [:article {:style "margin-right: auto; margin-left: auto; padding-left: 2rem; padding-right: 2rem; ppadding-top: 4rem; padding-bottom: 4rem; max-width: 48rem;"}
        ;; [:header {}
        ;;  [:h1 {:style "font-size: 3rem;"}
        ;;   "Qwqrwe wer dfgs grf er"]]
        [:div {:style "font-size: 1.25rem;"} page]]]]
     [:div {:class "bottom"}]]]
  ))



(def pages {
            ;; :home (fn [args] "home page")
            :home page-home
            :doc page-doc
})



(defn render-page
  [page args]
  (str (h/html
        (render-layout {}
                ((pages page) args)))))












;; (defn render-page
;;   [page args]
;;   (s/render-file "templates/layouts/application.html"
;;                  {:content
;;                   (s/render-file (format "templates/%s.html" page) args)
;;                   :ipacs_menu tm/menu}))



