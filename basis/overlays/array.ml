include Stdlib.Array

include Comparable.MakeContainer(struct
  type nonrec 'a t = 'a t

  let compare compare_elt xs ys =
    if length xs = 0 && length ys = 0 then 0 else

    let i = ref 0 in
    let cmp = ref 0 in
    while !cmp = 0 && !i < length xs && !i < length ys do
      cmp := compare_elt (get xs !i) (get ys !i);
      incr i
    done;

    if !cmp <> 0 then !cmp else
    if length xs < length ys then -1 else
    if length xs > length ys then 1 else
    0
end)

let transpose xxs =
  let ncols = length xxs in
  if ncols = 0 then [||] else
  let nrows = length @@ get xxs 0 in
  init nrows begin fun coli -> init ncols begin fun rowi ->
    get (get xxs rowi) coli
  end end