(ns mirmigia.events
  (:require [mirmigia.db :refer [app-state]]))

(defmulti handle-event
  "Register an event handler. Will receive the app state
  and the parameters passed by the caller. The returned map
  will become the new app state."
  (fn [_ [ev-name & _]] ev-name))

(defn dispatch!
  "Trigger an event. Event ID is given as `[:my-event ...]`."
  ([params] (dispatch! app-state params))
  ([state params]
   (swap! state handle-event params)))
