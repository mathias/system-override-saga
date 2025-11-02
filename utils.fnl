(local fennel (require :lib.fennel))

(fn pp [x] (print (fennel.view x)))

(fn displayable-bool [boolean]
  (if (= boolean true)
    "1"
    "0"))

{
  :displayable-bool displayable-bool
  :pp pp
}
