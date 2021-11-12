module T = struct
  type (+'a, !'s) t = 's -> ('a * 's) Seq.t

  let return a = fun s -> Seq.return (a, s)

  let bind f m = fun s -> Seq.flat_map (fun (a, s) -> f a s) (m s)

  let map f m = fun s -> Seq.map (fun (a, s) -> f a, s) (m s)

  let apply mf mx = bind (fun f -> map f mx) mf

  let join m = bind Fun.id m
end

include T
include Monad.Make2 (T)

module O = struct
  include O

  let run m s = m s

  let succeed = fun s -> Seq.return ((), s)

  let fail = fun _ -> Seq.empty

  let get = fun s -> Seq.return (s, s)

  let set s = fun _ -> Seq.return ((), s)

  let cut m = fun s -> let xss: _ Seq.t = m s in match xss () with
  | Nil -> Seq.empty
  | Cons (x, _) -> Seq.return x

  let append m1 m2 = fun s -> Seq.append (m1 s) (m2 s)

  module Infix = struct
    include Infix

    let (<+>) = append
  end
  include Infix
end
include O

let of_cps_state (m: _ Cps_state.t) : _ t =
  m.cont (fun x s -> Seq.return (x, s))