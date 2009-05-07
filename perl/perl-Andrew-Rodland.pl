#!/usr/bin/perl
# Multithreaded Kember identity finder
# by Andrew Rodland, 2009.
# Permission is granted to use or distribute this code for any purpose
# without restriction.

use strict;
use threads;
use Digest::MD5 qw(md5_hex);

my $nthreads = shift || 1;

for my $tid (1 .. $nthreads) {
 async {
   print STDERR "Thread $tid running\n";
   while (1) {
     my $str;
     $str .= ('0' .. '9', 'a' .. 'f')[rand 16] for 1..32;
     return $str if $str eq md5_hex($str);
   }
 };
}

while (1) {
 if (my ($finished) = threads->list(threads::joinable)) {
   my $match = $finished->join;
   print "We have a winner: $match\n";
   $_->detach for threads->list;
   exit;
 }
 sleep 1;
}

