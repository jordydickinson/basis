module T = struct
  type (+'a, !'s) t = { call: 'r. ('a -> 's -> 'r) -> 's -> 'r }

  let return a = { call = fun k -> k a }

  let get = { call = fun k s -> k s s }

  let set s = { call = fun k _ -> k () s }

  let run m = m.call (fun x s -> x, s)

  let map f m = { call = fun k -> m.call (fun x -> k (f x)) }

  let bind f m = { call = fun k -> m.call (fun x -> (f x).call k) }

  let join m = { call = fun k -> m.call (fun m -> m.call k) }

  let apply mf mx =
    { call = fun k -> mf.call (fun f -> mx.call (fun x -> k (f x))) }
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
      { call = fun k s -> match Table.find_opt memo s with
        | None -> (m m_memo).call (fun x s' -> Table.replace memo s (x, s'); k x s') s
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
