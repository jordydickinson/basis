module T = struct
  include Stdlib.Int

  let hash i = i

  let size = Sys.int_size

  let byte_size = size / 8 + if size mod 8 = 0 then 0 else 1

  let unsafe_store src dst i =
    let i = i * byte_size in
    if size = 31 then
      let v =
        if src > 0
        then Int32.of_int src
        else Int32.of_int (abs src) |> Int32.set_bit ~at:30
      in
      Bytes.set_int32_be dst i v
    else if size = 32 then
      let v = Int32.of_int src in
      Bytes.set_int32_be dst i v
    else if size = 63 then
      let v =
        if src > 0
        then Int64.of_int src
        else Int64.of_int (abs src) |> Int64.set_bit ~at:62
      in
      Bytes.set_int64_be dst i v
    else if size = 64 then
      let v = Int64.of_int src in
      Bytes.set_int64_be dst i v
    else failwith @@ Format.sprintf "unsupported: Sys.int_size = %i" size

  let unsafe_restore src i =
    let i = i * byte_size in
    if size = 31 then
      let v = Bytes.get_int32_be src i in
      if Int32.test_bit ~at:30 v
      then -Int32.(to_int @@ clear_bit ~at:30 v)
      else Int32.to_int v
    else if size = 32 then
      let v = Bytes.get_int32_be src i in
      Int32.to_int v
    else if size = 63 then
      let v = Bytes.get_int64_be src i in
      if Int64.test_bit ~at:62 v
      then -Int64.(to_int @@ clear_bit ~at:62 v)
      else Int64.to_int v
    else if size = 64 then
      let v = Bytes.get_int64_be src i in
      Int64.to_int v
    else failwith @@ Format.sprintf "unsupported: Sys.int_size = %i" size
end
include T

include Comparable.Make (T)
include Hashable.Make (T)
include Storable.Make (T)