include Applicative_intf

module Make (T: Basic) =
struct
  module O =
  struct
    include T

    module Infix =
    struct
      let (<*>) = apply
      let (<$>) = map
      let (>>|) x f = map f x
      let (<&>) x y = map (fun x y -> x, y) x <*> y
    end
    include Infix

    module Syntax =
    struct
      let (let+) = (>>|)

      let (and+) = (<&>)
    end
    include Syntax

    let rec all = function
    | [] -> return []
    | x :: xs ->
      let+ x = x and+ xs = all xs in
      x :: xs
  end
  include O
end

module Make2 (T: Basic2) =
struct
  module O =
  struct
    include T

    module Infix =
    struct
      let (<*>) = apply
      let (<$>) = map
      let (>>|) x f = map f x
      let (<&>) x y = map (fun x y -> x, y) x <*> y
    end
    include Infix

    module Syntax =
    struct
      let (let+) = (>>|)

      let (and+) = (<&>)
    end
    include Syntax

    let rec all = function
    | [] -> return []
    | x :: xs ->
      let+ x = x and+ xs = all xs in
      x :: xs
  end
  include O
end

module Make3 (T: Basic3) =
struct
  module O =
  struct
    include T

    module Infix =
    struct
      let (<*>) = apply
      let (<$>) = map
      let (>>|) x f = map f x
      let (<&>) x y = map (fun x y -> x, y) x <*> y
    end
    include Infix

    module Syntax =
    struct
      let (let+) = (>>|)

      let (and+) = (<&>)
    end
    include Syntax

    let rec all = function
    | [] -> return []
    | x :: xs ->
      let+ x = x and+ xs = all xs in
      x :: xs
  end
  include O
end