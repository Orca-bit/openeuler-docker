#!/bin/sh

set -e

# source ~/.zshrc
source ~/.bashrc

# create conda env
conda create -n tf2 -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge python=3.7.5 -y

wget --no-check-certificate -O /tmp/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/MindX/OpenSource/python/packages/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl#sha256=daf14490ef2b9334c7472d25ca66640e2546bc8e446c6bc1d88e5d4855e75db6

# activate tf2.6 environment, then install packages
conda activate tf2
# pip install tensorflow==2.6.5
pip install /tmp/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl
pip install numpy decorator sympy==1.4 cffi==1.12.3 pyyaml pathlib2 pandas grpcio grpcio-tools protobuf==3.20.0 scipy requests mpi4py easydict scikit-learn==0.20.0 attrs
pip install pyright

# Deactivate the environment
conda deactivate

# rm tmp file
rm /tmp/tensorflow*.whl -f
