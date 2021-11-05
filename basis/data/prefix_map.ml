include Prefix_map_intf

module Make (KeyMap: Map.S) = struct
  type key = KeyMap.key
  type path = key list

  type +'a node =
  | Leaf of 'a
  | Branch of 'a option * 'a t

  and +'a t = 'a node KeyMap.t

  let empty = KeyMap.empty

  let is_empty = KeyMap.is_empty

  let leaf a = Leaf a

  let branch_opt a m =
    if is_empty m then match a with
    | None -> None
    | Some a -> Some (Leaf a)
    else Some (Branch (a, m))

  let qualify ks m = if is_empty m then empty else
    List.fold_left (fun m k -> KeyMap.singleton k @@ Branch (None, m)) m ks

  let singleton k v = KeyMap.singleton k (Leaf v)

  let rec switch ks m = match ks with
  | [] -> m
  | k :: ks ->
    begin match KeyMap.find_opt k m with
    | None | Some Leaf _ -> empty
    | Some Branch (_, m) -> switch ks m
    end

  let rec under ks f = match ks with
  | [] -> f
  | k :: ks -> KeyMap.update k begin function
    | None ->
      let m = f empty in
      if is_empty m then None else
      Some (Branch (None, m))
    | Some Leaf v as x ->
      let m = f empty in
      if is_empty m then x else
      Some (Branch (Some v, m))
    | Some Branch (v_opt, m) as x ->
      let m' = under ks f m in
      if m' == m then x else
      if is_empty m' then Option.map (fun v -> Leaf v) v_opt else
      Some (Branch (v_opt, m))
    end

  let remove k = KeyMap.update k begin function
  | None | Some Leaf _ -> None
  | Some (Branch (None, _)) as x -> x
  | Some (Branch (_, m)) -> Some (Branch (None, m))
  end

  let add k v = KeyMap.update k begin function
  | None | Some Leaf _ -> Some (Leaf v)
  | Some (Branch (Some v', _)) as x when v == v' -> x
  | Some (Branch (_, m)) -> Some (Branch (Some v, m))
  end

  let update k f = KeyMap.update k begin function
  | None -> f None |> Option.map leaf
  | Some Leaf a -> f (Some a) |> Option.map leaf
  | Some Branch (v, m) as x ->
    let v' = f v in
    if v == v' then x else
    Some (Branch (v', m))
  end

  let rec filter_map f = KeyMap.filter_map begin fun k -> function
  | Leaf a -> f [] k a |> Option.map (fun a -> Leaf a)
  | Branch (a, m) ->
    let a = Option.bind a (f [] k) in
    let m = filter_map (fun ks -> f (k :: ks)) m in
    if is_empty m then match a with
    | None -> None
    | Some a -> Some (Leaf a)
    else Some (Branch (a, m))
  end

  let filter f = filter_map (fun ks k a -> if f ks k a then Some a else None)

  let rec merge f = KeyMap.merge begin fun k m1 m2 -> match m1, m2 with
  | None, None -> Option.map leaf @@ f [] k None None
  | None, Some Leaf a -> Option.map leaf @@ f [] k None (Some a)
  | Some Leaf a, None -> Option.map leaf @@ f [] k (Some a) None
  | None, Some Branch (a, m) ->
    let a = f [] k None a in
    let m = filter_map (fun ks k a -> f ks k None (Some a)) m in
    branch_opt a m
  | Some Branch (a, m), None ->
    let a = f [] k a None in
    let m = filter_map (fun ks k a -> f ks k (Some a) None) m in
    branch_opt a m
  | Some Leaf a1, Some Leaf a2 -> f [] k (Some a1) (Some a2) |> Option.map leaf
  | Some Leaf a1, Some Branch (a2, m) ->
    let a = f [] k (Some a1) a2 in
    let m = filter_map (fun ks k a -> f ks k None (Some a)) m in
    branch_opt a m
  | Some Branch (a1, m), Some Leaf a2 ->
    let a = f [] k a1 (Some a2) in
    let m = filter_map (fun ks k a -> f ks k (Some a) None) m in
    branch_opt a m
  | Some Branch (a1, m1), Some Branch (a2, m2) ->
    let a = f [] k a1 a2 in
    let m = merge (fun ks -> f (k :: ks)) m1 m2 in
    branch_opt a m
  end

  let union f = merge begin fun ks k a1 a2 -> match a1, a2 with
  | None, None -> None
  | None, a | a, None -> a
  | Some a1, Some a2 -> f ks k a1 a2
  end

  let rec equal equal_elt = KeyMap.equal begin fun m1 m2 -> match m1, m2 with
  | Leaf a1, Leaf a2 -> equal_elt a1 a2
  | Leaf _, _ -> false
  | Branch (a1, m1), Branch (a2, m2) ->
    Option.equal equal_elt a1 a2 && equal equal_elt m1 m2
  | Branch _, _ -> false
  end

  let rec iter f = KeyMap.iter begin fun k -> function
  | Leaf a -> f [] k a
  | Branch (a, m) -> Option.iter (f [] k) a; iter (fun ks -> f (k :: ks)) m
  end

  let rec fold f = KeyMap.fold begin fun k m acc -> match m with
  | Leaf a -> f [] k a acc
  | Branch (a, m) ->
    a
    |> Option.map (fun a -> f [] k a acc)
    |> Option.value ~default:acc
    |> fold (fun ks -> f (k :: ks)) m
  end

  let rec for_all f = KeyMap.for_all begin fun k -> function
  | Leaf a -> f [] k a
  | Branch (a, m) ->
    Option.map (f [] k) a |> Option.value ~default:true &&
    for_all (fun ks -> f (k :: ks)) m
  end

  let rec exists f = KeyMap.exists begin fun k -> function
  | Leaf a -> f [] k a
  | Branch (a, m) ->
    Option.map (f [] k) a |> Option.value ~default:false ||
    exists (fun ks -> f (k :: ks)) m
  end

  let partition f m = fold
    (fun ks k a (m1, m2) -> if f ks k a then (add k a m1, m2) else (m1, add k a m2))
    m
    (empty, empty)

  let cardinal m = fold (fun _ _ _ acc -> acc + 1) m 0

  let rec map f = KeyMap.map begin function
  | Leaf a -> Leaf (f a)
  | Branch (a, m) -> Branch (Option.map f a, map f m)
  end
end