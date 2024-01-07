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

type void = Void.t

let unreachable = Void.unreachable

external phys_same : 'a -> 'b -> bool = "%eq"

let hash_combine =
  let c =
    if Sys.int_size <= 32
    then 0x9e3779b9
    else 0x517cc1b727220a95
  in
  fun h1 h2 ->
    h1 lxor (h2 + c + (h1 lsl 6) + (h1 lsr 2))