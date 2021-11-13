include Cachetbl_intf

module Make (Key: Hashable.Basic) = struct
  module Table = Hashtbl.Make (Key)
  module WeakTable = Ephemeron.K1.Make (Key)
  type key = Key.t
  type weak_key = (key, unit) Ephemeron.K1.t

  type !'a t =
    { mutable capacity: int
    ; cached: int Table.t
    ; keys: weak_key Queue.t
    ; table: 'a WeakTable.t
    }

  let create n =
    if n < 0 then invalid_arg "negative size";
    { capacity = n
    ; cached = Table.create n
    ; keys = Queue.create ()
    ; table = WeakTable.create n
    }

  let copy tbl =
    { capacity = tbl.capacity
    ; cached = Table.copy tbl.cached
    ; keys = Queue.copy tbl.keys
    ; table = WeakTable.copy tbl.table
    }

  let cache_size tbl = Table.length tbl.cached

  let set_cache_capacity tbl n =
    if n < 0 then invalid_arg "negative capacity";
    tbl.capacity <- n

  let cache_capacity tbl = tbl.capacity

  let cached tbl k = Table.mem tbl.cached k

  let uncache tbl k = Table.remove tbl.cached k

  let remove tbl k =
    uncache tbl k;
    WeakTable.remove tbl.table k

  let rec uncache_oldest tbl = match Queue.pop tbl.keys |> Ephemeron.K1.get_key with
  | None -> uncache_oldest tbl
  | Some k ->
    begin match Table.find_opt tbl.cached k with
    | None -> uncache_oldest tbl
    | Some 1 -> Table.remove tbl.cached k
    | Some n ->
      assert (n >= 1);
      Table.replace tbl.cached k (n - 1);
      uncache_oldest tbl
    end

  let resize_cache tbl =
    while cache_size tbl >= tbl.capacity do uncache_oldest tbl done

  let cache tbl k =
    let n = Table.find_opt tbl.cached k |> Option.value ~default:0 in
    Table.replace tbl.cached k (n + 1);
    let wk = Ephemeron.K1.create () in
    Ephemeron.K1.set_key wk k;
    Queue.push wk tbl.keys;
    resize_cache tbl

  let add tbl k v = cache tbl k; WeakTable.add tbl.table k v

  let replace tbl k v = cache tbl k; WeakTable.replace tbl.table k v

  let mem tbl k = WeakTable.mem tbl.table k

  let clear tbl =
    Table.clear tbl.cached;
    WeakTable.clear tbl.table

  let reset tbl =
    Table.reset tbl.cached;
    WeakTable.reset tbl.table

  let find tbl = WeakTable.find tbl.table

  let find_opt tbl = WeakTable.find_opt tbl.table

  let find_all tbl = WeakTable.find_all tbl.table

  let iter f tbl = WeakTable.iter f tbl.table

  let filter_map_inplace f tbl = WeakTable.filter_map_inplace f tbl.table

  let fold f tbl = WeakTable.fold f tbl.table

  let length tbl = WeakTable.length tbl.table

  let stats tbl = WeakTable.stats tbl.table

  let stats_alive tbl = WeakTable.stats_alive tbl.table

  let stats_cached tbl = Table.stats tbl.cached

  let to_seq tbl = WeakTable.to_seq tbl.table

  let to_seq_keys tbl = WeakTable.to_seq_keys tbl.table

  let to_seq_values tbl = WeakTable.to_seq_values tbl.table

  let add_seq tbl xs = Seq.iter (fun (k, v) -> add tbl k v) xs

  let replace_seq = add_seq

  let of_seq xs =
    let xs = Array.of_seq xs in
    let tbl = create @@ Array.length xs in
    Array.iter (fun (k, v) -> add tbl k v) xs;
    tbl

  let clean tbl = WeakTable.clean tbl.table
end