include Hashable_intf

module Make (T: Basic) = struct
  include T
  module Table = Hashtbl.Make (T)
end

module MakeWeak (T: Basic) = struct
  include T
  module WeakHashset = Weak.Make (T)
  module WeakTable = Ephemeron.K1.Make (T)
end

module MakeSeeded (T: SeededBasic) = struct
  include T
  module SeededTable = Hashtbl.MakeSeeded (T)
end