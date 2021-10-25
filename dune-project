(lang dune 2.8)
(generate_opam_files true)

(package
 (name basis)
 (synopsis "A small Stdlib overlay")
 (depends
  (ocaml (and (>= 4.12.0))))
 (license LGPLv3))