(local lume (require "lib/lume"))
(local chips (require :chips))

;; describe: chips evaluate-graph fn - XOR
(let [state (chips.initial-state)
      output-node (lume.last state.graph)]
      ;; A xor B = OUTPUT
      ;; false false = false
      (assert (= (chips.evaluate-gate output-node {:A false :B false}) false))
      ;; false true = true
      (assert (= (chips.evaluate-gate output-node {:A false :B true}) true))
      ;; true false = true
      (assert (= (chips.evaluate-gate output-node {:A true :B false}) true))
      ;; true true = false
      (assert (= (chips.evaluate-gate output-node {:A true :B true}) false))
)

;; evaluate-graph for NOT graph:
(let [state (chips.initial-state)]
  (set state.graph (chips.create-not-graph))
  (let [output-node (lume.last state.graph)]
    ;; not A = OUTPUT
    (assert (= (chips.evaluate-gate output-node {:A false}) true) "not false = true")
    (assert (= (chips.evaluate-gate output-node {:A true}) false) "not true = false")
))

;; describe: evaluate-graph fn - OR
(let [state (chips.initial-state)]
  (set state.graph (chips.create-or-graph))
  (let [output-node (lume.last state.graph)]
      ;; A or B = OUTPUT
      ;; false false = false
      (assert (= (chips.evaluate-gate output-node {:A false :B false}) false))
      ;; false true = true
      (assert (= (chips.evaluate-gate output-node {:A false :B true}) true))
      ;; true false = true
      (assert (= (chips.evaluate-gate output-node {:A true :B false}) true))
      ;; true true = true
      (assert (= (chips.evaluate-gate output-node {:A true :B true}) true))
))
