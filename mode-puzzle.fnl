(import-macros {: incf} :sample-macros)
(local utils (require :utils))
(local chips (require :chips))
(local lume (require "lib.lume"))

(local pp utils.pp)
(local displayable-bool utils.displayable-bool)

(love.graphics.setNewFont 20)

(var state (chips.create-xor-graph))

{:activate (fn activate []
             (pp state))
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
         (love.graphics.setColor 255 0 0))
 :update (fn update [dt set-mode])
 :keypressed (fn keypressed [key set-mode]
               (case key
                 "w" (do (chips.test-harness-xor (lume.last state) chips.xor-truth-table) (pp state))
                 "up" (pp "up key pressed")
                 "down" (pp "down key pressed")
                 "left" (pp "left key pressed")
                 "right" (pp "right key pressed")
                 "escape" (set-mode :mode-intro)))}
