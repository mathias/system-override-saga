(import-macros {: incf} :sample-macros)
(local utils (require :utils))
(local chips (require :chips))
(local lume (require "lib.lume"))

(local pp utils.pp)
(local displayable-bool utils.displayable-bool)

(love.graphics.setNewFont 20)

(var selected-node nil)
(var state (chips.initial-state))
(set _G.state state) ;; make available from repl, TODO: remove for release

(fn draw-circuit [state w h]
  (love.graphics.printf "a" state.static.A.x state.static.A.y w :left)
  (love.graphics.printf "b" state.static.B.x state.static.B.y w :left)
  (love.graphics.printf "out" state.static.OUT.x state.static.OUT.y w :left)
  (let [graph state.graph]
    (each [_idx node (ipairs graph)]
      (when (and node.x node.y)
        (love.graphics.rectangle "fill" node.x node.y 30 30))))
  ;; (if state.inventory-shown
  ;;     (pp "Inventory open")
  ;;     (pp "Inventory closed"))
  )

(fn either-leave-inventory-or-leave-mode [set-mode]
  (if (= state.inventory-shown true)
      (set state.inventory-shown false)
      (set-mode :mode-intro))) ;; TODO: This should just pause the mode for now?

(fn open-inventory []
  (set state.inventory-shown true))

(fn next-node [selected-node state]
  )

{:activate (fn activate []
             true)
 :draw (fn draw [message]
         (local (w h _flags) (love.window.getMode))
	 ; TODO: This becomes part of the pages of the book in the inventory (datasheets) later:
         ; (love.graphics.printf
         ;  "Datasheet:\na b = out"
         ;  0 20 w :left)
         ; (let [this-length (lume.count chips.truth-table-xor)
         ;       offset 1]
         ;   (for [i 1 this-length 1]
         ;     (let [lst (. chips.truth-table-xor i)]
         ;       (love.graphics.printf
         ;        (: "%s %s = %s" :format
         ;           (displayable-bool (. lst :a))
         ;           (displayable-bool (. lst :b))
         ;           (displayable-bool (. lst :output)))
         ;        0 (+ (* (+ i offset) 20) 20) w :left))))
         (draw-circuit state w h))
 :update (fn update [dt set-mode] ;; dt is delta time
           ;; (if state.inventory-shown
           ;;    ;; inventory open -- only update inventory
            ;;;   ;; chip design screen open, tick updates as normal
           ;;     )
           )
 :keypressed (fn keypressed [key set-mode]
               (case key
                 "up" (set selected-node (if (= selected-node nil)
                                             (lume.first state.graph)
                                             (next-node selected-node state)))
                 "down" (pp "down key pressed")
                 "left" (pp "left key pressed")
                 "right" (pp "right key pressed")
                 "return" (pp "enter key pressed")
                 "i" (open-inventory)
                 "escape" (either-leave-inventory-or-leave-mode set-mode)))
}
