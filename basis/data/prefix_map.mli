include module type of struct include Prefix_map_intf end

module Make (KeyMap: Map.S): S with type key = KeyMap.key