include Storable_intf

module Make (T: Basic) = struct
  include T
  module Storage = Storage.Make (T)
end