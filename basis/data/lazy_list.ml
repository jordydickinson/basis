type +'a node =
| Nil
| Cons of 'a * 'a t

and +'a t = 'a node Lazy.t

let nil = Lazy.from_val Nil

let is_nil xs = match xs with
| lazy Nil -> true
| _ -> false

let cons x xs = Lazy.from_val (Cons (x, xs))

let lcons x xs = Lazy.map_val (fun x -> Cons (x, xs)) x

let singleton x = cons x nil

let lsingleton x = Lazy.map_val (fun x -> Cons (x, nil)) x

let hd_opt = function
| lazy Nil -> None
| lazy (Cons (x, _)) -> Some x

let hd = function
| lazy Nil -> failwith "hd nil"
| lazy (Cons (x, _)) -> x

let tl_opt = function
| lazy Nil -> None
| lazy (Cons (_, xs)) -> Some xs

let tl = function
| lazy Nil -> failwith "tl nil"
| lazy (Cons (_, xs)) -> xs

let at_opt i =
  let rec at_opt' i = function
  | lazy Nil -> None
  | lazy (Cons (x, xs)) ->
    if i = 0 then Some x else
    at_opt' (i - 1) xs
  in
  if i < 0 then invalid_arg "negative index";
  at_opt' i

let at i xs = match at_opt i xs with
| None -> raise Not_found
| Some x -> x

let nth_opt xs i = at_opt i xs

let nth xs i = match nth_opt xs i with
| None -> raise Not_found
| Some x -> x

let rec fold_left f acc = function
| lazy Nil -> acc
| lazy (Cons (x, xs)) -> fold_left f (f acc x) xs

let rec fold_right f xs acc = match xs with
| lazy Nil -> acc
| lazy (Cons (x, xs)) -> f x (fold_right f xs acc)

let length xs = fold_left (fun i _ -> i + 1) 0 xs

let rec iter f xs = match xs with
| lazy Nil -> ()
| lazy (Cons (x, xs)) -> f x; iter f xs

let iteri f xs =
  let i = ref 0 in
  iter (fun x -> f !i x; incr i) xs

let rec map f xs = lazy begin match xs with
| lazy Nil -> Nil
| lazy (Cons (x, xs)) -> Cons (f x, map f xs)
end

let mapi f =
  let rec mapi' i xs = lazy begin match xs with
  | lazy Nil -> Nil
  | lazy (Cons (x, xs)) -> Cons (f i x, mapi' (i + 1) xs)
  end in
  mapi' 0

let rec map_val f xs = xs |> Lazy.map_val begin function
| Nil -> Nil
| Cons (x, xs) -> Cons (f x, map_val f xs)
end

let mapi_val f =
  let rec mapi_val' i xs = xs |> Lazy.map_val begin function
  | Nil -> Nil
  | Cons (x, xs) -> Cons (f i x, mapi_val' (i + 1) xs)
  end in
  mapi_val' 0

let rec append xs ys = lazy begin match xs with
| lazy Nil -> Lazy.force ys
| lazy (Cons (x, xs)) -> Cons (x, append xs ys)
end

let rec append_val xs ys = xs |> Lazy.map_val begin function
| Nil -> Lazy.force ys
| Cons (x, xs) -> Cons (x, append_val xs ys)
end

let concat xss = List.fold_left append nil xss

let rec flatten xss = lazy begin match xss with
| lazy Nil -> Nil
| lazy (Cons (xs, xss)) -> Lazy.force @@ append xs (flatten xss)
end

let rec filter pred xs = lazy begin match xs with
| lazy Nil -> Nil
| lazy (Cons (x, xs)) ->
  let xs = filter pred xs in
  if pred x then Cons (x, xs) else Lazy.force xs
end

let rec combine xs ys = lazy begin match xs, ys with
| lazy Nil, lazy Nil -> Nil
| lazy (Cons (x, xs)), lazy (Cons (y, ys)) -> Cons ((x, y), combine xs ys)
| _ -> invalid_arg "unequal lengths"
end

let to_seq xs = xs |> Seq.unfold begin fun xs ->
  Option.map (fun x -> x, tl xs) (hd_opt xs)
end

let rec of_seq (xs: _ Seq.t) = lazy begin match xs () with
| Nil -> Nil
| Cons (x, xs) -> Cons (x, of_seq xs)
end