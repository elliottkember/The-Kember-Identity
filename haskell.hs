import Random
import Data.Digest.OpenSSL.MD5
import qualified Data.ByteString.Char8 as B

alphabet = ['a'..'f'] ++ ['0'..'9']

main = do g <- getStdGen
          let offs = randomRs (0, length alphabet - 1) g
          let cs = map (alphabet !!) offs
          putStrLn $ B.unpack $ trysome cs

trysome :: [Char] -> B.ByteString
trysome cs = if (md5sum bs) == B.unpack bs then bs else trysome cs'
        where (s,cs') = splitAt (md5_digest_length * 2) cs
              bs = foldr B.cons B.empty s
