#!/bin/bash

# set -x

if [ "$1" = "" ];then
  echo 'No arg... Plz "sh prepare.sh chk"'
  
elif [ "$1" = "chk" ];then 
  echo "Your argument is $1 "
  for i in `cat Vagrantfile | grep config_name | grep -v server | grep -v dummy-vm | awk -F\" '{print $4}'`
    do
      echo "The VM that you can start-up is $i"
      echo "Please execute this command"
      echo ""
      echo "vagrant up $i"
    done
  exit 0
else
  for i in `cat Vagrantfile | grep config_name | grep -v server | awk -F\" '{print $4}'`
    do
      if [ "$i" = "$1" ];then
        # echo "$1"
        vagrant destroy -f "$1"
        vagrant up "$1"
        echo vagrant ssh "$1"
        exit 0
      fi
    done
  echo "no match"
  exit 0
fi

# set -x
# 
# vb_name='pkg-ansible'
# 
# vagrant destroy -f
# vagrant up ${vb_name}
# echo "vagrant ssh ${vb_name}"

