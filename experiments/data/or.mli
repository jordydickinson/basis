(** [('a, 'b) t] is the "inclusive or" of ['a] and ['b]. It may contain an ['a],
    a ['b], or both an ['a] and a ['b]. For a disjoint version of this type,
    see {!type:Either.t}. *)
type (+'a, +'b) t =
| Left of 'a
| Right of 'b
| Both of 'a * 'b

(** [left a] is [Left a]. *)
val left: 'a -> ('a, _) t

(** [right b] is [Right b]. *)
val right: 'b -> (_, 'b) t

(** [both a b] is [Both (a, b)]. *)
val both: 'a -> 'b -> ('a, 'b) t

(** [set_left a x] is [Left a] if [x] is [Left _] and [Both (a, b)] if [x] is
    [Both (_, b)] or [Right b]. *)
val set_left: 'a -> ('b, 'r) t -> ('a, 'r) t

(** [set_right b x] is [Right b] if [x] is [Right _] and [Both (a, b)] if [x] is
    [Both (a, _)] or [Left a]. *)
val set_right: 'a -> ('l, 'b) t -> ('l, 'a) t

(** [map_left f x] is [x] with its left component set to [f a] if [x] is
    [Left a] or [Both (a, _)], and otherwise simply [x] unchanged. *)
val map_left: ('a -> 'b) -> ('a, 'r) t -> ('b, 'r) t

(** [map_right f x] is [x] with its right component set to [f b] if [x] is
    [Right b] or [Both (_, b)], and otherwise simply [x] unchanged. *)
val map_right: ('a -> 'b) -> ('l, 'a) t -> ('l, 'b) t