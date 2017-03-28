(ns mirmigia.core
  (:require [mirmigia.api  :as api]
            [mirmigia.db   :as db]
            [mirmigia.draw :as draw]))

(enable-console-print!)

(defn on-js-reload
  "Called in development when a change is made."
  [])

(defn render! [ctx {:keys [sector]}]
  (draw/clear-screen ctx)
  (doseq [{:keys [pos radius]} (:celestials sector)]
    (draw/set-fill-color! ctx [255 255 255])
    (draw/fill-circle ctx pos radius)))

(defn ^:export main
  "Application entry point."
  []
  ;; Load app state
  (swap! db/app-state merge {:sector (api/fetch-sector)
                             :ships  (api/fetch-ships)})
  ;; Start renderer
  (let [canvas (.getElementById js/document "canvas")
        ctx (.getContext canvas "2d")]
    ((fn this [dt]
       (render! ctx @db/app-state)
       (js/requestAnimationFrame this)))))
