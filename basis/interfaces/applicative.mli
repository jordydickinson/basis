include module type of struct include Applicative_intf end

(** Implement the applicative interface. *)
module Make (T: Basic): S with type 'a t := 'a T.t

(** Implement the applicative interface. *)
module Make2 (T: Basic2): S2 with type ('a, 'e) t := ('a, 'e) T.t

(** Implement the applicative interface. *)
module Make3 (T: Basic3): S3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) T.t