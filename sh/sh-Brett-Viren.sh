#!/bin/sh
foo=foo
while true; do
   bar=$(echo $foo|md5sum | sed -e 's/-//')
   echo "$foo =?= $bar ?"
   if [ "$foo" = "$bar" ] ; then
       echo 'Yes!'
       break
   fi
   foo=$bar
done

