module type Basic = sig
  type t

  (** The number of bits required to store this type. *)
  val size: int

  (** [unsafe_store src dst pos] writes {!val:size} bits to [dst] representing
      the value of [src] at byte offset [pos]. If {!val:size} is not a multiple
      of eight, the high [size mod 8] bits of [dst] must not contain information
      relevant to the storage of [src], but they may be modified.
      
      The behavior of this function is undefined when [pos] is negative or
      [pos + storage_size] is greater than or equal to [Bytes.length dst].
    *)
  val unsafe_store: t -> bytes -> int -> unit

  (** [unsafe_restore src pos] reads {!val:size} bits from [src] and returns the
      value previously stored at byte offset [pos]. If {!val:size} is not a
      multiple of eight, the high [size mod 8] bits of [src] must not affect the
      value returned by this function.

      The behavior of this function is undefined when [pos] is negative,
      [pos + storage_size] is greater than or equal to [Bytes.length src], no
      value was previously stored at [pos], or when a value was perviously
      stored but the data in [src] from [pos] to [pos + storage_size] was
      modified at some point after the store and before the call to this
      function.
    *)
  val unsafe_restore: bytes -> int -> t
end

module type S = sig
  include Basic
  module Storage: Storage_intf.S with type elt = t
end