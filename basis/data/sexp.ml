type atom =
| Bool of bool
| Int of int
| Int32 of int32
| Int64 of int64
| Nativeint of nativeint
| Float of float
| String of string
| Symbol of string

module Atom = struct
  type t = atom

  let escape_symbol s = String.split_on_char '|' s |> String.concat "\\|"

  let pp ppf = function
  | Bool true -> Format.pp_print_string ppf "#t"
  | Bool false -> Format.pp_print_string ppf "#f"
  | Int i -> Format.pp_print_int ppf i
  | Int32 i -> Format.pp_print_string ppf (Int32.to_string i)
  | Int64 i -> Format.pp_print_string ppf (Int64.to_string i)
  | Nativeint i -> Format.pp_print_string ppf (Nativeint.to_string i)
  | Float f -> Format.pp_print_float ppf f
  | String s -> Format.fprintf ppf "\"%s\"" (String.escaped s)
    (* TODO: We can be smarter about how much quoting is necessary here. *)
  | Symbol s -> Format.fprintf ppf "|%s|" (escape_symbol s)
end

type t =
| Atom of atom
| List of t list

let rec pp ppf = function
| Atom a -> Atom.pp ppf a
| List xs -> Format.fprintf ppf "(@[%a@])"
    (Format.pp_print_list ~pp_sep:Format.pp_print_space pp) xs