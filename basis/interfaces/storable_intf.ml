module type Basic = sig
  type t

  (** The number of bytes required to store this type. *)
  val storage_size: int

  (** [unsafe_store src dst pos] writes {!val:storage_size} bytes to [dst]
      representing the value of [src] at byte offset [pos].
      
      The behavior of this function is undefined when [pos] is negative or
      [pos + storage_size] is greater than or equal to [Bytes.length dst].
    *)
  val unsafe_store: t -> bytes -> int -> unit

  (** [unsafe_restore src pos] reads {!val:storage_size} bytes from [src] and
      returns the value previously stored at byte offset [pos].

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