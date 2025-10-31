(import-macros {: incf} :sample-macros)

(local countdown-time 30)
(var counter 0)
(var time 0)

(love.graphics.setNewFont 30)

(local (major minor revision) (love.getVersion))
(local fennel (require :lib.fennel))
(fn pp [x] (print (fennel.view x)))

{:activate (fn activate [])
 :draw (fn draw [message]
         (local (w h _flags) (love.window.getMode))
         (love.graphics.printf
          (: "Love Version: %s.%s.%s"
             :format  major minor revision) 0 10 w :center)
         (love.graphics.printf
          (: "This window should close in %0.1f seconds"
             :format (math.max 0 (- countdown-time time)))
          0 (- (/ h 2) 15) w :center))
 :update (fn update [dt set-mode]
             (if (< counter 65535)
                 (set counter (+ counter 1))
                 (set counter 0))
             (incf time dt)
             (when (> time countdown-time)
               (set time 0)
               (love.event.quit)))
 :keypressed (fn keypressed [key set-mode])}
