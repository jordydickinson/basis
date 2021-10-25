module T = struct
  include Stdlib.Int

  let hash i = i
end
include T

include Comparable.Make (T)
include Hashable.Make (T)