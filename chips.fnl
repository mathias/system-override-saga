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
  :function (fn [a] (not a))})

(fn or-chip {
  :label "OR"
  :mappings [{:label "a" :type :input}
             {:label "b" :type :input}
             {:label "x" :type :output}]
  :function (fn [a b] (or a b))})

(local truth-table-xor [{:a false :b false :output false}
                        {:a false :b true  :output true}
                        {:a true  :b false :output true}
                        {:a true  :b true  :output false}])

(local truth-table-not [{:a false :output true}
                        {:a true :output false}])

(local truth-table-or [{:a false :b false :output false}
                       {:a false :b true  :output true}
                       {:a true  :b false :output true}
                       {:a true  :b true  :output true}])

(fn create-nand-gate [inputs ?x ?y]
  (var gate {:inputs inputs :func nand-fn})
  (when ?x (set gate.x ?x))
  (when ?y (set gate.y ?y))
  gate)

(fn create-not-graph []
  [(create-nand-gate ["A" "A"] 190 275)])

(fn create-xor-graph []
  (let [gate1 (create-nand-gate ["A" "B"])
        gate2 (create-nand-gate ["A" gate1])
        gate3 (create-nand-gate ["B" gate1])
        gate4 (create-nand-gate [gate2 gate3])]
    [gate1 gate2 gate3 gate4]))

(fn create-or-graph []
  (let [gate1 (create-nand-gate ["A" "A"])
        gate2 (create-nand-gate ["B" "B"])
        gate3 (create-nand-gate [gate1 gate2])]
    [gate1 gate2 gate3]))

(fn update-gate-inputs [gate new-inputs]
  (set gate.inputs new-inputs))

(fn evaluate-gate [gate input-values cache]
  (var cache (or cache []))
  (local resolved-inputs [])
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

(fn initial-state [graph]
  {:graph graph
   :static {:A {:x 100 :y 200}
            :B {:x 100 :y 350}
            :OUT {:x 300 :y 250}}
   :inventory-shown false})

{
:create-nand-gate create-nand-gate
:create-not-graph create-not-graph
:create-or-graph create-or-graph
:create-xor-graph create-xor-graph
:evaluate-gate evaluate-gate
:initial-state initial-state
:nand-chip nand-chip
:not-chip not-chip
:update-gate-inputs update-gate-inputs
:xor-chip xor-chip
:truth-table-xor truth-table-xor
:truth-table-not truth-table-not
}
