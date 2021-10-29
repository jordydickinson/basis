include Monad_intf

module Make (T: Basic) : S with type 'a t := 'a T.t =
struct
  include T

  include Applicative.Make (struct
    type nonrec 'a t = 'a t
    let return = return
    let map = map
    let apply f x = bind (Fun.flip map x) f
  end)

  module Infix =
  struct
    include Infix
    let (>>=) x f = bind f x
    let (>>|) x f = map f x
  end
  include Infix

  module Syntax =
  struct
    include Syntax
    let (let*) = (>>=)
    let (and*) = (and+)
  end
  include Syntax

  module O =
  struct
    include O
    include T
    include Infix
    include Syntax

    let join m = bind (fun x -> x) m

    let rec all_unit = function
    | [] -> return ()
    | x :: xs -> x >>= fun () -> all_unit xs
  end
  include O
end

module Make2 (T: Basic2) : S2 with type ('a, 'e) t := ('a, 'e) T.t =
struct
  include T

  include Applicative.Make2 (struct
    type nonrec ('a, 'e) t = ('a, 'e) t
    let return = return
    let map = map
    let apply f x = bind (Fun.flip map x) f
  end)

  module Infix =
  struct
    include Infix
    let (>>=) x f = bind f x
    let (>>|) x f = map f x
  end
  include Infix

  module Syntax =
  struct
    include Syntax
    let (let*) = (>>=)
    let (and*) = (and+)
  end
  include Syntax

  module O =
  struct
    include O
    include T
    include Infix
    include Syntax

    let join m = bind (fun x -> x) m

    let rec all_unit = function
    | [] -> return ()
    | x :: xs -> x >>= fun () -> all_unit xs
  end
  include O
end

module Make3 (T: Basic3) : S3 with type ('a, 'd, 'e) t := ('a, 'd, 'e) T.t =
struct
  include T

  include Applicative.Make3 (struct
    type nonrec ('a, 'd, 'e) t = ('a, 'd, 'e) t
    let return = return
    let map = map
    let apply f x = bind (Fun.flip map x) f
  end)

  module Infix =
  struct
    include Infix
    let (>>=) x f = bind f x
    let (>>|) x f = map f x
  end
  include Infix

  module Syntax =
  struct
    include Syntax
    let (let*) = (>>=)
    let (and*) = (and+)
  end
  include Syntax

  module O =
  struct
    include O
    include T
    include Infix
    include Syntax

    let join m = bind (fun x -> x) m

    let rec all_unit = function
    | [] -> return ()
    | x :: xs -> x >>= fun () -> all_unit xs
  end
  include O
end