#!/usr/bin/perl

# This is not my best work.  I wanted something pretty to look at while it ran.
# -Paul

use strict;
use warnings;
use Digest::MD5 qw(md5_hex);

die "no mailer?" unless $ENV{KMAILER} and $ENV{KMAILER};
# eg: MAILER="mutt -xs holy-shit jettero@cpan.org"

sub gen_hash {
    my $new = join "", map { sprintf '%x', (0 .. 15)[rand 15] } 1 .. 32
}

my $col = 0;
my $highest = 0;

my %stats; my $total = 0;

$| = 1;

$SIG{INT} = sub { exit };
$SIG{HUP} = sub { exit };

END {
    print "\n";
    for my $h (sort { $stats{$b} <=> $stats{$a} } keys %stats) {
        my $v = $stats{$h};
        my $p = $v / $total;
        print "percent of highest same chars being $h: $p\n";
    }
}

while(1) {
    my $this = gen_hash();
    my $that = md5_hex($this);

    my $same = 0;
    for(0 .. 32) {
        $same++ if substr($this,$_,1) eq substr($that,$_,1);
    }

    $highest = $same if $same>$highest;

    if( $same == 32 ) {
        print "\n\n\e[1;32m They are the same: $this eq $that\e[m\n\n\n";
        exec "echo They are the same: $this eq $that | $ENV{KMAILER}";

    } else {
        $col ++;
        unless( $col % 100 ) {
            my $h_i = int($highest/2);
            my $h_c = sprintf('%1x', $h_i);

            my $h = $h_c;
            $h = "\e[1;30m$h_c\e[m" if $h_i <  3;
            $h = "\e[0;34m$h_c\e[m" if $h_i >= 3;
            $h = "\e[1;34m$h_c\e[m" if $h_i >= 5;
            $h = "\e[32m$h_c\e[m"   if $h_i >= 7;
            $h = "\e[1;32m$h_c\e[m" if $h_i >= 9;

            print $h;

            $stats{$highest}++;
            $total ++;
            $highest = 0;

            if( $col >= 10000 ) {
                print "\n";
                $col = 0;
            }
        }
    }
}
