module T = struct
  include Stdlib.Int64

  let set_bit ~at:i n =
    if i < 0 then invalid_arg "negative bit offset";
    if i > 63 then invalid_arg "bit offset exceeds 63";
    let mask = shift_left one i in
    logor n mask

  let clear_bit ~at:i n =
    if i < 0 then invalid_arg "negative bit offset";
    if i > 63 then invalid_arg "bit offset exceeds 63";
    let mask = shift_left one i |> lognot in
    logand n mask

  let test_bit ~at:i n = equal n (set_bit ~at:i n)

  let size = 64

  let unsafe_store src dst i = Bytes.set_int64_be dst (i * 8) src

  let unsafe_restore src i = Bytes.get_int64_be src (i * 8)
end

include T
include Comparable.Make (T)
include Storable.Make (T)