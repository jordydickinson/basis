include Storage_intf

module MakeBasic (T: Storable_intf.Basic) = struct
  type elt = T.t

  type t = { mutable length: int; mutable data: bytes }

  let () = if T.size < 0 then invalid_arg "negative storage size"

  let storage_size = T.size / 8 + if T.size mod 8 = 0 then 0 else 1

  let max_capacity = Sys.max_string_length / storage_size

  let create cap =
    if cap < 0 then invalid_arg "negative capacity";
    if cap > max_capacity then invalid_arg "capacity exceeds system limits";
    let n = cap * storage_size in
    { length = 0
    ; data = Bytes.create n
    }

  let length store = store.length

  let discard store amt =
    if amt < 0 then invalid_arg "negative amount to discard";
    if store.length < amt then invalid_arg "amount to discard greater than length";
    store.length <- store.length - amt

  let clear store = store.length <- 0

  let capacity store = Bytes.length store.data / storage_size

  let unsafe_set_capacity store cap =
    let n = cap * storage_size in
    let data = Bytes.create n in
    Bytes.unsafe_blit store.data 0 data 0 (store.length * storage_size);
    store.data <- data

  let set_capacity store cap =
    if cap < 0 then invalid_arg "negative capacity";
    if cap > max_capacity then invalid_arg "capacity exceeds system limits";
    if length store > cap then invalid_arg "capacity less than length";
    if cap <> capacity store then unsafe_set_capacity store cap

  let unsafe_set store i v =
    let pos = i * storage_size in
    T.unsafe_store v store.data pos

  let unsafe_get store i =
    let pos = i * storage_size in
    T.unsafe_restore store.data pos

  let set store i v =
    if i < 0 then invalid_arg "negative index";
    if i > store.length then invalid_arg "out of bounds";
    unsafe_set store i v

  let get store i =
    if i < 0 then invalid_arg "negative index";
    if i > store.length then invalid_arg "out of bounds";
    unsafe_get store i

  let unsafe_extend store amt init =
    let old_len = store.length in
    let new_len = old_len + amt in
    store.length <- new_len;
    for i = old_len to new_len - 1 do
      unsafe_set store i init
    done

  let extend store amt init =
    if amt < 0 then invalid_arg "negative amount to extend";
    if store.length + amt > capacity store then failwith "no capacity";
    unsafe_extend store amt init
end

module OfBasic (T: Basic) = struct
  include T

  let next_pow2 n =
    if n = 0 then 1 else
    let open Float in
    log (of_int n) /. log 2.
    |> ceil
    |> pow 2.
    |> to_int

  let ensure_capacity store cap =
    if cap > capacity store then set_capacity store (next_pow2 cap)

  let grow store amt v =
    ensure_capacity store (length store + amt);
    extend store amt v

  let compact store =
    let len = length store in
    let cap = capacity store in
    if len < cap / 2 then set_capacity store (next_pow2 len)

  let shrink store amt =
    discard store amt;
    compact store
end

module Make (T: Storable_intf.Basic) = OfBasic (MakeBasic (T))