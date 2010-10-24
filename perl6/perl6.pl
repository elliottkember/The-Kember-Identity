#!/usr/bin/env perl6
# http://www.elliottkember.com/kember_identity.html
# Kudos to tadzik++ and masak++ on #perl6 for suggestions!

use v6;
use Digest::MD5; # part of Rakudo 2010-10 release; also available as "neutro perl6-digest-md5"

my Int $count = 0;
my Str @alphabet = (0..9, 'a'..'f');
my Str $string = @alphabet.roll(32).join;

loop {
    my Str $md5 = Digest::MD5.md5_hex($string);

    if $md5 eq $string {
        say "We have a winner after testing $count strings!";
        say "md5($string) = $md5";
        exit;
    }

    if ++$count %% 100 {
        say "$count: md5($string) = $md5";
    }

    $string = $md5;
}
