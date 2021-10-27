include Storage_intf

module Make (T: Storable_intf.Basic) = struct
  type elt = T.t

  type t = { mutable length: int; mutable data: bytes }

  let () = if T.storage_size < 0 then invalid_arg "negative storage size"

  let max_capacity = Sys.max_string_length / T.storage_size

  let create cap =
    if cap < 0 then invalid_arg "negative capacity";
    if cap > max_capacity then invalid_arg "capacity exceeds system limits";
    let n = cap * T.storage_size in
    { length = 0
    ; data = Bytes.create n
    }

  let length store = store.length

  let discard store amt =
    if amt < 0 then invalid_arg "negative amount to discard";
    if store.length < amt then invalid_arg "amount to discard greater than length";
    store.length <- store.length - amt

  let clear store = store.length <- 0

  let capacity store = Bytes.length store.data / T.storage_size

  let unsafe_set_capacity store cap =
    let n = cap * T.storage_size in
    let data = Bytes.create n in
    Bytes.unsafe_blit store.data 0 data 0 (store.length * T.storage_size);
    store.data <- data

  let set_capacity store cap =
    if cap < 0 then invalid_arg "negative capacity";
    if cap > max_capacity then invalid_arg "capacity exceeds system limits";
    if length store > cap then invalid_arg "capacity less than length";
    if cap <> capacity store then unsafe_set_capacity store cap

  let unsafe_set store i v =
    let pos = i * T.storage_size in
    T.unsafe_store v store.data pos

  let unsafe_get store i =
    let pos = i * T.storage_size in
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