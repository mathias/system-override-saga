#lang racket

(require racket/class)
(require readline)

;; state structs
(struct world (player map current-chip-design))
(struct player (name [inventory #:mutable] [loc #:mutable]))
(struct map ([tiles #:mutable]))
(struct item (symbol name description x y))
(struct current-chip-design ([graph #:mutable]))
(struct gate ([inputs #:mutable] fn label))

;; state mgmt fns

(define (create-nand-gate inputs label [?x 0] [?y 0])
  (let ([nand-gate (gate inputs (lambda (a b) (not (and a b))) label)])
    nand-gate))

