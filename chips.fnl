(local lume (require "lib.lume"))

(fn xor-fn [a b] (and (or a b) (not (= a b))))
(local xor-chip {
       :label "XOR"
       :mappings [{:label "a" :type :input}
                  {:label "b" :type :input}
                  {:label "x" :type :output}]
       :function xor-fn})

(fn nand-fn [a b] (not (and a b)))
(local nand-chip {
       :label "NAND"
       :mappings [{:label "a" :type :input}
                  {:label "b" :type :input}
                  {:label "x" :type :output}]
       :function nand-fn})

(fn not-chip {
  :label "NOT"
  :mappings [{:label "a" :type :input}
             {:label "x" :type :output}]
  :function (fn [a] (nand-fn a a))})

(local truth-table-xor [{:a false :b false :output false}
                        {:a false :b true  :output true}
                        {:a true  :b false :output true}
                        {:a true  :b true  :output false}])

(local truth-table-not [{:a false :output true}
                        {:a true :output false}])

(fn create-nand-gate [inputs ?x ?y]
  (var gate {:inputs inputs :func nand-fn})
  (when ?x (set gate.x ?x))
  (when ?y (set gate.y ?y))
  gate)

(fn create-not-graph []
  [(create-nand-gate ["A" "A"] 190 275)])

(fn create-xor-graph []
  (let [gate1 (create-nand-gate ["A" "B"] 190 275)
        gate2 (create-nand-gate ["A" gate1])
        gate3 (create-nand-gate ["B" gate1])
        gate4 (create-nand-gate [gate2 gate3])]
    [gate1 gate2 gate3 gate4]))

(fn update-gate-inputs [gate new-inputs]
  (set gate.inputs new-inputs))

(fn evaluate-gate [gate input-values cache]
  (var cache (or cache []))
  (var resolved-inputs [])
  (let [inputs (. gate :inputs)]
    (each [_idx input (ipairs inputs)]
      (if (= "string" (type input))
          (table.insert resolved-inputs (. input-values input))
          (table.insert resolved-inputs (evaluate-gate input input-values cache))))
    (if (. cache gate)
      (. cache gate)
      (let [result ((. gate :func) (. resolved-inputs 1) (. resolved-inputs 2))]
        (set cache gate)
        result))))

(fn displayable-rule [rule]
  (: "%s %s = %s" :format
     (. rule :a)
     (. rule :b)
     (. rule :output)))

(fn test-harness [gate truth-table]
  (lume.all truth-table (fn [rule]
    (let [inputs {:A (. rule :a) :B (. rule :b)}
          output (evaluate-gate gate inputs [])]
      (if (= output (. rule :output))
          (do ;; passed truth table rule
            (print (: "PASS! -> Expected: %s Got: %s" :format (displayable-rule rule) output))
            true)
          (do ;; failed rule:
            (print (: "FAIL! -> Expected: %s Got: %s" :format (displayable-rule rule) output))
            false))))))

(fn initial-state []
  {:graph (create-xor-graph)
   :static {:A {:x 100 :y 200}
            :B {:x 100 :y 350}
            :OUT {:x 300 :y 250}}
   :inventory-shown false})

{
:create-nand-gate create-nand-gate
:create-not-graph create-not-graph
:create-xor-graph create-xor-graph
:evaluate-gate evaluate-gate
:initial-state initial-state
:nand-chip nand-chip
:not-chip not-chip
:test-harness test-harness
:update-gate-inputs update-gate-inputs
:xor-chip xor-chip
:truth-table-xor truth-table-xor
:truth-table-not truth-table-not
}
