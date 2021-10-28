(** An interface for types which can be converted to strings. *)
module type S = sig
  type t

  (** [to_string x] is a string representation of [x]. *)
  val to_string : t -> string
end