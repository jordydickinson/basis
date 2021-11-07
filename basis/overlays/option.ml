include Stdlib.Option

include Monad.Make (struct
  include Stdlib.Option

  let return = some
  
  let bind f x = bind x f

  let apply f x = match f with
  | None -> None
  | Some f -> map f x
end)

(* [Stdlib] has the arguments here in the wrong order, but to keep the peace we
   repeat the sins of our predecessors. *)
let bind x f = bind f x