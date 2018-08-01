#!/bin/bash

set -x

work_dir='/usr/local/iganari'
my_dir="$(cd $(dirname $0); pwd)"
# my_dir="$ pwd)"

# setting_rclocal()
# {
#     sudo mv /etc/rc.d/rc.local etc/rc.d/rc.local.org
#     sudo cp -a ./etc/rc.d/rc.local /etc/rc.d/rc.local &&\
#     sudo chmod 755 /etc/rc.d/rc.local
# }

check_os()
{
  chk_debian='/etc/debian_version'
  chk_centos='/etc/redhat-release'
  chk_ubuntu='/etc/lsb-release'
  def_os=''
  
  if [ -f "${chk_debian}" ];then
    if [ "$(cat ${chk_debian})" = '8.11' ];then
      echo 'debian 8.11'
      def_os='debian_8.11'
    elif [ "$(cat ${chk_debian})" = '9.5' ];then
      echo 'debian 9.5'
      def_os='debian_9.5'
    else
      if [ -f "${chk_ubuntu}" ] && [ "$(cat ${chk_ubuntu} | grep DISTRIB_ID | awk -F\= '{print $2}')" = "Ubuntu" ];then
        if [ "$(cat ${chk_ubuntu} | grep DISTRIB_RELEASE | awk -F\= '{print $2}')" = "18.04" ];then
          echo "Ubuntu 18.04"
          def_os='ubuntu_18.04'
        else
          :
        fi
      else
        echo 'unkwon'
      fi
    fi
  elif [ -f "${chk_centos}" ];then
    if [ "$(cat ${chk_centos} | awk '{print $1}')" = "CentOS" ];then
      if [ "$(cat ${chk_centos} | awk '{print $3}')" = "6.10" ];then
        echo "CentOS 6.10"
        def_os='centos_6.10'
      elif [ "$(cat ${chk_centos} | awk '{print $4}')" = "7.5.1804" ];then
        echo "CentOS 7.5"
        def_os='centos_7.5'
      else
        echo "no version"
      fi
    else
      echo "not CentOS"
    fi
  else
    echo "no"
  fi
}

setting_systemctl()
{
  repo_dir="${work_dir}/notify-server"
  if [ "${def_os}" = "centos_6.10" ];then
    echo "CentOS 6.10"
    sudo cp -a ${repo_dir}/etc/init.d/send-notify /etc/init.d/send-notify
    sudo chmod 0755 /etc/init.d/send-notify
    sudo chkconfig --add send-notify
    sudo service send-notify start
    sleep 10
    # sudo service send-notify status
  else
    sudo cp -a ${repo_dir}/etc/systemd/system/send-notify.service.${def_os} ${repo_dir}/etc/systemd/system/send-notify.service
    sudo chmod 0755 ${repo_dir}/etc/systemd/system/send-notify.service
    sudo systemctl enable ${repo_dir}/etc/systemd/system/send-notify.service
    sudo systemctl start send-notify
    sleep 10
    sudo systemctl status send-notify
  fi
}

if [ "${my_dir}" = "${work_dir}/notify-server" ]; then
  echo "1"
  check_os
  # setting_rclocal
  setting_systemctl
  exit 0
else
  echo "設置ディレクトリが違反です。"
fi
