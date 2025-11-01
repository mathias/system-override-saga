(import-macros {: incf} :sample-macros)
(local utils (require :utils))
(local pp utils.pp)

(love.graphics.setNewFont 30)

(var keylastpressed nil)

(var state {})
(fn xorFn [a b] (and (or a b) (not (= a b))))
(local xorChip {:inputs [1 2]
                :outputs [1]
                :function xorFn})

(local xorTruthTable [
                      {:a false :b false :output false}
                      {:a false :b true :output true}
                      {:a true :b false :output true}
                      {:a true :b true :output false}])

(var currentDesign {})

{:activate (fn activate [])
 :draw (fn draw [message]
         (local (w h _flags) (love.window.getMode))
         (love.graphics.printf
           "Input Output Expected Actual"
           0 20 w :left)
         (let [thisLength (length xorTruthTable)]
         (for [i 1 thisLength 1]
           (let [lst (. xorTruthTable i)]
             (love.graphics.printf
               (: "%s %s %s %s" :format (. lst :a) (. lst :b) (. lst :output) ((. xorChip :function) (. lst :a) (. lst :b)))
               0 (+ (* i 30) 30) w :left)))))
 :update (fn update [dt set-mode]
           )
 :keypressed (fn keypressed [key set-mode]
               (set keylastpressed key)
               (pp keylastpressed)
               (case keylastpressed
                 "up" (pp "up key pressed")
                 "down" (pp "down key pressed")
                 "left" (pp "left key pressed")
                 "right" (pp "right key pressed")
                 "escape" (set-mode :mode-intro)))}
