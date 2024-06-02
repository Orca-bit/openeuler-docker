#!/bin/sh

set -e

# Set environment variables for library versions
# GMP_VERSION=6.2.1
# MPFR_VERSION=4.1.0
# MPC_VERSION=1.2.1
GCC_VERSION=7.3.0

# Set source URLs for the libraries
# GMP_SOURCE_URL=https://mirrors.aliyun.com/gnu/gmp/gmp-${GMP_VERSION}.tar.bz2
# MPFR_SOURCE_URL=https://mirrors.aliyun.com/gnu/mpfr/mpfr-${MPFR_VERSION}.tar.bz2
# MPC_SOURCE_URL=https://mirrors.aliyun.com/gnu/mpc/mpc-${MPC_VERSION}.tar.gz
GCC_SOURCE_URL=https://mirrors.aliyun.com/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz

# Set install dirs for the libraries
# gmp_install_dir="/usr/local/gmp-$GMP_VERSION"
# mpfr_install_dir="/usr/local/mpfr-$MPFR_VERSION"
# mpc_install_dir="/usr/local/mpc-$MPC_VERSION"
gcc_install_dir="/usr/local/gcc-$GCC_VERSION"

# Download, extract, and build GMP
# wget --no-check-certificate ${GMP_SOURCE_URL} -O /tmp/gmp-${GMP_VERSION}.tar.bz2
# tar -xjf /tmp/gmp-${GMP_VERSION}.tar.bz2 -C /tmp
# cd /tmp/gmp-${GMP_VERSION}
# ./configure --prefix=${gmp_install_dir}
# make -j$(nproc)
# make install
# cd /
# rm -rf /tmp/gmp-${GMP_VERSION} /tmp/gmp-${GMP_VERSION}.tar.bz2

# Download, extract, and build MPFR
# wget --no-check-certificate ${MPFR_SOURCE_URL} -O /tmp/mpfr-${MPFR_VERSION}.tar.bz2
# tar -xjf /tmp/mpfr-${MPFR_VERSION}.tar.bz2 -C /tmp
# cd /tmp/mpfr-${MPFR_VERSION}
# ./configure --prefix=${mpfr_install_dir} --with-gmp=${gmp_install_dir}
# make -j$(nproc)
# make install
# cd /
# rm -rf /tmp/mpfr-${MPFR_VERSION} /tmp/mpfr-${MPFR_VERSION}.tar.bz2
 
# Download, extract, and build MPC
# wget --no-check-certificate ${MPC_SOURCE_URL} -O /tmp/mpc-${MPC_VERSION}.tar.gz
# tar -xzf /tmp/mpc-${MPC_VERSION}.tar.gz -C /tmp
# cd /tmp/mpc-${MPC_VERSION}
# ./configure --prefix=${mpc_install_dir} --with-gmp=${gmp_install_dir} --with-mpfr=${mpfr_install_dir}
# make -j$(nproc)
# make install
# cd /
# rm -rf /tmp/mpc-${MPC_VERSION} /tmp/mpc-${MPC_VERSION}.tar.gz

# Download, extract, and build GCC
wget --no-check-certificate ${GCC_SOURCE_URL} -O /tmp/gcc-${GCC_VERSION}.tar.gz
tar -xzf /tmp/gcc-${GCC_VERSION}.tar.gz -C /tmp
cd /tmp/gcc-${GCC_VERSION}
./contrib/download_prerequisites
# mkdir build
# cd build
# ./configure --prefix=${gcc_install_dir} --enable-threads=posix --enable-multiarch --disable-checking --enable--long-long --enable-languages=c,c++ --enable-multilib --with-gmp=${gmp_install_dir} --with-mpfr=${mpfr_install_dir} --with-mpc=${mpc_install_dir}
sed -i '/target-libsanitizer \\/d' configure.ac
sed -i '/target-libsanitizer \\/d' configure
./configure --prefix=${gcc_install_dir} --enable-languages=c,c++ --disable-multilib
# echo "${mpc_install_dir}/lib" >> /etc/ld.so.conf.d/libc.conf
# echo "${gmp_install_dir}/lib" >> /etc/ld.so.conf.d/libc.conf
# echo "${mpfr_install_dir}/lib" >> /etc/ld.so.conf.d/libc.conf
# ldconfig
make -j$(nproc)
make install
sed -i '/GCC_HOME/d' /etc/profile
echo "export GCC_HOME=${gcc_install_dir}" >> /etc/profile
echo "export PATH=\$GCC_HOME/bin:\$PATH" >> /etc/profile

update-alternatives --install /usr/bin/gcc gcc ${gcc_install_dir}/bin/gcc 100
update-alternatives --install /usr/bin/g++ g++ ${gcc_install_dir}/bin/g++ 100

cd /
rm -rf /tmp/gcc-${GCC_VERSION} /tmp/gcc-${GCC_VERSION}.tar.gz