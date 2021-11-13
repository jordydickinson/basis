type !'a data = { mutable elts: 'a; mutable length: int }
type !'a initdata = { data: 'a array data; init: 'a }
type floatdata = floatarray data
type chardata = bytes data 

type !'a data_pair =
| Initdata_pair of 'a initdata * 'a initdata
| Floatdata_pair : floatdata * floatdata -> float data_pair
| Chardata_pair : chardata * chardata -> char data_pair

type !'a raw =
| Initdata of 'a initdata
| Floatdata : floatdata -> float raw
| Chardata : chardata -> char raw

type !'a t = 'a raw ref

let create cap init = ref @@ Initdata
  { data =
    { elts = Array.make cap init
    ; length = 0
    }
  ; init
  }

let create_float cap = ref @@ Floatdata
  { elts = Float.Array.create cap
  ; length = 0
  }

let create_char cap = ref @@ Chardata
  { elts = Bytes.create cap
  ; length = 0
  }

let capacity (type a) (xs: a t) = match !xs with
| Initdata { data = { elts; _ } ; _ } -> Array.length elts
| Floatdata { elts; _ } -> Float.Array.length elts
| Chardata { elts; _ } -> Bytes.length elts

let length (type a) (xs: a t) = match !xs with
| Initdata { data = { length; _ }; _ } -> length
| Floatdata { length; _ } -> length
| Chardata { length; _ } -> length

let specialize_float (xs: float t) = match !xs with
| Floatdata _ -> ()
| Initdata { data = { elts; length }; _ } ->
  let new_elts = Float.Array.create (Array.length elts) in
  for i = 0 to length - 1 do
    Float.Array.set new_elts i elts.(i)
  done;
  xs := Floatdata { elts = new_elts; length }

let specialize_char (xs: char t) = match !xs with
| Chardata _ -> ()
| Initdata { data = { elts; length }; _ } ->
  let new_elts = Bytes.create (Array.length elts) in
  for i = 0 to length - 1 do
    Bytes.set new_elts i elts.(i)
  done;
  xs := Chardata { elts = new_elts; length }

let rec make_data_pair
: type a. a t -> a t -> a data_pair
= fun (type a) (xs: a t) (ys: a t) -> match !xs, !ys with
| Initdata xs, Initdata ys -> Initdata_pair (xs, ys)
| Floatdata xs, Floatdata ys -> Floatdata_pair (xs, ys)
| Chardata xs, Chardata ys -> Chardata_pair (xs, ys)
| (_ : a raw), (Floatdata _ : a raw) ->
  specialize_float xs;
  make_data_pair xs ys
| (Floatdata _ : a raw), (_ : a raw) ->
  specialize_float ys;
  make_data_pair xs ys
| (_ : a raw), (Chardata _ : a raw) ->
  specialize_char xs;
  make_data_pair xs ys
| (Chardata _ : a raw), (_ : a raw) ->
  specialize_char ys;
  make_data_pair xs ys

let to_array (type a) (xs: a t) : a array = match !xs with
| Initdata { data = { elts; length }; _ } -> Array.sub elts 0 length
| Floatdata { elts; length } -> Array.init length (Float.Array.get elts)
| Chardata { elts; length } -> Array.init length (Bytes.get elts)

let rec to_floatarray (xs: float t) : floatarray = match !xs with
| Floatdata { elts; length } -> Float.Array.sub elts 0 length
| Initdata _ -> specialize_float xs; to_floatarray xs

let rec to_bytes (xs: char t) : bytes = match !xs with
| Chardata { elts; length } -> Bytes.sub elts 0 length
| Initdata _ -> specialize_char xs; to_bytes xs

let set_capacity (type a) (xs: a t) cap
= if cap = capacity xs then () else match !xs with
| Initdata xs ->
  let elts = Array.init cap begin fun i ->
    if i < xs.data.length then xs.data.elts.(i) else xs.init
  end in
  let length = min xs.data.length cap in
  xs.data.elts <- elts;
  xs.data.length <- length
