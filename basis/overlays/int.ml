module T = struct
  include Stdlib.Int

  let hash i = i

  let storage_size = Float.(of_int Sys.int_size /. 8. |> ceil |> to_int)

  let unsafe_store src dst i =
    if storage_size = 4 then
      Bytes.set_int32_ne dst i (Int32.of_int src)
    else if storage_size = 8 then
      Bytes.set_int64_ne dst i (Int64.of_int src)
    else
      failwith "unsupported"

  let unsafe_restore src i =
    if storage_size = 4 then
      Bytes.get_int32_ne src i |> Int32.to_int
    else if storage_size = 8 then
      Bytes.get_int64_ne src i |> Int64.to_int
    else
      failwith "unsupported"
end
include T

include Comparable.Make (T)
include Hashable.Make (T)
include Storable.Make (T)