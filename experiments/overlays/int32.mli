include Storable.S with type t := int32
include module type of struct include Basis.Int32 end

(** [set_bit ~at i] is [i] with the bit at offset [at] set.
  
    @raise Invalid_arg if [at] is negative or greater than 31. *)
val set_bit : at:int -> t -> t

(** [clear_bit ~at i] is [i] with the bit at offset [at] cleared.

    @raise Invalid_arg if [at] is negative or greater than 31.
  *)
val clear_bit : at:int -> t -> t

(** [test_bit ~at i] is [true] if the bit at offset [at] is set and [false] if
    it's cleared.

    @raise Invalid_arg if [at] is negative or greater than 31.
  *)
val test_bit : at:int -> t -> bool