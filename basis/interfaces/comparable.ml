include Comparable_intf

module Infix (T: Basic) = struct
  let ( < ) a b = compare a b < 0
  and ( <= ) a b = compare a b <= 0
  and ( > ) a b = compare a b > 0
  and ( >= ) a b = compare a b >= 0
end

module Make (T: Basic) = struct
  include T

  module Set = Set.Make (T)
  module Map = Map.Make (T)
end

module MakeContainer (T: BasicContainer) = struct
  include T
  
  module MakeComparable (T: Basic) = Make (struct
    type nonrec t = T.t t
    let compare = compare T.compare
  end)
end