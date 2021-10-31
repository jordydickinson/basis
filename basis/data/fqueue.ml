type +'a t =
  { pushed: 'a list
  ; unpopped: 'a list
  }

let empty = { pushed = []; unpopped = [] }

let is_empty = function
| { pushed = []; unpopped = [] } -> true
| _ -> false

let push x q = { q with pushed = x :: q.pushed }

let pop_opt = function
| { pushed = []; unpopped = [] } -> None
| { pushed; unpopped = [] } ->
  let unpopped = List.rev pushed in
  let x, unpopped = List.hd unpopped, List.tl unpopped in
  Some (x, { pushed = []; unpopped })
| { pushed; unpopped } ->
  let x, unpopped = List.hd unpopped, List.tl unpopped in
  Some (x, { pushed; unpopped })

let pop q = match pop_opt q with
| None -> failwith "pop empty"
| Some (x, q) -> x, q

let map f { pushed; unpopped } =
  { pushed = List.map f pushed
  ; unpopped = List.map f unpopped
  }

let of_seq xs = Seq.fold_left (Fun.flip push) empty xs

let to_seq q = Seq.unfold pop_opt q