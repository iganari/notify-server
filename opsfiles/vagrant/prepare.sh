#!/bin/bash

# set -x

# vb_name='pkg-ansible'

echo $1

if [ "$1" = "" ];then
  echo 'no arg. Plz "sh prepare.sh chk"'
  
elif [ "$1" = "chk" ];then 
  echo "vagrant server is "
  for i in `cat Vagrantfile | grep config_name | grep -v server | grep -v ubuntu-16.04 | awk -F\" '{print $4}'`
    do
      echo "$i"
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


# vagrant destroy -f
# vagrant up ${vb_name}
# echo "vagrant ssh ${vb_name}"

