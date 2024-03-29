module type Infix = sig
  include Monad.Infix2

  val (<+>): ('a, 's) t -> ('a, 's) t -> ('a, 's) t
end

module type BasicOpen = sig
  include Monad.Open2
  include Infix with type ('a, 's) t := ('a, 's) t

  (** [succeed] is a state monad with one possible result, [()]. *)
  val succeed: (unit, 's) t

  (** [fail] is a state monad with no possible results. *)
  val fail: ('a, 's) t

  (** [cut m] is [m] truncated to one possible result. *)
  val cut: ('a, 's) t -> ('a, 's) t

  (** [append m1 m2] is a state monad with all the possibilities of [m1] and
      [m2]. *)
  val append: ('a, 's) t -> ('a, 's) t -> ('a, 's) t

  (** [filter f m] is a state monad with all the possibilities of [m], except
      those which satisfy [f]. *)
  val filter: ('a -> 's -> bool) -> ('a, 's) t -> ('a, 's) t
end

module type Open = sig
  include BasicOpen

  (** [run m s] runs the ambiguous state monad [m] with initial state [s],
      returning a sequence of possible results. *)
  val run: ('a, 's) t -> 's -> ('a * 's) Seq.t

  (** [get] is a state monad which obtains the current state. It has one possible
      result. *)
  val get: ('s, 's) t

  (** [set s] is a state monad which sets the current state to [s]. It has one
      possible result, [()]. *)
  val set: 's -> (unit, 's) t
end

module type S = sig
  type (+'a, !'s) t

  val of_state: ('a, 's) State.t -> ('a, 's) t

  val lift_state: ('a -> ('b, 's) State.t) -> ('a, 's) t -> ('b, 's) t

  (** [to_state m] is a deterministic state monad which returns [Some] result of
      [cut m] or [None] if [cut m] fails. *)
  val to_state: ('a, 's) t -> ('a option, 's) State.t

  module Infix: Infix with type ('a, 's) t := ('a, 's) t
  module O: Open with type ('a, 's) t := ('a, 's) t
  include Open with type ('a, 's) t := ('a, 's) t

  include Monad.S2
    with type ('a, 's) t := ('a, 's) t
    with module Infix := Infix
    with module O := O
end