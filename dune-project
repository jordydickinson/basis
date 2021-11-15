(lang dune 2.8)
(name basis)
(version 0.1.0)
(generate_opam_files true)

(package
 (name basis)
 (synopsis "A small Stdlib overlay")
 (depends
  (ocaml (and (>= 4.12.0))))
 (license LGPL-3.0)
 (maintainers "Jordy Dickinson <jordy.dickinson@icloud.com>")
 (authors "Jordy Dickinson <jordy.dickinson@icloud.com>")
 (homepage https://github.com/jordydickinson/basis)
 (bug_reports https://github.com/jordydickinson/basis/issues))

(package
 (name basis_experiments)
 (synopsis "A small Stdlib overlay")
 (depends
  (ocaml (and (>= 4.12.0))))
 (license LGPL-3.0)
 (maintainers "Jordy Dickinson <jordy.dickinson@icloud.com>")
 (authors "Jordy Dickinson <jordy.dickinson@icloud.com>")
 (homepage https://github.com/jordydickinson/basis)
 (bug_reports https://github.com/jordydickinson/basis/issues))