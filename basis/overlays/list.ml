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

let fold_left2_rem f =
  let rec fold_left2_rem' acc xs ys = match xs, ys with
  | [], [] -> acc, None
  | [], ys -> acc, Some (Either.Right ys)
  | xs, [] -> acc, Some (Either.Left xs)
  | x :: xs, y :: ys ->
    fold_left2_rem' (f acc x y) xs ys
  in
  fold_left2_rem'

let combine_rem xs ys =
  let xys, rem = fold_left2_rem (fun xys x y -> (x, y) :: xys) [] xs ys in
  rev xys, rem

let takedrop n =
  if n < 0 then invalid_arg "negative index";
  let rec takedrop' acc n = function
  | xs when n = 0 -> rev acc, xs
  | x :: xs -> takedrop' (x :: acc) (n - 1) xs
  | _ -> failwith "list too short"
  in
  takedrop' [] n

let take n xs = fst @@ takedrop n xs

let drop n xs = snd @@ takedrop n xs

let fold_left_while f =
  let rec fold_left_while' acc = function
  | [] -> acc, []
  | x :: xs ->
    let acc, continue = f acc x in
    if continue
    then fold_left_while' acc xs
    else acc, xs
  in
  fold_left_while'

let takedrop_while f xs =
  let folder acc x = if f x then x :: acc, true else acc, false in
  let take_rev, drop = fold_left_while folder [] xs in
  rev take_rev, drop

let take_while f xs = fst @@ takedrop_while f xs

let drop_while f xs = snd @@ takedrop_while f xs
