(** A basic interface for applicative types. *)
module type Basic =
sig
  type 'a t

  val return: 'a -> 'a t

  val apply: ('a -> 'b) t -> 'a t -> 'b t
  
  val map: ('a -> 'b) -> 'a t -> 'b t
end

(** A basic interface for applicative types. *)
module type Basic2 =
sig
  type ('a, 'e) t

  val return: 'a -> ('a, 'e) t

  val apply: ('a -> 'b, 'e) t -> ('a, 'e) t -> ('b, 'e) t

  val map: ('a -> 'b) -> ('a, 'e) t -> ('b, 'e) t
end

(** A basic interface for applicative types. *)
module type Basic3 =
sig
  type ('a, 'd, 'e) t

  val return: 'a -> ('a, 'e, 'i) t

  val apply: ('a -> 'b, 'd, 'e) t -> ('a, 'd, 'e) t -> ('b, 'd, 'e) t

  val map: ('a -> 'b) -> ('a, 'd, 'e) t -> ('b, 'd, 'e) t
end

(** An interface for infix operations for applicative types. *)
module type Infix =
sig
  type 'a t

  val (<$>) : ('a -> 'b) -> 'a t -> 'b t

  val (<*>) : ('a -> 'b) t -> 'a t -> 'b t

  val (>>|) : 'a t -> ('a -> 'b) -> 'b t

  val (<&>) : 'a t -> 'b t -> ('a * 'b) t
end

(** An interface for infix operations for applicative types. *)
module type Infix2 =
sig
  type ('a, 'b) t

  val (<$>) : ('a -> 'b) -> ('a, 'e) t -> ('b, 'e) t

  val (<*>) : ('a -> 'b, 'e) t -> ('a, 'e) t -> ('b, 'e) t 

  val (>>|) : ('a, 'e) t -> ('a -> 'b) -> ('b, 'e) t

  val (<&>) : ('a, 'e) t -> ('b, 'e) t -> ('a * 'b, 'e) t
end

(** An interface for infix operations for applicative types. *)
module type Infix3 =
sig
  type ('a, 'd, 'e) t

  val (<$>) : ('a -> 'b) -> ('a, 'd, 'e) t -> ('b, 'd, 'e) t

  val (<*>) : ('a -> 'b, 'd, 'e) t -> ('a, 'd, 'e) t -> ('b, 'd, 'e) t

  val (>>|) : ('a, 'd, 'e) t -> ('a -> 'b) -> ('b, 'd, 'e) t

  val (<&>) : ('a, 'd, 'e) t -> ('b, 'd, 'e) t -> ('a * 'b, 'd, 'e) t
end

(** An interface for [let] syntax for applicative types. *)
module type Syntax =
sig
  type 'a t

  val (let+) : 'a t -> ('a -> 'b) -> 'b t

  val (and+) : 'a t -> 'b t -> ('a * 'b) t
end

(** An interface for [let] syntax for applicative types. *)
module type Syntax2 =
sig
  type ('a, 'e) t

  val (let+) : ('a, 'e) t -> ('a -> 'b) -> ('b, 'e) t

  val (and+) : ('a, 'e) t -> ('b, 'e) t -> ('a * 'b, 'e) t
end

(** An interface for [let] syntax for applicative types. *)
module type Syntax3 =
sig
  type ('a, 'd, 'e) t

  val (let+) : ('a, 'd, 'e) t -> ('a -> 'b) -> ('b, 'd, 'e) t

  val (and+) : ('a, 'd, 'e) t -> ('b, 'd, 'e) t -> ('a * 'b, 'd, 'e) t
end

(** An interface for local opens for applicative types. *)
module type Open =
sig
  include Basic

  val all: 'a t list -> 'a list t
  
  include Infix with type 'a t := 'a t
  include Syntax with type 'a t := 'a t
end

(** An interface for local opens for applicative types. *)
module type Open2 =
sig
  include Basic2

  val all: ('a, 'e) t list -> ('a list, 'e) t

  include Infix2 with type ('a, 'e) t := ('a, 'e) t
  include Syntax2 with type ('a, 'e) t := ('a, 'e) t
end

(** An interface for local opens for applicative types. *)
module type Open3 =
sig
  include Basic3

  val all: ('a, 'd, 'e) t list -> ('a list, 'd, 'e) t

  include Infix3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
  include Syntax3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
end

(** An interface for applicative types. *)
module type S =
sig
  include Open

  module Infix : Infix with type 'a t := 'a t
  module Syntax : Syntax with type 'a t := 'a t
  module O : Open with type 'a t := 'a t
end

(** An interface for applicative types. *)
module type S2 =
sig
  include Open2

  module Infix : Infix2 with type ('a, 'e) t := ('a, 'e) t
  module Syntax : Syntax2 with type ('a, 'e) t := ('a, 'e) t
  module O : Open2 with type ('a, 'e) t := ('a, 'e) t
end

(** An interface for applicative types. *)
module type S3 =
sig
  include Open3

  module Infix : Infix3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
  module Syntax : Syntax3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
  module O : Open3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) t
end
