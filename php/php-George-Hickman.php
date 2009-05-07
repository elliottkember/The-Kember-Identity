<?php

  // A Kember Identity Hash script by George Hickman, improved upon by Alan Geleynse

  function random_gen($length) {
    $characters = '0123456789abcdef';
    $str = '';
    for($i=0;$i<$length;$i++) {
      $str .= substr($characters, (mt_rand() % (strlen($characters))), 1);
    }
    return $str;
  }
  $isReversible = false;
  $i = 0;
  while(!$isReversible) {
    $str = random_gen(32);
    $i++;
    if ($i == 100000) {
      echo $str;
      echo "\n";
      $i = 0;
    }
    $output = hash('md5', $str);
    if($output == $str) {
      $isReversible = true;
      echo 'Hurrah '.$str.' is a reversible md5 hash. Profit!';
    }
  }

?>