include Monad.S2 with type ('a, 'e) t := ('a, 'e) result
include module type of struct include Stdlib.Result end

val all_errors: ('a, 'e list) t list -> ('a list, 'e list) t