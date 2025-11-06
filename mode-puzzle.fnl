(import-macros {: incf} :sample-macros)
(local utils (require :utils))
(local chips (require :chips))
(local lume (require "lib.lume"))

(local pp utils.pp)
(local displayable-bool utils.displayable-bool)

(love.graphics.setNewFont 20)

(fn initial-state []
  {:graph (chips.create-xor-graph)
   :static {:A {:x 100 :y 200}
            :B {:x 100 :y 350}
            :OUT {:x 300 :y 250}}})


(var selectedNode nil)
(var state (initial-state))
(set selectedNode nil)
(set _G.state state) ;; make available from repl

(fn draw-circuit [state w h]
  (love.graphics.printf "a" state.static.A.x state.static.A.y w :left)
  (love.graphics.printf "b" state.static.B.x state.static.B.y w :left)
  (love.graphics.printf "out" state.static.OUT.x state.static.OUT.y w :left)
  (let [graph state.graph]
    (each [_idx node (ipairs graph)]
      (when (and node.x node.y)
        (love.graphics.rectangle "fill" node.x node.y 30 30))))
  )

{:activate (fn activate []
             true)
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
           )
 :keypressed (fn keypressed [key set-mode]
               (case key
                 "w" (let [gate (lume.last state.graph)]
                       (chips.test-harness-xor gate chips.xor-truth-table))
                 "up" (pp "up key pressed")
                 "down" (pp "down key pressed")
                 "left" (pp "left key pressed")
                 "right" (pp "right key pressed")
                 "return" (pp "enter key pressed")))
}
