include Hashable_intf

module Make (T: Basic) = struct
  include T
  module WeakHashset = Weak.Make (T)
  module Table = Hashtbl.Make (T)
  module WeakTable = Ephemeron.K1.Make (T)
end

module MakeSeeded (T: SeededBasic) = struct
  include T
  module SeededTable = Hashtbl.MakeSeeded (struct
    include T
    let hash = seeded_hash
  end)
end