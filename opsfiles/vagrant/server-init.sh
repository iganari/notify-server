#!/bin/bash

set -x

mkdir -p           /usr/local/iganari/notify-server
chown root:root -R /usr/local/iganari
chmod 0777      -R /usr/local/iganari

# groupadd hejda
# useradd -m -s /bin/bash hejda-admin -G hejda
useradd -m -s /bin/bash iganari

echo 'iganari ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/iganari
chmod 0440                                  /etc/sudoers.d/iganari


ls /develop/notify-server | grep -v opsfiles | xargs -i cp -vr /develop/notify-server/{} /usr/local/iganari/notify-server/
                                                   
chown root:root -R /usr/local/iganari
chmod 0777      -R /usr/local/iganari

ls -la /usr/local/iganari/notify-server/
