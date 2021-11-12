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

module MakeMemoize (St: Hashable.Basic) = struct
  module Table = Ephemeron.K1.Make (St)

  let memoize n m =
    let memo = Table.create n in
    let rec m_memo =
      { cont = fun k s -> match Table.find_opt memo s with
        | None -> (m m_memo).cont (fun x s' -> Table.replace memo s (x, s'); k x s') s
        | Some (x, s) -> k x s
      }
    in
    m_memo
end

let memoize (type s) ~(hash: s -> int) ~(equal: s -> s -> bool) =
  let module St: Hashable.Basic with type t = s = struct
    type t = s
    let equal = equal
    let hash = hash
  end in
  let module M = MakeMemoize (St) in
  M.memoize
