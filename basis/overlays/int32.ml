include Stdlib.Int32

let set_bit ~at:i n =
  if i < 0 then invalid_arg "negative bit offset";
  if i > 31 then invalid_arg "bit offset exceeds 31";
  let mask = shift_left one i in
  logor n mask

let clear_bit ~at:i n =
  if i < 0 then invalid_arg "negative bit offset";
  if i > 31 then invalid_arg "bit offset exceeds 31";
  let mask = shift_left one i |> lognot in
  logand n mask

let test_bit ~at:i n = equal n (set_bit ~at:i n)