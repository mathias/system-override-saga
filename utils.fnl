(local fennel (require :lib.fennel))

(fn pp [x] (print (fennel.view x)))

(fn displayable-bool [boolean]
  (case boolean
    true "1"
    false "0"))

{
  :pp pp
  :displayable-bool displayable-bool
}
