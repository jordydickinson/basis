include Monad.S with type 'a t := 'a option
include module type of struct include Stdlib.Option end