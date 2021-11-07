include Stdlib.Seq

include Monad.Make (struct
  include Stdlib.Seq
  let bind = flat_map
end)

