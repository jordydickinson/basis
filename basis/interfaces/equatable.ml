include Equatable_intf

module Infix (T: Basic) = struct
  let ( = ) = T.equal
  let ( <> ) a b = not (a = b)
end