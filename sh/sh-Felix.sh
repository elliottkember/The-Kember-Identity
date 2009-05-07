#! /bin/sh

b=( 'a' 'b' 'c' 'd' 'e' 'f' '0' '1' '2' '3' '4' '5' '6' '7' '8' '9' )

while [ true ]; do
    str=''
    for (( c=0; c < 32; c++ )) do 
        number=$RANDOM
        let "number >>= 11"
        str=$str${b[$number]}
    done

    # If md5sum isn't available, try 'openssl md5 -' instead
    md5=`echo -n $str | md5sum -`
    md5=${md5:0:32}
    if [ "$str" == "$md5" ]; then
        echo 'We have a winner: '$str
        break
    fi
done

