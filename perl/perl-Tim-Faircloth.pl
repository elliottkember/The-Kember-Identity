#!/usr/bin/perl
# http://www.elliottkember.com/kember_identity.html
use Digest::MD5 "md5_hex";
sub gen_string {
   my $length = shift;
   my $characters = '01234567890abcdef';
   my $string = '';
   for($i=0; $i<$length; $i++){
       $string .= substr($characters, rand(length $characters), 1);
   }
   return $string;
}
$winner = 0;
$tested = 0;
while($winner == 0) {
   $string = gen_string(32);
   $md5 = md5_hex($string);
   if($string eq $md5) {
       $winner = 1;
       print "We have a winner after testing $tested strings!\n";
       print "$string -> $md5\n";
   }
   $tested += 1;
   if(($tested % 10000) == 0) {
       $thousands = $tested / 10000;
       print "$thousands: $string -> $md5\n";
   }
}
