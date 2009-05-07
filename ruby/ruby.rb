#! /usr/bin/ruby

# Kember Identity finder in Ruby
# by Charlie Smurthwaite

require 'digest/md5'
i = 0
j = 0
while i <= 340282366920938463463374607431768211455
  i = i + 1
  j = j + 1
  plain = i.to_s(16).rjust(32,'0')
  digest = Digest::MD5.hexdigest(plain)
  break if plain == digest
  if j==10000
    puts plain + " " + digest
    j=0
  end
end

puts "We has a winner: #{plain}"
