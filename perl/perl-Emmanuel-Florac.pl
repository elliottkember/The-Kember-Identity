#!/usr/bin/perl


use strict;
use warnings;
use Digest::MD5 qw( md5_hex);

for ( my $i=0; $i<340282366920938463463374607431768211455; $i++ ) {
       my $plain = sprintf "%032x", $i;
       my $digest =md5_hex($plain);

       #print "$i $plain $digest\n";

       if ( $plain eq $digest ) {
               print "Winner : $plain \n";
               last
       }

       if ( "$i" =~ m/.*00000$/ ) {
               print "$plain  $digest\n";
       }
}