| Floatdata xs ->
  let elts = Float.Array.create cap in
  let length = min xs.length cap in
  Float.Array.blit xs.elts 0 elts 0 length;
  xs.elts <- elts;
  xs.length <- length
| Chardata xs ->
  let offset = cap - Bytes.length xs.elts in
  let elts = Bytes.extend xs.elts 0 offset in
  let length = min xs.length cap in
  xs.elts <- elts;
  xs.length <- length

let next_pow2 i =
  let open Float in
  log (of_int i) /. log 2. |> ceil |> pow 2. |> to_int

let ensure_capacity xs cap =
  if cap < 0 then invalid_arg "negative capacity";
  let old_cap = capacity xs in
  if cap <= old_cap then () else
  let cap = next_pow2 cap in
  set_capacity xs cap

let set_length (type a) (xs: a t) len = ensure_capacity xs len; match !xs with
| Initdata xs -> xs.data.length <- len
| Floatdata xs -> xs.length <- len
| Chardata xs -> xs.length <- len

let ensure_length xs len = if len > length xs then set_length xs len

let compact xs =
  let cap = capacity xs in
  let len = length xs in
  if len < cap / 2 then set_capacity xs (next_pow2 len)

let unsafe_set (type a) (xs: a t) i (v: a) = match !xs with
| Initdata { data = { elts; _ }; _ } -> Array.unsafe_set elts i v
| Floatdata { elts; _ } -> Float.Array.unsafe_set elts i v
| Chardata { elts; _ } -> Bytes.unsafe_set elts i v

let set xs i v =
  if i < 0 then invalid_arg "negative index";
  if i >= length xs then raise Not_found;
  unsafe_set xs i v

let unsafe_get (type a) (xs: a t) i : a = match !xs with
| Initdata { data = { elts; _ }; _ } -> Array.unsafe_get elts i
| Floatdata { elts; _ } -> Float.Array.unsafe_get elts i
| Chardata { elts; _ } -> Bytes.unsafe_get elts i

let get xs i =
  if i < 0 then invalid_arg "negative index";
  if i >= length xs then raise Not_found;
  unsafe_get xs i

let push xs v =
  let len = length xs in
  set_length xs (len + 1);
  unsafe_set xs len v

let pop xs =
  let len = length xs in
  if len = 0 then raise Not_found;
  let x = unsafe_get xs (len - 1) in
  set_length xs (len - 1);
  compact xs;
  x

let pop_opt xs = try Some (pop xs) with Not_found -> None

let unsafe_fill (type a) (xs: a t) pos len (v: a) = match !xs with
| Initdata xs -> Array.fill xs.data.elts pos len v
| Floatdata xs -> Float.Array.fill xs.elts pos len v
| Chardata xs -> Bytes.unsafe_fill xs.elts pos len v

let fill xs pos len v =
  if pos < 0 then invalid_arg "negative start index";
  if len < 0 then invalid_arg "negative length";
  let new_len = max (length xs) (pos + len) in
  set_length xs new_len;
  unsafe_fill xs pos len v

let unsafe_blit (type a) (src: a t) src_pos (dst: a t) dst_pos len
= match make_data_pair src dst with
| Initdata_pair (src, dst) ->
  Array.blit src.data.elts src_pos dst.data.elts dst_pos len
| Floatdata_pair (src, dst) ->
  Float.Array.blit src.elts src_pos dst.elts dst_pos len
| Chardata_pair (src, dst) ->
  Bytes.unsafe_blit src.elts src_pos dst.elts dst_pos len

let blit src src_pos dst dst_pos len =
  if src_pos < 0 then invalid_arg "negative source position";
  if dst_pos < 0 then invalid_arg "negative destination position";
  if len < 0 then invalid_arg "negative length";
  ensure_length dst (dst_pos + len);
  unsafe_blit src src_pos dst dst_pos len

