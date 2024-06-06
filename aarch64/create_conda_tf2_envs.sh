#!/bin/sh

set -e

# source ~/.zshrc
source ~/.bashrc

# create conda env
conda create -n tf2 -c conda-forge python=3.7.5 -y

wget --no-check-certificate -O /tmp/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/MindX/OpenSource/python/packages/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl#sha256=daf14490ef2b9334c7472d25ca66640e2546bc8e446c6bc1d88e5d4855e75db6
wget --no-check-certificate -O /tmp/h5py-3.1.0-cp37-cp37m-manylinux2014_aarch64.whl https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/MindX/OpenSource/python/packages/h5py-3.1.0-cp37-cp37m-manylinux2014_aarch64.whl#sha256=40dd06dce42fdb004b54a8f357ab6c181579320d410ad6ab0b0921f26df34f55

# activate tf2.6 environment, then install packages
conda activate tf2
# pip install tensorflow==2.6.5
pip install /tmp/h5py-3.1.0-cp37-cp37m-manylinux2014_aarch64.whl
pip install /tmp/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl

# Deactivate the environment
conda deactivate

# rm tmp file
rm /tmp/tensorflow*.whl h5py*.whl -f
