<?php 
$found = 0;
$i = 0;
while(!$found)
{
       $str = md5(microtime());
       if(!($i % 1000000))
               echo "$str\n";

       if(md5($str) == $str)
       {
               $found = 1;
               echo "Yay! $str is the Kember Identity Hash!\n";
       }
       $i++;
}
?>
