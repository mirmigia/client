(ns mirmigia.core
  (:require [mirmigia.api  :as api]
            [mirmigia.draw :as draw]))

(enable-console-print!)

(defonce app-state (atom {:sector (api/fetch-sector)
                          :ships  (api/fetch-ships)}))

(defn on-js-reload
  "Called in development when a change is made."
  [])

(defn render [ctx {:keys [sector]}]
  (draw/clear-screen ctx)
  (doseq [{:keys [pos radius]} (:celestials sector)]
    (draw/set-fill-color! ctx [255 255 255])
    (draw/fill-circle ctx pos radius)))

(defn ^:export main
  "Application entry point."
  []
  (let [canvas (.getElementById js/document "canvas")
        ctx (.getContext canvas "2d")]
    (js/requestAnimationFrame
     (fn raf [dt]
       (render ctx @app-state)
       (js/requestAnimationFrame raf)))))
