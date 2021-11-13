(** A basic interface for contiguous, resizable storage of elements. *)
module type Basic = sig
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

module type S = sig
  include Basic

  (** [ensure_capacity store cap] will ensure that [store] has enough capacity
      to fit [cap] elements, reallocating the underlying data if necessary. This
      function will choose the least power of two greater than [cap] for the new
      capacity if a reallocation is necessary, so calling this function often is
      relatively cheap.

      @raise Invalid_arg if [cap] is negative or greater than {!val:max_capacity}.
    *)
  val ensure_capacity : t -> int -> unit

  (** [grow store amt v] is like {!val:extend} with the same arguments, but it
      also will ensure that there is enough capacity to fit the extra elements,
      as in {!val:ensure_capacity}.

      @raise Invalid_arg if [amt] is negative or the new length is greater than
      {!val:max_capacity}
    *)
  val grow : t -> int -> elt -> unit

  (** [compact store] will reduce the capacity of [store] to the least power of
      two greater than [store]'s current length, or do nothing if the capacity
      is already less than or equal to this value. *)
  val compact : t -> unit

  (** [shrink store amt] is like {!val:discard} with the same arguments, but it
      additionally will reduce the capacity as in {!val:compact}. *)
  val shrink : t -> int -> unit
end