include Equatable.S with type t := int32
include Comparable.S with type t := int32
include Hashable.S with type t := int32
include module type of struct include Stdlib.Int32 end