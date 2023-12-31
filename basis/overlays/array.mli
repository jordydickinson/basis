include module type of struct include Stdlib.Array end
include Comparable.Container with type 'a t := 'a t

val transpose: 'a t t -> 'a t t