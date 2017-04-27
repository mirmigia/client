(ns mirmigia.core
  (:require [mirmigia.api    :as api]
            [mirmigia.db     :as db]
            [mirmigia.draw   :as draw]
            [mirmigia.events :as events]
            [rum.core :as rum]))

(enable-console-print!)

(defn square 
  "Squares the value of `x`."
  [x]
  (* x x))

(defmethod events/handle-event :canvas/clicked
  [state [_ ev]]
  ;; Adjust to X + Y on canvas
  (let [target (.-originalTarget ev)
        x (- (.-pageX ev) (.-offsetLeft target))
        y (- (.-pageY ev) (.-offsetTop target))
        selected? (fn [{:keys [pos radius]}]
                    (let [[cel-x cel-y] pos]
                      (< (+ (square (- x cel-x) (square (- y cel-y))))
                         (square radius))))]
    (update-in state [:sector :celestials] 
               #(map (fn [cel]
                       (if (selected? cel)
                         (assoc cel :selected? true)
                         (assoc cel :selected? false)))
                     %))))

(defn render! [ctx {:keys [sector]}]
  (draw/clear-screen ctx)
  (doseq [{:keys [pos radius selected?]} (:celestials sector)]
    (draw/set-fill-color! ctx [255 255 255])
    (draw/fill-circle ctx pos radius)
    (when selected?
      (draw/set-stroke-color! ctx [0 255 0])
      (draw/set-line-width! ctx 3)
      (draw/stroke-circle ctx pos (+ radius 4)))))

(defn add-event-listeners! 
  "Add event listeners to the given element."
  [elem listeners]
  (doseq [[type f] listeners]
    (.addEventListener elem (name type) f)))

;; TODO: take renderer as parameter
(def canvas-mixin
  "Mixin to be used with a canvas element. Starts the renderer, ensures
  cleanup and that the canvas is not changed when data is changed."
  {:did-mount
   (fn [state]
     (let [node (rum/dom-node state)
           ctx (.getContext node "2d")
           renderer (fn this [dt]
                      (render! ctx @db/app-state)
                      (js/requestAnimationFrame this))]
       (add-event-listeners! node {:click #(events/dispatch! [:canvas/clicked %])})
       ;; Start renderer
       (js/requestAnimationFrame renderer)
       (merge state {::renderer renderer})))
   :will-unmount
   (fn [state]
     ;; FIXME: destroy renderer
     state)
   :should-update (constantly false)})

(rum/defc canvas < canvas-mixin
  "Canvas used for rendering the main game. `w` and `h` represent
  the width and height of the canvas element respectively."
  [w h]
  [:canvas {:width w :height h}])

(rum/defc ship-view [ships]
  [:table
   [:thead
    ;; Basically all the (keys ships) made human readable.
    [:th "ID"]
    [:th "Name"]
    [:th "Type"]
    [:th "Range"]
    [:th "Location"]]
   [:tbody
    (for [s ships]
      [:tr {:key (:id s)}
       [:td (:id s)]
       [:td (:name s)]
       [:td (str (:type s))]
       [:td (:range s)]
       [:td (:location s)]])]])

(rum/defc main-page < rum/reactive
  "Main page used for the UI. Also contains the game canvas."
  [db]
  (let [state (rum/react db)]
    [:div#main
     (canvas 800 600)
     [:div#ships
      [:h3 "Available Ships"]
      (ship-view (:ships state))]]))

(defn mount-rum! [elem]
  (rum/mount (main-page db/app-state) elem))

(defn on-js-reload
  "Called in development when a change is made."
  []
  (mount-rum! (.getElementById js/document "app")))

(defn ^:export main
  "Application entry point."
  []
  ;; Load app state
  (swap! db/app-state merge {:sector (api/fetch-sector)
                             :ships  (api/fetch-ships)})
  ;; Initialize UI
  (mount-rum! (.getElementById js/document "app")))
