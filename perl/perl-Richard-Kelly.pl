use Digest::MD5 qw( md5_hex );
use bigint;

for ($i=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; $i >= 0; $i = $i - 1)  {
    $cur_hex=Math::BigInt->new($i)->as_hex();
    $md5_hex=Math::BigInt->new(hex(md5_hex( $i )))->as_hex();
    unless ($cur_hex cmp $md5_hex) {
        print "Found one! " , "$cur_hex", " hashes to ", "$md5_hex\n"; 
        }
    }

