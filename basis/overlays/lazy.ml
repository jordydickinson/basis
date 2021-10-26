include Stdlib.Lazy

let map f x = lazy (f @@ force x)

let map_val f x =
  if is_val x
  then from_val (f @@ force_val x)
  else map f x