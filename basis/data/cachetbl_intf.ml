module type S = sig
  (** A mixture of a hash table and a weak hash table. Upon creation, it behaves
      like a weak hash table. The table's [cache_capacity] determines how many
      keys in the table are strong references. When bindings are [add]ed or
      [replace]d, or when a key is [cache]d, the key is promoted to a strong
      reference, increasing the table's [cache_size]. When this [cache_size]
      exceeds the table's [cache_capacity], the oldest cached key is demoted to
      a weak reference.

      The same caveats as apply to {!modtype:Ephemeron.S} regarding modification
      of the table during calls to {!val:iter} apply to this table.  
    *)

  include Ephemeron.S

  (** [cache_size tbl] gives the number of keys [tbl] contains strong
      references to. *)
  val cache_size: 'a t -> int

  (** [cache_capacity tbl] is the number of keys [tbl] will keep as strong
      references before demoting the oldest such reference to a weak
      reference. *)
  val cache_capacity: 'a t -> int

  (** [set_cache_capacity tbl cap] sets the {!val:cache_capacity} of [tbl] to
      [cap].

      If [cap] is [0], [tbl] will behave like a weak hash table. If set to
      [Int.max_int], it will behave like a hash table, except that keys may be
      marked as weak with [uncache].
      
      @raise Invalid_arg if [cap] is negative
    *)
  val set_cache_capacity: 'a t -> int -> unit

  (** [cached tbl k] indicates whether [k] is considered cached in [tbl]; i.e.,
      whether it is a strong reference. *)
  val cached: 'a t -> key -> bool

  (** [uncache tbl k] removes [k] from the set of cached keys in [tbl]. After
      this call, [k] is treated like a weak key. *)
  val uncache: 'a t -> key -> unit

  (** [cache tbl k] adds [k] to the set of cached keys in [tbl], promoting it
      from a weak to a strong reference. If [k] is not already in [tbl], this
      function does nothing and no strong reference is made. *)
  val cache: 'a t -> key -> unit

  (** [stats_cached] is like {!val:stats} but it gives the statistics for cached
      keys only. *)
  val stats_cached: 'a t -> Hashtbl.statistics
end