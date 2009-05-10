#! /usr/bin/ruby

# Kember Identity finder in Ruby
# by Charlie Smurthwaite

require 'digest/md5'
require 'find_speed.rb'
i = 0
j = 0
hashes_before_output = 10000
speed = FindSpeed.new( hashes_before_output )
while i <= 340282366920938463463374607431768211455
  i = i + 1
  j = j + 1
  plain = i.to_s(16).rjust(32,'0')
  digest = Digest::MD5.hexdigest(plain)
  break if plain == digest
  if j==hashes_before_output
    puts plain + " " + digest + " @ #{speed.stop} hashes/s"
    speed.start
    j=0
  end
end

puts "We has a winner: #{plain}"
