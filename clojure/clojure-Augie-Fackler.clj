(import '(java.security MessageDigest))

(def digest (. MessageDigest (getInstance "MD5")))

(defn md5 [s]
 (.reset digest)
 (.update digest (.getBytes s))
 (let [ha (.digest digest)
       sb (new StringBuilder)]
   (dorun (map
           (fn build [b] (.append sb (Integer/toHexString (bit-and b 0xff))))
           ha))
   (.toString sb )))

(defn randstr []
 (let [digits "01234567890abcdef" sb (new StringBuffer)]
   (loop [left 32
          chars (list )
          ]
     (if (= left 0) chars
         (recur (- left 1)
                (.append sb (.charAt digits (rand-int (.length digits)))))))
   (.toString sb)))

(loop [iterations 0]
 (let [s (randstr)]
;;    (if (= (mod iterations 100000) 0) (println iterations))
   (if (= s (md5 s)) (printf "%s hashes to itself.\n" s)
       (recur (+ iterations 1)))))

