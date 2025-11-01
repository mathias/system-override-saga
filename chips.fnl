(local lume (require "lib.lume"))

(fn xor-fn [a b] (and (or a b) (not (= a b))))
(local xor-chip {
       :label "XOR"
       :inputs [:a :b]
       :outputs [:x]
       :mappings [:a :b :x]
       :function xor-fn})

(fn nand-fn [a b] (not (and a b)))
(local nand-chip {
       :label "NAND"
       :inputs [:a :b]
       :outputs [:x]
       :mappings [:a :b :x]
       :function nand-fn})

(fn not-chip {
  :label "NOT"
  :inputs [:a]
  :outputs [:x]
  :mappings [:a :x]
  :function (fn [a] (nand-fn a a))})

(local xor-truth-table [{:a false :b false :output false}
                        {:a false :b true  :output true}
                        {:a true  :b false :output true}
                        {:a true  :b true  :output false}])


(fn clone-chip [chip-spec ?label]
  (let [new-chip (lume.clone chip-spec)]
    (when (not (= nil ?label))
      (set new-chip.label ?label))
    new-chip))

(fn add-nand [state]
  (let [current-design state.current-design
        chip-list state.chip-list
        new-nand (clone-chip nand-chip "NAND")]
    (set new-nand.function nand-fn)
    (table.insert chip-list new-nand))
  state)

(fn helper-find-idx [table label]
  (lume.find table (lume.match table (fn [x] (= (. x :label) label)))))

(fn wire-up [state chip-a-idx port-a-idx chip-b-idx port-b-idx]
  ;; TODO: enforce validation that the port counts exist!
  ;; Also: outputs can go to multiple places, an input can't have multiple things coming in to it
  (when (and (not (= nil (. state.chip-list chip-a-idx)))
             (not (= nil (. state.chip-list chip-b-idx)))
             (not (= nil (. (. (. state.chip-list chip-a-idx) :mappings) port-a-idx))))
    (print "Found chip-a + port-a"))
  (let [current-design state.current-design
        wirings current-design.wirings]
    (table.insert wirings [chip-a-idx port-a-idx chip-b-idx port-b-idx])))

;; Special helper for now, to wire up 4 NANDs correctly in an XOR:
(fn wire-nands-to-xor [state]
  (let [current-design state.current-design
        chip-list state.chip-list]
    (table.insert chip-list {:label "Current Design"
                             :inputs [:a :b]
                             :outputs [:x]
                             :mappings [:a :b :x]})
    (table.insert chip-list (clone-chip nand-chip "NAND 1"))
    (table.insert chip-list (clone-chip nand-chip "NAND 2"))
    (table.insert chip-list (clone-chip nand-chip "NAND 3"))
    (table.insert chip-list (clone-chip nand-chip "NAND 4"))
    ;; Now it needs to be wired up correctly
    (let [
          current-chip (helper-find-idx chip-list "Current Design")
          nand-1-idx (helper-find-idx chip-list "NAND 1")
          nand-2-idx (helper-find-idx chip-list "NAND 2")
          nand-3-idx (helper-find-idx chip-list "NAND 3")
          nand-4-idx (helper-find-idx chip-list "NAND 4")]
      (wire-up state current-chip 1 nand-1-idx 1)
      (wire-up state current-chip 2 nand-1-idx 2)
      (wire-up state current-chip 1 nand-2-idx 1)
      (wire-up state current-chip 2 nand-3-idx 2)
      (wire-up state nand-1-idx 3 nand-2-idx 2) ;; nand 1 out
      (wire-up state nand-1-idx 3 nand-3-idx 1) ;; nand 1 out
      (wire-up state nand-2-idx 3 nand-4-idx 1)
      (wire-up state nand-3-idx 3 nand-4-idx 2)
      (wire-up state nand-4-idx 3 current-chip 3)

      ;; (table.insert current-design.wirings [:design :a nand-1-idx 1])
      ;; (table.insert current-design.wirings [:design :b nand-1-idx 2])
      ;; (table.insert current-design.wirings [nand-1-idx 3 nand-2-idx 2])
      ;; (table.insert current-design.wirings [nand-1-idx 3 nand-3-idx 1])
      ;; (table.insert current-design.wirings [:design :a nand-2-idx 1])
      ;; (table.insert current-design.wirings [:design :b nand-3-idx 2])
      ;; (table.insert current-design.wirings [nand-2-idx 3 nand-4-idx 1])
      ;; (table.insert current-design.wirings [nand-3-idx 3 nand-4-idx 2])
      ;; (table.insert current-design.wirings [nand-4-idx 3 :design :out])

    ))
  state)

(fn empty-state []
  {:current-design {:wirings []}
  :chip-list []})

(fn compute-output [state]
  ;; pretend fn for now
  true
  )

{
:add-nand add-nand
:compute-output compute-output
:empty-state empty-state
:nand-chip nand-chip
:not-chip not-chip
:wire-nands-to-xor wire-nands-to-xor
:xor-chip xor-chip
:xor-truth-table xor-truth-table
}
