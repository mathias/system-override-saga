(import-macros {: incf} :sample-macros)
(local utils (require :utils))
(local chips (require :chips))

(local pp utils.pp)
(local displayable-bool utils.displayable-bool)

(love.graphics.setNewFont 20)

(var state (chips.empty-state))

{:activate (fn activate []
             (pp state))
 :draw (fn draw [message]
         (local (w h _flags) (love.window.getMode))
         (love.graphics.printf
           "Datasheet:\nInput a b = Expected Output | Actual Output "
           0 20 w :left)
         (let [this-length (length chips.xor-truth-table)
               offset 1]
                 (for [i 1 this-length 1]
                   (let [lst (. chips.xor-truth-table i)]
                     (love.graphics.printf
                       (: "%s %s = %s | %s" :format
                          (displayable-bool (. lst :a))
                          (displayable-bool (. lst :b))
                          (displayable-bool (. lst :output))
                          (displayable-bool ((. chips.xor-chip :function) (. lst :a) (. lst :b))))
                       0 (+ (* (+ i offset) 20) 20) w :left))))
         (love.graphics.setColor 255 0 0))
 :update (fn update [dt set-mode])
 :keypressed (fn keypressed [key set-mode]
               (case key
                 "a" (do (chips.add-nand state) (pp state))
                 "w" (do (chips.wire-nands-to-xor state) (pp state))
                 "up" (pp "up key pressed")
                 "down" (pp "down key pressed")
                 "left" (pp "left key pressed")
                 "right" (pp "right key pressed")
                 "escape" (set-mode :mode-intro)))}
