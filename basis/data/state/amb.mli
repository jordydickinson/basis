type (+'a, !'s) t = 's -> ('a * 's) Seq.t

include Amb_intf.S with type ('a, 's) t := ('a, 's) t