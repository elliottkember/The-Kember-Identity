#!/bin/bash
GPU=`../cuda_md5 --deviceQuery | grep "Device 0" | awk -F\" '{print $2}'`
HOST=`hostname`
GPUUSCORE=`echo -n "$GPU" | sed 's/ /_/g'`

echo $GPUUSCORE	$HOST	$GPU
