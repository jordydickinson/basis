(** The type of pretty-printers *)
type 'a t = Format.formatter -> 'a -> unit

(** An interface for types which can be pretty-printed. *)
module type S = sig
  type 'a pp := 'a t
  type t

  (** [pp fmt x] pretty-prints [x] to the formatter [fmt]. *)
  val pp : t pp
end