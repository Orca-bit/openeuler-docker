#!/bin/sh

set -e

yum install libffi-devel hdf5-devel -y

conda init

# source ~/.zshrc
source ~/.bashrc

# create conda env
conda create -n tf1 -c conda-forge python=3.7.5 -y

wget --no-check-certificate -O /tmp/tensorflow-1.15.0-cp37-cp37m-manylinux2014_aarch64.whl https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/MindX/OpenSource/python/packages/tensorflow-1.15.0-cp37-cp37m-manylinux2014_aarch64.whl#sha256=c2d6df0930f6558ec9bb741c219cb84f90f906cc9e2c28c6561960a1404dec39

# activate tf1.15 environment, then install packages
conda activate tf1
python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
pip config set global.index-url http://mirrors.aliyun.com/pypi/simple/
pip config set install.trusted-host mirrors.aliyun.com
# pip install tensorflow==1.15.0
pip install /tmp/tensorflow-1.15.0-cp37-cp37m-manylinux2014_aarch64.whl
pip install numpy decorator sympy==1.4 cffi==1.12.3 pyyaml pathlib2 pandas grpcio grpcio-tools protobuf==3.20.0 scipy requests mpi4py easydict scikit-learn==0.20.0 attrs

# Deactivate the environment
conda deactivate

# rm tmp file
rm /tmp/tensorflow*.whl -f
