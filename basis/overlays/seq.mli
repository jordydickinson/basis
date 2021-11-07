include Monad.S with type 'a t := 'a Stdlib.Seq.t
include module type of struct include Stdlib.Seq end