use Digest::MD5 qw(md5_hex);
while (1) {
       $a = join "", map { sprintf "%02x", int(rand(255)) } 1..16;
       print "Found one: $a\n" if $a eq md5_hex($a);
}

