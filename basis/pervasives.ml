type void = Void.t

let unreachable = Void.unreachable

external phys_same : 'a -> 'b -> bool = "%eq"

let hash_combine =
  let c =
    if Sys.int_size <= 32
    then 0x9e3779b9
    else 0x517cc1b727220a95
  in
  fun h1 h2 ->
    h1 lxor (h2 + c + (h1 lsl 6) + (h1 lsr 2))