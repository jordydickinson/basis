module T = struct
  type (+'a, !'s) t = { cont: 'r. ('a -> 's -> 'r) -> 's -> 'r }

  let return a = { cont = fun k -> k a }

  let get = { cont = fun k s -> k s s }

  let set s = { cont = fun k _ -> k () s }

  let run m = m.cont (fun x s -> x, s)

  let map f m = { cont = fun k -> m.cont (fun x -> k (f x)) }

  let bind f m = { cont = fun k -> m.cont (fun x -> (f x).cont k) }

  let join m = { cont = fun k -> m.cont (fun m -> m.cont k) }

  let apply mf mx =
    { cont = fun k -> mf.cont (fun f -> mx.cont (fun x -> k (f x))) }
end

include T
include Monad.Make2 (T)

module O = struct
  include T
  include O
end