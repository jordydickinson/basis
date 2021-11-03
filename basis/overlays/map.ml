include Stdlib.Map
include Map_intf

module Make (T: OrderedType) = struct
  include Make (T)

  let add_multi k v = update k begin function
  | None -> Some [v]
  | Some vs -> Some (v :: vs)
  end

  let remove_multi k = update k begin function
  | None -> None
  | Some [] -> None
  | Some [_] -> None
  | Some (_ :: vs) -> Some vs
  end
end