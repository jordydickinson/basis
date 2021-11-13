module T = struct
  include Basis.Int

  let size = Sys.int_size

  let unsafe_store src dst i =
    if size = 31 then
      let v =
        if src > 0
        then Int32.of_int src
        else Int32.of_int (abs src) |> Int32.set_bit ~at:30
      in
      Int32.unsafe_store v dst i
    else if size = 32 then Int32.unsafe_store (Int32.of_int src) dst i
    else if size = 63 then
      let v =
        if src > 0
        then Int64.of_int src
        else Int64.of_int (abs src) |> Int64.set_bit ~at:62
      in
      Int64.unsafe_store v dst i
    else if size = 64 then
      let v = Int64.of_int src in
      Int64.unsafe_store v dst i
    else failwith @@ Format.sprintf "unsupported: Sys.int_size = %i" size

  let unsafe_restore src i =
    if size = 31 then
      let v = Int32.unsafe_restore src i |> Int32.clear_bit ~at:31 in
      if Int32.test_bit ~at:30 v
      then -Int32.(to_int @@ clear_bit ~at:30 v)
      else Int32.to_int v
    else if size = 32 then Int32.unsafe_restore src i |> Int32.to_int
    else if size = 63 then
      let v = Int64.unsafe_restore src i |> Int64.clear_bit ~at:63 in
      if Int64.test_bit ~at:62 v
      then -Int64.(to_int @@ clear_bit ~at:62 v)
      else Int64.to_int v
    else if size = 64 then Int64.unsafe_restore src i |> Int64.to_int
    else failwith @@ Format.sprintf "unsupported: Sys.int_size = %i" size
end

include T
include Storable.Make (T)