module T = struct
  type (+'a, +'e, !'i) t = (('a, 'e) result, 'i Lazy_list.t) Cps_state.t

  let of_result = Cps_state.return

  let return a = Cps_state.return (Ok a)

  let error e = Cps_state.return (Error e)

  let bind_result = Cps_state.bind

  let lift_result = Cps_state.map

  let map f = Cps_state.map (Result.map f)

  let bind f m =
    { Cps_state.cont = fun k -> m.Cps_state.cont begin function
      | Ok x -> (f x).Cps_state.cont k
      | Error _ as x -> k x
      end
    }

  let recover f m =
    { Cps_state.cont = fun k -> m.Cps_state.cont begin function
      | Ok _ as x -> k x
      | Error e -> (f e).Cps_state.cont k
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

  let run = Cps_state.run

  let peek =
    { Cps_state.cont = fun k xs -> match Lazy_list.hd_opt xs with
      | None -> k (Error End_of_input) xs
      | Some x -> k (Ok x) xs
    }

  let skip =
    { Cps_state.cont = fun k xs -> match Lazy_list.tl_opt xs with
      | None -> k (Error End_of_input) xs
      | Some xs -> k (Ok ()) xs
    }

  let next =
    { Cps_state.cont = fun k xs -> match Lazy_list.hd_opt xs with
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
end

include O