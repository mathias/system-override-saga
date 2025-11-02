(local lume (require "lib.lume"))
(local utils (require "utils"))

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

(local xor-truth-table [{:a false :b false :output false}
                        {:a false :b true  :output true}
                        {:a true  :b false :output true}
                        {:a true  :b true  :output false}])

(fn create-nand-gate [inputs ?x ?y]
  (var gate {:inputs inputs :func nand-fn})
  (when ?x (set gate.x ?x))
  (when ?y (set gate.y ?y))
  gate)

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

(fn test-harness-xor [gate truth-table]
  (each [_idx rule (ipairs truth-table)]
    (let [inputs {:A (. rule :a) :B (. rule :b)}
	 output (evaluate-gate gate inputs [])]
      (if (= output (. rule :output))
	  (print "PASS!")
	  (print "FAIL! -> %s" :format rule)))))

{
:nand-chip nand-chip
:not-chip not-chip
:xor-chip xor-chip
:xor-truth-table xor-truth-table
:evaluate-gate evaluate-gate
:update-gate-inputs update-gate-inputs
:create-nand-gate create-nand-gate
:create-xor-graph create-xor-graph
:test-harness-xor test-harness-xor
}
