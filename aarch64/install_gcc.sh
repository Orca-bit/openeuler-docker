#!/bin/sh

set -e

dnf install gcc-toolset-7-gcc gcc-toolset-7-g++ -y

gcc_install_dir=/opt/openEuler/gcc-toolset-7/root/usr/

mv /usr/bin/gcc /usr/bin/gcc.bak
update-alternatives --install /usr/bin/gcc gcc ${gcc_install_dir}/bin/gcc 100
update-alternatives --install /usr/bin/g++ g++ ${gcc_install_dir}/bin/g++ 100
