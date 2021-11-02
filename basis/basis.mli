(** {0 Interfaces}

    Interfaces capture common patterns in {!module:Stdlib} and at times
    introduce new ones. They primarily come in the form of module signatures for
    easy inclusion, but sometimes also have functors for implementing the
    interface from some smaller set of functionality.
  *)

module Applicative = Applicative
module Comparable = Comparable
module Equatable = Equatable
module Hashable = Hashable
module Monad = Monad
module Pretty = Pretty
module Sexpable = Sexpable
module Storable = Storable
module Stringable = Stringable

(** {0 Overlays}

    Overlays are modules which extend those in {!module:Stdlib} which share
    their name. For example, these may implement the interfaces described
    previously, or add auxiliary helper functions.
  *)

module Int = Int
module Int32 = Int32
module Int64 = Int64
module Lazy = Lazy
module List = List
module Option = Option
module Result = Result

(** {0 Extensions}

    Extensions are new modules with new functionality not present in
    {!module:Stdlib}. For the most part, these are new datatypes.
  *)

module Dyn_array = Dyn_array
module Fqueue = Fqueue
module Lazy_list = Lazy_list
module Or = Or
module Sexp = Sexp
module Storage = Storage

(** {0 Pervasives}

    Miscellaneous utilities, either so useful that they are, by default,
    available as soon as Basis is opened, or simply that they defy
    categorization.
  *)

(** [phys_same] is like {!val:(==)} but it can compare terms of unequal type.
  This is mostly useful when optimizing code to avoid superfluous memory
  allocations, since it allows you to check equality without producing a type
  constraint. *)
val phys_same: 'a -> 'b -> bool