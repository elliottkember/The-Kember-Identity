#!/usr/bin/perl
use strict;
use Digest::MD5 'md5_hex';
use Data::Random 'rand_chars';

while(1) {
   my $string = join('', rand_chars(set => 'alphanumeric', size => 32));
   if( $string eq md5_hex($string) ) {
       print "Found it! $string\n";
       last;
   }
}
