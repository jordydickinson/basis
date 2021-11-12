module T = struct
  type (+'a, +'e, !'i) t = (('a, 'e) result, 'i list) State.t

  let of_result = State.return

  let return a = State.return (Ok a)

  let error e = State.return (Error e)

  let bind_result = State.bind

  let lift_result = State.map

  let map f = State.map (Result.map f)

  let bind f m =
    { State.call = fun k -> m.State.call begin function
      | Ok x -> (f x).State.call k
      | Error _ as x -> k x
      end
    }

  let recover f m =
    { State.call = fun k -> m.State.call begin function
      | Ok _ as x -> k x
      | Error e -> (f e).State.call k
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
    { State.call = fun k -> function
      | [] -> k (Error End_of_input) []
      | x :: _ as xs -> k (Ok x) xs
    }

  let skip =
    { State.call = fun k -> function
      | [] -> k (Error End_of_input) []
      | _ :: xs -> k (Ok ()) xs
    }

  let next =
    { State.call = fun k -> function
      | [] -> k (Error End_of_input) []
      | x :: xs -> k (Ok x) xs
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