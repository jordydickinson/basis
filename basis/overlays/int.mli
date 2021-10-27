include Equatable.S with type t := int
include Comparable.S with type t := int
include Hashable.S with type t := int
include Storable.S with type t := int
include module type of struct include Stdlib.Int end