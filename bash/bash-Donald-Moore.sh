#!/bin/bash
# author: donald ray moore jr (dmoore at peer1.com)
# date: 05/11/2009
# purpose: find the kember identity

FOUND=0

BIN=md5sum

#can haZ kemper id in sha1?!?
#BIN=sha1sum

hash() { 
	echo "${1}" | "${BIN}" | cut -d\  -f1
}

# create seed 
HASH=`hash $(date +"%s")`

while [ $FOUND -ne 1 ]; do
	# why make it complicated, there's no reason to think
	# that scanning sequentially is any better than hashing
	# the hash...
	HASHofHASH=`hash "${HASH}"`

	if [ "${HASH}" == "${HASHofHASH}" ]; then
		echo "found kember identify hash: ${HASH}";
		FOUND=1
	else
		HASH=${HASHofHASH}
	fi
done
