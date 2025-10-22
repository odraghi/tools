#!/bin/bash

DEVICE=$1
SECONDES=60

fio --name=70read30write --ioengine=libaio --direct=1 \
    --runtime=${SECONDES} --time_based --filename=${DEVICE} --size=10G \
    --rw=randrw --rwmixread=70 --rwmixwrite=30 --bs=4k --numjobs=1 \
    --iodepth=32 --group_reporting --output-format=json
