module T = struct
  include Stdlib.Int32

  let hash = Hashtbl.hash
end

include T
include Comparable.Make (T)
include Hashable.Make (T)