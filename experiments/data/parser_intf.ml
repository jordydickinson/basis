module type Open = sig
  include Monad.Open3

  (** Indicates the end of input *)
  type eoi

  (** [error e] is a parser which always fails with [e]. *)
  val error: 'e -> ('a, 'e, 'i) t

  (** [of_result r] is a parser which consumes no input and succeeds or fails
      according to [r]. *)
  val of_result: ('a, 'e) result -> ('a, 'e, 'i) t

  (** [bind_result] is like {!val:bind} but the function is passed the result of
      the parser and is called even if the parser fails. *)
  val bind_result: (('a, 'e) result -> ('b, 'f, 'i) t) -> ('a, 'e, 'i) t -> ('b, 'f, 'i) t

  (** [lift_result f] is equivalent to [bind_result (fun x -> of_result (f x))].
    *)
  val lift_result: (('a, 'e) result -> ('b, 'f) result) -> ('a, 'e, 'i) t -> ('b, 'f, 'i) t

  (** [run p input] runs the parser [p] with input [input] and returns the
      result. *)
  val run: ('a, 'e, 'i) t -> 'i list -> ('a, 'e) result * 'i list

  (** [peek] is a parser which obtains the next input element without advancing
      the input stream, or fails on end-of-input. *)
  val peek: ('i, eoi, 'i) t

  (** [skip] is a parser which advances the input stream or fails on
      end-of-input. *)
  val skip: (unit, eoi, 'i) t

  (** [next] is a parser which obtains the next input element and advances the
      input stream, or fails on end-of-input. *)
  val next: ('i, eoi, 'i) t

  (** [recover f p] is a parser which has the same behavior of [p] when [p]
      succeeds, and the behavior of [f e] when [m] fails with [Error e]. *)
  val recover: ('e -> ('a, 'f, 'i) t) -> ('a, 'e, 'i) t -> ('a, 'f, 'i) t

  (** [alt p1 p2] succeeds with the result of [p1] if [p1] succeeds, and
      otherwise is equivalent to [p2]. [alt p1 p2] is equivalent to
      [recover (fun _ -> p2) p1]. *)
  val alt: ('a, 'e, 'i) t -> ('a, 'f, 'i) t -> ('a, 'f, 'i) t

  (** [first ps] is a parser which attempts each of [ps] in sequence. If some
      [p] in [ps] succeeds, the first such [p] determines the behavior of
      [first ps]. Otherwise, if all of [ps] fail, their errors are collected
      into a list [es], and the result is [Error es].
    *)
  val first: ('a, 'e, 'i) t list -> ('a, 'e list, 'i) t

  (** [opt p] is a parser which succeeds with [Some] result of [p] or [None] if
      [p] fails. *)
  val opt: ('a, _, 'i) t -> ('a option, _, 'i) t

  (** [many p] is a parser which runs [p] as many times as it succeeds, and
      collects the results into a list. *)
  val many: ('a, _, 'i) t -> ('a list, _, 'i) t
end

module type Infix = sig
  include Monad.Infix3

  (** [p >>! f] is [recover f p]. *)
  val ( >>! ) : ('a, 'e, 'i) t -> ('e -> ('a, 'f, 'i) t) -> ('a, 'f, 'i) t

  (** [( <|> )] is [alt]. *)
  val ( <|> ) : ('a, 'e, 'i) t -> ('a, 'f, 'i) t -> ('a, 'f, 'i) t
end

module type S = sig
  include Open
  module O: Open
    with type ('a, 'e, 'i) t := ('a, 'e, 'i) t
    with type eoi := eoi
  include Infix with type ('a, 'e, 'i) t := ('a, 'e, 'i) t
  module Infix: Infix with type ('a, 'e, 'i) t := ('a, 'e, 'i) t

  include Monad.S3
    with type ('a, 'e, 'i) t := ('a, 'e, 'i) t
    with module Infix := Infix
    with module O := O

  (** [memoize n f] is the memoized fixpoint of [f]. *)
  val memoize:
    hash:('i -> int) ->
    equal:('i -> 'i -> bool) ->
    int -> (('a, 'e, 'i) t -> ('a, 'e, 'i) t) -> ('a, 'e, 'i) t
end
