#!/bin/bash

set -x

public_ip=`curl ipaddr.io`
hostname=` uname -n`
log_dir='/tmp'
# localIP=`for i in `ip addr show | grep BROADCAST | grep -v docker | grep 'BROADCAST,MULTICAST,UP,LOWER_UP' | awk -F \: '{print $2}'` ; do ip addr show $i ; done`
work_dir='/usr/local/iganari'

sleep 30

local_ip_chk()
{
  for i in `ip addr show | grep BROADCAST | grep -v docker | grep 'BROADCAST,MULTICAST,UP,LOWER_UP' | awk -F \: '{print $2}'`
    do
      ip addr show ${i}
    done
}
local_ip=`local_ip_chk`


if [ "${1}" == 'wakeup' ]; then

### create wakeup template
cat << __EOF__ > ${log_dir}/comment-wakeup.log
Hello !!
I woke up NOW !!

My Hostname is ${hostname}
My PublicIP is ${public_ip}


and localIP is 

==============================================================
${local_ip}
==============================================================

Thanks!
__EOF__

chmod 777 ${log_dir}/comment-wakeup.log

### send message using notify-me
cat ${log_dir}/comment-wakeup.log | sh ${work_dir}/notify-server/bin/notify-me.sh
exit 0



elif [ "${1}" == 'sleep' ]; then
cat << __EOF__ > ${log_dir}/comment-sleep.log
Hi !!
I am going to sleep now ..

My Hostname is ${hostname}
My PublicIP is ${public_ip}

Good night ... zz
__EOF__

# ${log_dir}/comment-sleep.log

### send message using notify-me
cat ${log_dir}/comment-sleep.log | sh ${work_dir}/notify-server/bin/notify-me.sh
exit 0



else 
  exit 1
fi
