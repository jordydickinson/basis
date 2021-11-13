include Equatable.S with type t := int64
include Comparable.S with type t := int64
include Hashable.S with type t := int64
include module type of struct include Stdlib.Int64 end