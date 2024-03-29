(** {0 Interfaces} *)

module Applicative = Applicative
module Comparable = Comparable
module Equatable = Equatable
module Hashable = Hashable
module Monad = Monad
module Pretty = Pretty
module Stringable = Stringable

(** {0 Overlays} *)

module Array = Array
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

module Amb = Amb
module Fqueue = Fqueue
module Lazy_list = Lazy_list
module State = State
module Void = Void

(** {0 Pervasives} *)

module Pervasives = Pervasives
include Pervasives