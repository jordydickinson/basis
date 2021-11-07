(** A basic interface for monadic types. *)
module type Basic =
sig
  type 'a t

  val return: 'a -> 'a t

  val bind: ('a -> 'b t) -> 'a t -> 'b t

  val map: ('a -> 'b) -> 'a t -> 'b t
end

(** A basic interface for monadic types. *)
module type Basic2 =
sig
  type ('a, 'e) t

  val return: 'a -> ('a, 'e) t

  val bind: ('a -> ('b, 'e) t) -> ('a, 'e) t -> ('b, 'e) t

  val map: ('a -> 'b) -> ('a, 'e) t -> ('b, 'e) t
end

(** A basic interface for monadic types. *)
module type Basic3 =
sig
  type ('a, 'd, 'e) t

  val return: 'a -> ('a, 'd, 'e) t

  val bind: ('a -> ('b, 'd, 'e) t) -> ('a, 'd, 'e) t -> ('b, 'd, 'e) t

  val map: ('a -> 'b) -> ('a, 'd, 'e) t -> ('b, 'd, 'e) t
end

(** An interface for infix operators for monadic types. *)
module type Infix =
sig
  include Applicative.Infix

  val (>>=) : 'a t -> ('a -> 'b t) -> 'b t

  val (<?>) : 'a option t -> 'a option t -> 'a option t
end

(** An interface for infix operators for monadic types. *)
module type Infix2 =
sig
  include Applicative.Infix2

  val (>>=) : ('a, 'e) t -> ('a -> ('b, 'e) t) -> ('b, 'e) t

  val (<?>) : ('a option, 'e) t -> ('a option, 'e) t -> ('a option, 'e) t
end

(** An interface for infix operators for monadic types. *)
module type Infix3 =
sig
  include Applicative.Infix3

  val (>>=) : ('a, 'd, 'e) t -> ('a -> ('b, 'd, 'e) t) -> ('b, 'd, 'e) t

  val (<?>) : ('a option, 'd, 'e) t -> ('a option, 'd, 'e) t -> ('a option, 'd, 'e) t
end

(** An interface for [let] syntax for monadic types. *)
module type Syntax =
sig
  include Applicative.Syntax

  val (let*) : 'a t -> ('a -> 'b t) -> 'b t

  val (and*) : 'a t -> 'b t -> ('a * 'b) t
end

(** An interface for [let] syntax for monadic types. *)
module type Syntax2 =
sig
  include Applicative.Syntax2

  val (let*) : ('a, 'e) t -> ('a -> ('b, 'e) t) -> ('b, 'e) t
  
  val (and*) : ('a, 'e) t -> ('b, 'e) t -> ('a * 'b, 'e) t
end

(** An interface for [let] syntax for monadic types. *)
module type Syntax3 =
sig
  include Applicative.Syntax3

  val (let*) : ('a, 'd, 'e) t -> ('a -> ('b, 'd, 'e) t) -> ('b, 'd, 'e) t

  val (and*) : ('a, 'd, 'e) t -> ('b, 'd, 'e) t -> ('a * 'b, 'd, 'e) t
end

(** An interface for local opens for monadic types. *)
module type Open =
sig
  include Basic
  include Applicative.Open with type 'a t := 'a t

  val join: 'a t t -> 'a t

  val all_unit: unit t list -> unit t

  val orelse: 'a option t -> 'a option t -> 'a option t

  include Infix with type 'a t := 'a t
  include Syntax with type 'a t := 'a t
end

(** An interface for local opens for monadic types. *)
module type Open2 =
sig
  include Basic2
  include Applicative.Open2 with type ('a, 'e) t := ('a, 'e) t

  val join : (('a, 'e) t, 'e) t -> ('a, 'e) t

  val all_unit: (unit, 'e) t list -> (unit, 'e) t

  val orelse: ('a option, 'e) t -> ('a option, 'e) t -> ('a option, 'e) t

  include Infix2 with type ('a, 'e) t := ('a, 'e) t
  include Syntax2 with type ('a, 'e) t := ('a, 'e) t
end

(** An interface for local opens for monadic types. *)
module type Open3 =
sig
  include Basic3
  include Applicative.Open3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t

  val join: (('a, 'd, 'e) t, 'd, 'e) t -> ('a, 'd, 'e) t

  val all_unit: (unit, 'd, 'e) t list -> (unit, 'd, 'e) t

  val orelse: ('a option, 'd, 'e) t -> ('a option, 'd, 'e) t -> ('a option, 'd, 'e) t

  include Infix3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
  include Syntax3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
end

(** An interface for monadic types. *)
module type S =
sig
  include Open
  module Infix: Infix with type 'a t := 'a t
  module Syntax: Syntax with type 'a t := 'a t
  module O: Open with type 'a t := 'a t
end

(** An interface for monadic types. *)
module type S2 =
sig
  include Open2
  module Infix: Infix2 with type ('a, 'e) t := ('a, 'e) t
  module Syntax: Syntax2 with type ('a, 'e) t := ('a, 'e) t
  module O: Open2 with type ('a, 'e) t := ('a, 'e) t
end

(** An interface for monadic types. *)
module type S3 =
sig
  include Open3
  module Infix: Infix3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
  module Syntax: Syntax3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
  module O: Open3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
end