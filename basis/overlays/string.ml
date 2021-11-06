include Stdlib.String

include Comparable.Make (Stdlib.String)
include Hashable.Make (struct
  type t = string
  let equal = equal
  let hash = Hashtbl.hash
end)

let to_string = Fun.id