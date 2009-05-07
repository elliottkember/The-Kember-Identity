#!/usr/bin/perl -w
use strict; #because we care.
# I like random; it seems sporting.

use Digest::MD5 qw (md5_hex);
use String::Random qw (random_string);
my ($this, $that);
my $pattern = "00000000000000000000000000000000";

sub what_we_do {
 $this = random_string($pattern, ['a'..'f', 0..9]);
 $that = md5_hex($this);
}

do { what_we_do() } until $this eq $that;

print $this, "\n";

