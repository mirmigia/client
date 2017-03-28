(ns mirmigia.api)

;; TODO: use spec

(defn fetch-sector []
  {:id "ACD234"
   :dimensions [32, 32]
   :celestials [{:id "CEL222", :pos [100, 100], :radius 8}
                {:id "PLA594", :pos [32, 560],  :radius 9}
                {:id "ASD666", :pos [123, 145], :radius 12.3}
                {:id "YUP553", :pos [444, 323], :radius 4.5}
                {:id "POS928", :pos [340, 580], :radius 2.3}
                {:id "DOC916", :pos [542, 230], :radius 5}
                {:id "CEL303", :pos [15, 544],  :radius 6.5}
                {:id "REP001", :pos [156, 339], :radius 10.1}
                {:id "CEL693", :pos [482, 444], :radius 3.9}
                {:id "FET213", :pos [572, 120], :radius 7.3}
                {:id "PEE998", :pos [322, 323], :radius 8.8}
                {:id "TUP430", :pos [555, 328], :radius 2.8}]})

(defn fetch-ships []
  [{:id "TBP001"
    :location "CEL222"  ;; current celestial body
    :range 10           ;; distance in light years
    :name "Black Pearl"
    :type :battleship}
   {:id "HMS919"
    :location "CEL222"
    :range 8
    :name "HMS Interceptor"
    :type :battleship}
   {:id "TBC845"
    :location "DOC916"
    :range 5.5
    :name "Black Barnacle"
    :type :battleship}])
