include Comparable.MakeContainer (Stdlib.List)
include Stdlib.List

let is_empty = function
| [] -> true
| _ -> false

let head_opt xs =
  if is_empty xs then None else Option.some @@
  let xs = ref xs in
  let ys = Stack.create () in
  while not @@ is_empty !xs do
    Stack.push (hd !xs) ys;
    xs := tl !xs
  done;
  Stack.pop ys |> ignore;
  Stack.fold (Fun.flip cons) [] ys

let head xs = match head_opt xs with
| None -> failwith "head []"
| Some xs -> xs

let rec last_opt = function
| [] -> None
| [x] -> Some x
| _ :: xs -> last_opt xs

let last xs = match last_opt xs with
| None -> failwith "last []"
| Some x -> x

let combine_rem xs ys =
  let rec combine_rem' acc xs ys = match xs, ys with
  | [], [] -> rev acc, None
  | [], ys -> rev acc, Some (Either.Right ys)
  | xs, [] -> rev acc, Some (Either.Left xs)
  | x :: xs, y :: ys ->
    combine_rem' ((x, y) :: acc) xs ys
  in
  combine_rem' [] xs ys