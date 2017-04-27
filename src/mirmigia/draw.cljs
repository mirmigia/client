(ns mirmigia.draw)

(defn rgb->str [[r g b]]
  (str "rgb(" r ", " g ", " b ")"))

(defn set-fill-color! [ctx color]
  (set! (.-fillStyle ctx) (rgb->str color)))

(defn fill-rect [ctx [x y] w h]
  (.fillRect ctx x y w h))

(defn fill-circle [ctx [x y] r]
  (.beginPath ctx)
  (.arc ctx x y r 0 (* 2 Math/PI) true)
  (.fill ctx))

(defn set-line-width! [ctx w]
  (set! (.-lineWidth ctx) w))

;; TODO: Remove duplication
(defn set-stroke-color! [ctx color]
  (set! (.-strokeStyle ctx) (rgb->str color)))

(defn stroke-circle [ctx [x y] r]
  (.beginPath ctx)
  (.arc ctx x y r 0 (* 2 Math/PI) true)
  (.stroke ctx))

(defn clear-screen
  ([ctx] (clear-screen ctx [0 0 0]))
  ([ctx color]
   (set-fill-color! ctx color)
   (let [w (-> ctx .-canvas .-width)
         h (-> ctx .-canvas .-height)]
     (fill-rect ctx [0 0] w h))))
