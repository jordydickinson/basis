module type S = sig
  type key

  (** A prefix in the map *)
  type path = key list

  (** ['a t] is an associative map from [key]s prefixed by [path]s to ['a]. *)
  type +'a t

  (** [empty] is the empty map with no bindings. *)
  val empty: 'a t

  (** [is_empty xs] is [true] if [xs] is empty and [false] otherwise. *)
  val is_empty: 'a t -> bool

  (** [qualify path xs] is a map containing all the bindings of [xs] qualified
      by the prefix [path], in addition to whatever prefix they already had.
      O(n) in the length of [path]. *)
  val qualify: path -> 'a t -> 'a t

  (** [singleton k v] is a map containing the single binding of [k] to [v], with
      no prefix. *)
  val singleton: key -> 'a -> 'a t

  (** [switch path xs] is a map containing all the bindings of [xs] which have
      the prefix [path] with this prefix removed. *)
  val switch: path -> 'a t -> 'a t

  (** [under path f xs] is a map with all the bindings of [xs], except that
      those under the prefix [path] are replaced with the result of
      [f @@ switch path xs]. *)
  val under: path -> ('a t -> 'a t) -> 'a t -> 'a t

  (** [remove k xs] is a map with all the bindings of [xs], except any binding
      to [k]. If there is no binding to [k], [xs] is returned unchanged. *)
  val remove: key -> 'a t -> 'a t

  (** [add k v xs] is a map with all the bindings of [xs] and additionally the
      binding of [v] to [x]. If [k] was already bound, its old binding is
      replaced. *)
  val add: key -> 'a -> 'a t -> 'a t

  (** [update k f xs] is a map with all the bindings of [xs], except that the
      binding to [k] is updated according to the result of applying [f] to its
      entry. In particular if [v: 'a option] is the value associated with [k],
      if [f v] is [None] then any previous binding is removed. If [f v] is
      [Some v'], then the old binding, if any, is replaced with [v']. *)
  val update: key -> ('a option -> 'a option) -> 'a t -> 'a t

  (** [filter_map] is a combination of {!val:filter} and {!val:map}. *)
  val filter_map: (path -> key -> 'a -> 'b option) -> 'a t -> 'b t

  (** [filter f xs] is a map containing exactly those bindings of [xs] which
      satisfy [f]. *)
  val filter: (path -> key -> 'a -> bool) -> 'a t -> 'a t

  (** [merge f xs ys] is a map whose bindings are determined by applying [f] to
      the bindings of [xs] and [ys]. Note that if there is no binding for some
      key [k] with prefix [ks], but there are bindings with that prefix, the
      binding to that key/prefix is determined by [f None None]. However, if no
      key has the prefix [ks] in either [xs] or [ys], [f] will not be called. *)
  val merge: (path -> key -> 'a option -> 'b option -> 'c option) -> 'a t -> 'b t -> 'c t

  (** [union f xs ys] is equivalent to [merge f' xs ys] where [f'] is given by

      {[let f' = function
        | None, None -> None
        | x, None | None, x -> x
        | Some x, Some y -> f x y
      ]}
   *)
  val union: (path -> key -> 'a -> 'a -> 'a option) -> 'a t -> 'a t -> 'a t

  (** [equal equal_elt xs ys] is [true] if [xs] and [ys] both contain the same
      keys, prefixed by the same paths, and bound to the same values, as
      determined by [equal_elt], and [false] otherwise. *)
  val equal: ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

  (** [iter f xs] applies [f] to each element of [xs], in unspecified order. *)
  val iter: (path -> key -> 'a -> unit) -> 'a t -> unit

  (** [fold f xs acc] threads [acc] through nested applications of [f] to the
      bindings of [xs] in unspecified order. *)
  val fold: (path -> key -> 'a -> 'acc -> 'acc) -> 'a t -> 'acc -> 'acc

  (** [for_all f xs] is [true] if [f] is [true] for every binding of [xs] and
      [false] otherwise. *)
  val for_all: (path -> key -> 'a -> bool) -> 'a t -> bool

  (** [exists f xs] is [true] if [f] is [true] for any binding of [xs] and
      [false] otherwise. *)
  val exists: (path -> key -> 'a -> bool) -> 'a t -> bool

  (** [partition f xs] is a pair [ys, zs] where [ys] is comprised of the
      bindings of [xs] such that [f] is [true], and [zs] is comprised of those
      such that [f] is [false]. *)
  val partition: (path -> key -> 'a -> bool) -> 'a t -> 'a t * 'a t

  (** [cardinal xs] is the number of bindings in [xs]. *)
  val cardinal: 'a t -> int

  (** [map f xs] is a map containing all the bindings of [xs], but updating
      their associated values by applying [f]. *)
  val map: ('a -> 'b) -> 'a t -> 'b t 
end