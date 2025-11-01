(import-macros {: incf} :sample-macros)

(local countdown-time 30)
(var counter 0)
(var time 0)

(love.graphics.setNewFont 30)

(local (major minor revision) (love.getVersion))
(local utils (require :utils))
(local pp utils.pp)
(var keylastpressed nil)

{:activate (fn activate [])
 :draw (fn draw [message]
         (local (w h _flags) (love.window.getMode))
         (love.graphics.printf
          (: "Love Version: %s.%s.%s"
             :format  major minor revision) 0 10 w :center)
         (love.graphics.printf
          (: "System Override Saga v%s" :format "0.1.0alpha") ;; TODO: pass this in somehow from globals?
          0 (- (/ h 2) 15) w :center)
         (love.graphics.printf
                "Press 'p' to START. 'ESC' to QUIT."
                0 (- h 45) w :center)
         (when (not (= keylastpressed nil))
           (love.graphics.printf
             (: "Last key pressed was %s"
                :format keylastpressed)
             0 (+ (- (/ h 2) 15) 35) w :center))
)
 :update (fn update [dt set-mode]
             (when (> time countdown-time)
               (set time 0)
               (love.event.quit)))
 :keypressed (fn keypressed [key set-mode]
               (set keylastpressed key)
               (case key
                 "p" (set-mode :mode-puzzle)
                 "escape" (love.event.quit)))} ;; TODO: add an "Are you sure?" prompt
