#!/bin/bash

## Usage
#
#  Test 60s without limiting iops
#    bench-storage.sh - 60
#
#  Test 60s with 150 iops maximum
#    bench-storage.sh 150 60

### Args
MAXIOPS=$1
DURATION=$2

### Config
NUMJOBS=10

#DEVICE_OPTIONS="--filename=/dev/sdb"
DEVICE_OPTIONS="--filename=temp.file --filesize=2g"


ENGINE_OPTIONS="--ioengine=libaio --fsync=10"
#ENGINE_OPTIONS="--ioengine=libaio --fsync=1000"
#ENGINE_OPTIONS="--ioengine=sg"


DEFAUT_DURATION=60
## isNumber
[ ! -z "${DURATION##*[!0-9]*}" ] || DURATION=60
echo "Duration ${DURATION}"


COMMON_OPTIONS=" --blocksize=32k ${DEVICE_OPTIONS} ${ENGINE_OPTIONS} --time_based --runtime=${DURATION} --iodepth=256 --direct=1 --group_reporting --eta-newline=10s --dedupe_percentage=0 --buffer_compress_percentage=0 --numjobs=${NUMJOBS}"


## Functions
make_maxiops_opt()
{
   READ_PERCENT=$1
   MAXIOPS_OPTIONS=""
   ## isNumber
   if [ ! -z "${MAXIOPS##*[!0-9]*}" ] ; then
      if [ ! -z "${READ_PERCENT}" ] ; then
         [ $MAXIOPS -gt $NUMJOBS ] && (( JOB_RATE=MAXIOPS/NUMJOBS )) || JOB_RATE=$MAXIOPS
         (( WRITE_RATE=JOB_RATE*(100-READ_PERCENT)/100 ))
         (( READ_RATE=JOB_RATE*READ_PERCENT/100 ))
          RATELIMIT="${READ_RATE},${WRITE_RATE}"
      else
         [ $MAXIOPS -gt $NUMJOBS ] && (( RATELIMIT=MAXIOPS/NUMJOBS ))
      fi
      MAXIOPS_OPTIONS="--rate_iops=${RATELIMIT}"
      echo "Limit IOPS rate to ${MAXIOPS}"
   fi
}

launch_fio()
{
   FIO_ARGS=$*
   echo "Starting command..."
   echo "#  fio ${FIO_ARGS}"
   echo
   fio ${FIO_ARGS}
}


sequential_read()
{
make_maxiops_opt
launch_fio --name SEQUENTIAL_READ_100  --rw=read  ${COMMON_OPTIONS} ${MAXIOPS_OPTIONS}
}

sequential_write()
{
make_maxiops_opt
launch_fio --name SEQUENTIAL_WRITE_100  --rw=write ${COMMON_OPTIONS} ${MAXIOPS_OPTIONS}
}

random_read()
{
make_maxiops_opt
launch_fio --name RANDOM_READ_100 --rw=randread ${COMMON_OPTIONS} ${MAXIOPS_OPTIONS}
}

random_write()
{
make_maxiops_opt
launch_fio --name RANDOM_WRITE_100 --rw=randwrite ${COMMON_OPTIONS} ${MAXIOPS_OPTIONS}
}

random_80_20()
{
make_maxiops_opt 80
launch_fio --name RANDOM_80_20 --rw=randrw --rwmixread=80 ${COMMON_OPTIONS} ${MAXIOPS_OPTIONS}
}

random_70_30()
{
make_maxiops_opt 70
launch_fio --name RANDOM_70_30 --rw=randrw --rwmixread=70 ${COMMON_OPTIONS} ${MAXIOPS_OPTIONS}
}

ioping_10()
{
ioping -c 10 -D -S 64m .
}



## Main
cat << EOF
Select a workload:
1. sequential_read
2. sequential_write
3. random_read
4. random_write
5. random_80_20
6. random_70_30 (*** Default test)
7. ioping_10

EOF

echo -e "\tChoix (6): \c"
read workload
[ "x${workload}" = "x" ] && workload=6

case $workload in
   1) sequential_read ;;
   2) sequential_write ;;
   3) random_read ;;
   4) random_write ;;
   5) random_80_20 ;;
   6) random_70_30 ;;
   7) ioping_10 ;;
   *) echo "Choix invalide"
esac
