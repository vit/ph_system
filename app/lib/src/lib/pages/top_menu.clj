(ns lib.pages.top-menu)


(defn make-url [name]
  (str "http://" (System/getenv name)))


(def menu [{:id "ipacs" :name "IPACS Home" :url (make-url "IPACS_DOMAIN_NAME")}
                 {:id "coms" :name "CoMS" :url (make-url "COMS_DOMAIN_NAME")}
                 {:id "cap" :name "CAP Journal" :url (make-url "CAP_DOMAIN_NAME")}
                 {:id "lib" :name "Library" :url (make-url "LIB_DOMAIN_NAME")}
                 {:id "conferences" :name "Conferences" :url (make-url "CONF_DOMAIN_NAME")}
                 {:id "album" :name "Album" :url (make-url "ALBUM_DOMAIN_NAME")}])



