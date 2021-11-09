(** {0 Interfaces} *)

module Applicative = Applicative
module Comparable = Comparable
module Equatable = Equatable
module Hashable = Hashable
module Monad = Monad
module Pretty = Pretty
module Sexpable = Sexpable
module Storable = Storable
module Stringable = Stringable

(** {0 Overlays} *)

module Int = Int
module Int32 = Int32
module Int64 = Int64
module Lazy = Lazy
module List = List
module Map = Map
module Option = Option
module Result = Result
module Seq = Seq
module String = String

(** {0 Extensions} *)

module Amb_state = Amb_state
module Cps_state = Cps_state
module Dyn_array = Dyn_array
module Fqueue = Fqueue
module Lazy_list = Lazy_list
module Or = Or
module Prefix_map = Prefix_map
module Sexp = Sexp
module Storage = Storage
module Void = Void

(** {0 Pervasives} *)

type void = Void.t

let unreachable = Void.unreachable

external phys_same : 'a -> 'b -> bool = "%eq"