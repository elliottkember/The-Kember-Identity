let winner str =
  str = Digest.to_hex (Digest.string str);;

let generate () = 
  let a = Random.int max_int in
  let b = Random.int max_int in
  let c = Random.int max_int in
  let d = Random.int max_int in
    Printf.sprintf "%.8x%.8x%.8x%.8x" a b d c;;

let success str =
  Printf.printf "Success! '%s' hashes to itself!\n" str;;

while true do
  let candidate = generate () in
    if winner candidate then success candidate
done
