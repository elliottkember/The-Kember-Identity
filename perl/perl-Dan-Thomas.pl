#!/usr/bin/perl

use strict;
use warnings;
use Digest::MD5 qw(md5_hex);

my @character_map = (0..9, 'a'..'f');

while (1){

       # Generate a 32-character string using 0-9, a-f
       my @string;
       push @string, $character_map[ int(rand 16) ] for (0..31);
       my $string = join q{}, @string;

       # Check to see if it matches its MD5 hash
       if ($string eq md5_hex($string)){
               printf "Jesus wept, it actually found something! %s\n", $string;
               exit;
       }
}