let iteri f xs =
  let get = unsafe_get xs in
  let len = length xs in
  for i = 0 to len - 1 do
    f i @@ get i
  done

let iter f = iteri (fun _ -> f)

let mapi_into f src dst =
  ensure_length dst (length src);
  src |> iteri begin fun i x ->
    unsafe_set dst i (f i x)
  end

let map_into f = mapi_into (fun _ -> f)

let mapi_inplace f xs = mapi_into f xs xs

let map_inplace f = mapi_inplace (fun _ -> f)

let init length init f =
  let xs = create length init in
  set_length xs length;
  mapi_inplace (fun i _ -> f i) xs;
  xs

let init_float length f =
  let xs = create_float length in
  set_length xs length;
  mapi_inplace (fun i _ -> f i) xs;
  xs

let init_char length f =
  let xs = create_char length in
  set_length xs length;
  mapi_inplace (fun i _ -> f i) xs;
  xs

let mapi init' f xs = init (length xs) init' (fun i -> f i (get xs i))

let map init' f = mapi init' (fun _ -> f)

let mapi_float f xs =
  let ys = create_float (length xs) in
  mapi_into f xs ys;
  ys

let map_float f = mapi_float (fun _ -> f)

let mapi_char f xs =
  let ys = create_char (length xs) in
  mapi_into f xs ys;
  ys

let map_char f = mapi_char (fun _ -> f)

let fold_left f init xs =
  let acc = ref init in
  iter (fun x -> acc := f !acc x) xs;
  !acc

let fold_right f xs init =
  let get = unsafe_get xs in
  let acc = ref init in
  for i = length xs - 1 downto 0 do
    acc := f (get i) !acc
  done;
  !acc

let iteri2 f xs ys =
  let get = unsafe_get ys in
  let len = length xs in
  if len <> length ys then invalid_arg "unequal lengths";
  xs |> iteri (fun i x -> f i x @@ get i)

let iter2 f = iteri2 (fun _ -> f)

let mapi2 init f xs ys =
  let len = length xs in
  if len <> length ys then invalid_arg "unequal lengths";
  let zs = create len init in
  let set = unsafe_set zs in
  iteri2 (fun i x y -> set i (f i x y)) xs ys;
  zs

let map2 init f = mapi2 init (fun _ -> f)

let for_alli pred xs =
  let get = unsafe_get xs in
  let all_so_far = ref true in
  let i = ref 0 in
  let len = length xs in
  while !all_so_far && !i < len do
    all_so_far := pred !i (get !i);
    incr i
  done;
  !all_so_far

let for_all pred = for_alli (fun _ -> pred)

let existsi pred = Fun.negate @@ for_alli (fun i -> Fun.negate @@ pred i)

let exists pred = existsi (fun _ -> pred)

let for_alli2 pred xs ys =
  if length xs <> length ys then invalid_arg "unequal lengths";
  for_alli (fun i x -> pred i x (get ys i)) xs

let for_all2 pred = for_alli2 (fun _ -> pred)

let existsi2 pred xs =
  Fun.negate @@ for_alli2 (fun i x -> Fun.negate @@ pred i x) xs

let exists2 pred = existsi2 (fun _ -> pred)

let mem x = exists ((=) x)

let memq x = exists ((==) x)

let equal equal_elt xs ys =
  if xs == ys then true else
  if length xs <> length ys then false else
  for_all2 equal_elt xs ys

let compare compare_elt xs ys =
  if xs == ys then 0 else
  let c = ref 0 in
  let i = ref 0 in
  let len_xs = length xs in
  let len_ys = length ys in
  let len = min len_xs len_ys in
  while !c = 0 && !i < len do
    c := compare_elt (get xs !i) (get ys !i);
    incr i
  done;
  if !c = 0 then Int.compare len_xs len_ys else !c