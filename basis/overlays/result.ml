module T = struct
  include Stdlib.Result

  let return = ok

  let bind f x = bind x f

  let apply f x = match f with
  | Ok f -> map f x
  | Error _ as f -> f
end

include T
include Monad.Make2 (T)

(* [Stdlib] has the arguments here in the wrong order, but to keep the peace we
   repeat the sins of our predecessors. *)
let bind x f = bind f x

let all_errors xs =
  let rec all_errors' acc = function
  | [] ->
    begin match acc with
    | Ok xs -> Ok (List.rev xs)
    | Error es -> Error es
    end
  | Ok x :: xs ->
    begin match acc with
    | Ok xs' -> Ok (x :: xs')
    | Error _ as acc -> all_errors' acc xs
    end
  | Error es :: xs ->
    begin match acc with
    | Ok _ -> all_errors' (Error es) xs
    | Error es' -> all_errors' (Error (es' @ es)) xs
    end
  in
  all_errors' (Ok []) xs