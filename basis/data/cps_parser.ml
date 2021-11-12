module T = struct
  type (+'a, +'e, !'i) t = (('a, 'e) result, 'i Lazy_list.t) State.t

  let of_result = State.return

  let return a = State.return (Ok a)

  let error e = State.return (Error e)

  let bind_result = State.bind

  let lift_result = State.map

  let map f = State.map (Result.map f)

  let bind f m =
    { State.cont = fun k -> m.State.cont begin function
      | Ok x -> (f x).State.cont k
      | Error _ as x -> k x
      end
    }

  let recover f m =
    { State.cont = fun k -> m.State.cont begin function
      | Ok _ as x -> k x
      | Error e -> (f e).State.cont k
      end
    }

  let join m = bind Fun.id m

  let apply mf mx = bind (fun f -> map f mx) mf
end

include T
include Monad.Make3 (T)

type eoi = End_of_input

module O = struct
  include T
  include O

  let run = State.run

  let peek =
    { State.cont = fun k xs -> match Lazy_list.hd_opt xs with
      | None -> k (Error End_of_input) xs
      | Some x -> k (Ok x) xs
    }

  let skip =
    { State.cont = fun k xs -> match Lazy_list.tl_opt xs with
      | None -> k (Error End_of_input) xs
      | Some xs -> k (Ok ()) xs
    }

  let next =
    { State.cont = fun k xs -> match Lazy_list.hd_opt xs with
      | None -> k (Error End_of_input) xs
      | Some x -> k (Ok x) (Lazy_list.tl xs)
    }

  let alt p1 p2 = p1 |> recover (fun _ -> p2)

  module Infix = struct
    include Infix

    let ( <|> ) = alt

    let ( >>! ) p f = recover f p
  end
  include Infix

  let first ps =
    let rec first' error = function
    | [] -> error []
    | p :: ps ->
      p >>! fun e ->
      first' (fun es -> error (e :: es)) ps
    in
    first' error ps

  let opt p = p >>| Option.some <|> return None

  let many p =
    let rec many' acc = let* x = opt p in match x with
    | None -> return (List.rev acc)
    | Some x -> many' (x :: acc)
    in
    many' []
end

include O

let memoize n = State.memoize ~hash:Hashtbl.hash ~equal:(==) n