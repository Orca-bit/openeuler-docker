#!/bin/sh

set -e

wget --no-check-certificate -O /tmp/tensorflow-1.15.0-cp37-cp37m-manylinux2014_aarch64.whl https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/MindX/OpenSource/python/packages/tensorflow-1.15.0-cp37-cp37m-manylinux2014_aarch64.whl#sha256=c2d6df0930f6558ec9bb741c219cb84f90f906cc9e2c28c6561960a1404dec39
wget --no-check-certificate -O /tmp/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/MindX/OpenSource/python/packages/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl#sha256=daf14490ef2b9334c7472d25ca66640e2546bc8e446c6bc1d88e5d4855e75db6

conda init

# source ~/.zshrc
source ~/.bashrc

# Create and activate tf1.15 environment, then install packages
conda create -n tf1 -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge python=3.7.5 -y
conda activate tf1
python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# pip install tensorflow==1.15.0
pip install /tmp/tensorflow-1.15.0-cp37-cp37m-manylinux2014_aarch64.whl
pip install tensorflow==1.15.0 numpy decorator sympy==1.4 cffi==1.12.3 pyyaml pathlib2 pandas grpcio grpcio-tools protobuf==3.20.0 scipy requests mpi4py easydict scikit-learn==0.20.0 attrs
pip install pyright

# Deactivate the environment
conda deactivate

# Create and activate tf2.6 environment, then install packages
conda create -n tf2 -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge python=3.7.5 -y
conda activate tf2
python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# pip install tensorflow==2.6.5
pip install /tmp/tensorflow-2.6.5-cp37-cp37m-manylinux2014_aarch64.whl
pip install tensorflow==2.6.5 numpy decorator sympy==1.4 cffi==1.12.3 pyyaml pathlib2 pandas grpcio grpcio-tools scipy requests mpi4py easydict scikit-learn==0.20.0 attrs
pip install protobuf==3.20.0
pip install pyright

# Deactivate the environment
conda deactivate

rm /tmp/tensorflow*.whl -f
