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