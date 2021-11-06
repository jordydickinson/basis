include Equatable.S with type t := string
include Comparable.S with type t := string
include Hashable.S with type t := string
include Stringable.S with type t := string
include module type of struct include Stdlib.String end