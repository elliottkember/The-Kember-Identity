require "luarocks.require"
require "md5"

i = 0
j = 0

sf = string.format
ms = md5.sumhexa

for i=0,340282366920938463463374607431768211455 do
       plain = sf("%032x",i)
       crypt = ms(plain)

       if( plain == crypt ) then
               print("Matched " .. plain .. " becomes " .. crypt)
               break
       end

       j = j + 1
       if( j == 1000000 ) then
               print("Progress (" .. i .. ") " .. plain)
               j = 0
       end
end
