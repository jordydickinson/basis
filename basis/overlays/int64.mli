include module type of struct include Stdlib.Int64 end

(** [set_bit ~at i] is [i] with the bit at offset [at] set.
  
    @raise Invalid_arg if [at] is negative or greater than 63. *)
val set_bit : at:int -> t -> t

(** [clear_bit ~at i] is [i] with the bit at offset [at] cleared.

    @raise Invalid_arg if [at] is negative or greater than 63.
  *)
val clear_bit : at:int -> t -> t

(** [test_bit ~at i] is [true] if the bit at offset [at] is set and [false] if
    it's cleared.

    @raise Invalid_arg if [at] is negative or greater than 63.
  *)
val test_bit : at:int -> t -> bool