include module type of struct include Cachetbl_intf end

module Make (Key: Hashable.Basic) : S with type key = Key.t