// An F# script that seeks the Kember Identity
// Written by Rob Kellett, 2013

open System
open System.Security.Cryptography

let md5 = MD5.Create()
let rand = new Random()

let rec kemberIdentity (hash1: byte[]) =
    let hash2 = md5.ComputeHash hash1
    if hash1 = hash2 then 
        printfn "The Kember Identity is: %s" (hash1 |> Seq.map(fun b -> b.ToString("x2")) |> Seq.reduce(+))
    else
        kemberIdentity hash2

let buf = Array.init 16 (fun _ -> 0uy);
rand.NextBytes buf

kemberIdentity buf // kick things off with a random hash

printfn "Press any key to exit."
Console.ReadKey() |> ignore