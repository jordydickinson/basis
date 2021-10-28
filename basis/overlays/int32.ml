module T = struct
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

  let size = 32

  let unsafe_store src dst i = Bytes.set_int32_be dst (i * 4) src

  let unsafe_restore src i = Bytes.get_int32_be src (i * 4)
end

include T
include Storable.Make (T)