module type Open = sig
  include Monad.Open2

  (** [run m s] runs the state monad [m] with initial state [s] and returns the
      result. *)
  val run: ('a, 's) t -> 's -> 'a * 's

  (** [get] is a state monad which obtains the current state. *)
  val get: ('s, 's) t

  (** [set s] is a state monad which sets the current state to [s]. *)
  val set: 's -> (unit, 's) t
end
