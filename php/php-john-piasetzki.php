#!/usr/bin/php
<?php
do {
    $str = '';
    for($j = 0; $j < 8; $j++)
        $str .= sprintf('%04x',mt_rand(0, 65535));
} while(hash('md5', $str) != $str);
echo 'Hurrah '.$str.' is a reversible md5 hash. Profit!'."\n";
?>
