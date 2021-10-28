(** Atomic values *)
type atom =
| Bool of bool
| Int of int
| Int32 of int32
| Int64 of int64
| Nativeint of nativeint
| Float of float
| String of string
| Symbol of string

(** Atomic values *)
module Atom : sig
  type t = atom

  include Pretty.S with type t := t
end

(** S-expressions *)
type t =
| Atom of atom
| List of t list

include Pretty.S with type t := t