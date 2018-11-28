#!/bin/bash

set -x

### Get current directory
my_dir="$(cd $(dirname $0); pwd)"

# my_dir="$ pwd)"

# setting_rclocal()
# {
#     sudo mv /etc/rc.d/rc.local etc/rc.d/rc.local.org
#     sudo cp -a ./etc/rc.d/rc.local /etc/rc.d/rc.local &&\
#     sudo chmod 755 /etc/rc.d/rc.local
# }

check_dir()
{
    repo_name='notify-server'
    work_dir='/usr/local/bin'
    # useradd -m -s /bin/bash ${user_name}
    # mkdir ${work_dir} && \
    # chmod 0777 -R ${work_dir}/${user_name}
    repo_dir="${work_dir}/${repo_name}"
    cd ${repo_dir}
}

check_os()
{
  chk_debian='/etc/debian_version'
  chk_centos='/etc/redhat-release'
  chk_ubuntu='/etc/lsb-release'
  chk_raspbian='/usr/lib/os-release'
  def_os=''
  
  if [ -f "${chk_debian}" ];then
    if [ "$(cat ${chk_debian})" = '8.11' ];then
      echo 'debian 8.11'
      def_os='debian_8.11'
    elif [ "$(cat ${chk_debian})" = '9.3' ];then
      echo 'debian 9.3 stretch'
      def_os='debian_9.5'
    elif [ "$(cat ${chk_debian})" = '9.5' ];then
      echo 'debian 9.5 stretch'
      def_os='debian_9.5'
    else
      if [ -f "${chk_ubuntu}" ] && [ "$(cat ${chk_ubuntu} | grep DISTRIB_ID | awk -F\= '{print $2}')" = "Ubuntu" ];then
        if [ "$(cat ${chk_ubuntu} | grep DISTRIB_RELEASE | awk -F\= '{print $2}')" = "18.04" ];then
          echo "Ubuntu 18.04"
          def_os='ubuntu_18.04'
        else
          echo "no idea"
          exit 1
        fi
      elif [ "${chk_raspbin}" = "" ]; then
        if ["$(cat ${chk_raspbian} | grep PRETTY_NAME | awk -F\" '{print $2}' | awk -F\  '{print $NF}')" =  "buster/sid" ]; then
          echo "Raspbian buster"
          def_os='raspbian_buster'
        else
          echo "no idea"
          exit 1
        fi
      else
        echo 'unkwon'
        exit 1
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
        exit 1
      fi
    else
      echo "not CentOS"
      exit 1
    fi
  else
    echo "no idea"
    exit 1
  fi
}

setting_script()
{
  # repo_dir="${work_dir}/${repo_name}"
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


### Main
check_dir

if [ "${my_dir}" = "${repo_dir}" ]; then
  # echo "1"
  # chkeck_user
  check_os
  setting_script
  exit 0
else
  echo "設置ディレクトリが違反です。"
fi
