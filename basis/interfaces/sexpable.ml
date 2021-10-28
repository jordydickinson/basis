(** An interface for types which can be converted to S-expressions. *)
module type S = sig
  type t

  (** [to_sexp x] is an S-expression representation of [x]. *)
  val to_sexp: t -> Sexp.t
end