require 'digest/md5'
while
 plain = rand(10**38).to_s(16).rjust(32,'0')
 break if plain == Digest::MD5.hexdigest(plain)
end
puts "You just won/lost! #{plain}"

