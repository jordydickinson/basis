type (+'a, +'b) t =
| Left of 'a
| Right of 'b
| Both of 'a * 'b

let left a = Left a

let right b = Right b

let both a b = Both (a, b)

let set_left a = function
| Left _ -> Left a
| Right b -> Both (a, b)
| Both (_, b) -> Both (a, b)

let set_right b = function
| Left a -> Both (a, b)
| Right _ -> Right b
| Both (a, _) -> Both (a, b)

let map_left f = function
| Left a -> Left (f a)
| Right _ as x -> x
| Both (a, b) -> Both (f a, b)

let map_right f = function
| Left _ as x -> x
| Right b -> Right (f b)
| Both (a, b) -> Both (a, f b)