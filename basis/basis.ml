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
module Option = Option
module Result = Result

(** {0 Extensions} *)

module Dyn_array = Dyn_array
module Fqueue = Fqueue
module Lazy_list = Lazy_list
module Or = Or
module Sexp = Sexp
module Storage = Storage

(** {0 Pervasives} *)

external phys_same : 'a -> 'b -> bool = "%eq"