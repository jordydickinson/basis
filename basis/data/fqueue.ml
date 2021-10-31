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
| { pushed = [x]; unpopped = [] }
| { pushed = []; unpopped = [x] } -> Some (x, empty)
| { pushed; unpopped = [] } ->
  let unpopped = List.rev pushed in
  let x, unpopped = List.hd unpopped, List.tl unpopped in
  Some (x, { pushed = []; unpopped })
| { pushed; unpopped } ->
  let x, unpopped = List.hd unpopped, List.tl unpopped in
  Some (x, { pushed; unpopped })

let pop q = match pop_opt q with
| None -> failwith "pop empty"
| Some xxs -> xxs

let map f xs =
  if is_empty xs then empty else
  { pushed = List.map f xs.pushed
  ; unpopped = List.map f xs.unpopped
  }

let of_seq xs = Seq.fold_left (Fun.flip push) empty xs

let to_seq xs =
  if is_empty xs then Seq.empty else
  Seq.unfold pop_opt xs

let to_list xs =
  if is_empty xs then [] else
  xs.unpopped @ List.rev xs.pushed