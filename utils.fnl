(local fennel (require :lib.fennel))

(fn pp [x] (print (fennel.view x)))

{:pp pp}
