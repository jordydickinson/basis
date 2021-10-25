include Equatable_intf

module Basic (T: Comparable.Basic) = struct
  let equal a b = Int.equal (T.compare a b) 0
end

module Infix (T: Basic) = struct
  let ( = ) = T.equal
  let ( <> ) a b = not (a = b)
end