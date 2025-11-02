(import-macros {: incf} :sample-macros)
(local utils (require :utils))
(local chips (require :chips))
(local lume (require "lib.lume"))

(local pp utils.pp)
(local displayable-bool utils.displayable-bool)

(love.graphics.setNewFont 20)

(var state {
     :graph (chips.create-xor-graph)
     :static []})
(var selectedNode nil)
(var lastX 0)
(var lastY 0)

(fn draw-circuit [state w h]
  (love.graphics.printf "a" (. state :static :A 1) (. state :static :A 2) w :left)
  (love.graphics.printf "b" (. state :static :B 1) (. state :static :B 2) w :left)
  (let [graph state.graph]
    (each [_idx node (ipairs graph)]
      (when (and node.x node.y)
	(love.graphics.rectangle "fill" node.x node.y 30 30))))
  )

(set state.static.A [100 200])
(set state.static.B [100 350])
(set state.static.OUT [300 250])

{:activate (fn activate [])
 :draw (fn draw [message]
         (local (w h _flags) (love.window.getMode))
         (love.graphics.printf
           "Datasheet:\na b = out"
           0 20 w :left)
         (let [this-length (lume.count chips.xor-truth-table)
               offset 1]
                 (for [i 1 this-length 1]
                   (let [lst (. chips.xor-truth-table i)]
                     (love.graphics.printf
                       (: "%s %s = %s" :format
                          (displayable-bool (. lst :a))
                          (displayable-bool (. lst :b))
                          (displayable-bool (. lst :output)))
                       0 (+ (* (+ i offset) 20) 20) w :left))))
         (draw-circuit state w h))
 :update (fn update [dt set-mode] ;; dt is delta time
	   (let [x (love.mouse.getX)
		 y (love.mouse.getY)]
	     (when (or (not= lastX x) (not= lastY y))
	       (do (print (: "X: %i Y: %i" :format x y)) (set lastX x) (set lastY y))
	   )))
 :keypressed (fn keypressed [key set-mode]
               (case key
                 "w" (let [gate (lume.last state.graph)]
		       (chips.test-harness-xor gate chips.xor-truth-table))
                 "up" (pp "up key pressed")
                 "down" (pp "down key pressed")
                 "left" (pp "left key pressed")
                 "right" (pp "right key pressed")
		 "space" (pp "spacebar pressed")
		 "return" (pp "enter key pressed")
                 "escape" (set-mode :mode-intro)))}
