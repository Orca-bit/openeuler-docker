#!/bin/sh

set -e

conda init

# source ~/.zshrc
source ~/.bashrc

# Create and activate tf1.15 environment, then install packages
conda create -n tf1 python=3.7.5 -y
conda activate tf1
python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# pip install tensorflow==1.15.0
pip install tensorflow==1.15.0 numpy decorator sympy==1.4 cffi==1.12.3 pyyaml pathlib2 pandas grpcio grpcio-tools protobuf==3.20.0 scipy requests mpi4py easydict scikit-learn==0.20.0 attrs
pip install pyright

# Deactivate the environment
conda deactivate

# Create and activate tf2.6 environment, then install packages
conda create -n tf2 python=3.7.5 -y
conda activate tf2
python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# pip install tensorflow==2.6.5
pip install tensorflow==2.6.5 numpy decorator sympy==1.4 cffi==1.12.3 pyyaml pathlib2 pandas grpcio grpcio-tools scipy requests mpi4py easydict scikit-learn==0.20.0 attrs
pip install protobuf==3.20.0
pip install pyright

# Deactivate the environment
conda deactivate
