include Stdlib.Seq

let flatten xs = flat_map Fun.id xs

include Monad.Make (struct
  include Stdlib.Seq
  let bind = flat_map
  let join = flatten
  let apply fs xs = flat_map (fun f -> map f xs) fs
end)

