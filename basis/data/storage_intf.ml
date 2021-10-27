(** An interface for contiguous, resizable storage of elements. *)
module type S = sig
  (** Elements being stored *)
  type elt

  (** Storage *)
  type t

  (** The maximum number of elements that can be stored. *)
  val max_capacity: int

  (** [create capacity] creates storage for at most [capacity] elements or
      @raise Invalid_arg if the provided capacity is negative or greater than
      {!val:max_capacity}. *)
  val create : int -> t

  (** [length store] is the number of elements stored in [store]. *)
  val length : t -> int

  (** [discard store amt] discards [amt] elements from the end of [store] or
      @raise Invalid_arg if [amt] is negative or [amt] is greater than the
      number of stored elements. *)
  val discard : t -> int -> unit

  (** [clear store] is the same as [discard store (length store)]. *)
  val clear : t -> unit

  (** [capacity store] is the current capacity of [store]; i.e., the maximum
      {!val:length}. *)
  val capacity : t -> int

  (** [set_capacity store cap] shrinks or grows the underlying memory of [store]
      to accomodate a maximum of [cap] elements or @raise Invalid_arg if the new
      capacity is negative, cannot fit the number of stored elements, or is
      greater than {!val:max_capacity}. *)
  val set_capacity : t -> int -> unit

  (** [set store i v] stores the value [v] in [store] at index [i] or @raise
      Invalid_arg if [i] is negative or greater than the length of [store]. *)
  val set : t -> int -> elt -> unit

  (** [unsafe_set] is like {!val:set}, but where {!val:set} would raise an
      exception, the behavior of [unsafe_set] is undefined. *)
  val unsafe_set : t -> int -> elt -> unit

  (** [get store i] returns the value stored at index [i] or @raise Invalid_arg
      is [i] is negative or greater than the length of [store]. *)
  val get : t -> int -> elt

  (** [unsafe_get] is like {!val:get}, but where {!val:get} would raise an
      exception, the behavior of [unsafe_get] is undefined. *)
  val unsafe_get : t -> int -> elt

  (** [extend store amt v] extends [store] with [amt] copies of [v], increasing
      the length of [store] by [amt]. 
      
      @raise Invalid_arg is [amt] is negative or exceeds the capacity of [store]
    *)
  val extend : t -> int -> elt -> unit
end