##
## many layers, use docker build --squash
##

# Use openEuler 22 as base image
# https://repo.openeuler.org/openEuler-22.03-LTS-SP3/docker_img/
FROM openeuler-22.03-lts-sp3:latest

COPY openEuler.repo /etc/yum.repos.d/

# Install dependencies
RUN yum clean all && yum makecache && yum update -y && \
    dnf install gcc-toolset-7-gcc gcc-toolset-7-g++ -y && \
    yum install -y \
    bzip2 \
    curl \
    git \
    zsh \
    wget \
    util-linux-user \
    sudo \
    make \
    m4 \
    gcc \
    gcc-c++ \
    kernel-headers \
    glibc-devel \
    glibc-headers \
    glibc-static vim cmake unzip openmpi openmpi-devel

ENV PATH="/usr/lib64/openmpi/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH"

# Change default shell to zsh
RUN chsh -s /bin/zsh && echo "source /etc/profile" >> ~/.zshrc

# Install Miniconda
RUN wget --no-check-certificate -O /tmp/Miniconda3-latest-Linux-aarch64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh && \
    bash /tmp/Miniconda3-latest-Linux-aarch64.sh -b -p /opt/conda && \
    rm /tmp/Miniconda3-latest-Linux-aarch64.sh && \
    /opt/conda/bin/conda clean --all --yes

ENV PATH="/opt/conda/bin:$PATH"

# git config
RUN git config --global http.sslverify false && git config --global core.editor vim

# Install zsh auto suggestions plugin
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Install precompiled packages
COPY install_packages.sh /tmp/
RUN chmod +x /tmp/install_packages.sh

RUN /tmp/install_packages.sh llvm && \
    /tmp/install_packages.sh rust && \
    /tmp/install_packages.sh helix && \
    /tmp/install_packages.sh lsd && \
    /tmp/install_packages.sh hyperfine && \
    /tmp/install_packages.sh ruff && \
    /tmp/install_packages.sh starship && \
    /tmp/install_packages.sh tokei && \
    /tmp/install_packages.sh gitui && \
    /tmp/install_packages.sh broot && \
    /tmp/install_packages.sh delta && \
    /tmp/install_packages.sh fd && \
    /tmp/install_packages.sh zoxide && \
    /tmp/install_packages.sh bat && \
    /tmp/install_packages.sh ripgrep && \
    rm /tmp/install_packages.sh

# cargo config
COPY cargo_config.toml /root/.cargo/config.toml

# helix config
COPY helix/config.toml helix/languages.toml /root/.config/helix/
COPY helix/themes/* /root/.config/helix/themes/

# vim config
RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime && \
    sh ~/.vim_runtime/install_basic_vimrc.sh && \
    rm -rf ~/.vim_runtime

ENV gcc7_install_dir=/opt/openEuler/gcc-toolset-7/root/usr/

# replace gcc g++
RUN mv -f /usr/bin/gcc /usr/bin/gcc.bak && \
    update-alternatives --install /usr/bin/gcc gcc ${gcc7_install_dir}/bin/gcc 100 && \
    mv -f /usr/bin/g++ /usr/bin/g++.bak && \
    update-alternatives --install /usr/bin/g++ g++ ${gcc7_install_dir}/bin/g++ 100 && \
    mv -f /usr/bin/c++ /usr/bin/c++.bak && \
    update-alternatives --install /usr/bin/c++ c++ ${gcc7_install_dir}/bin/c++ 100

# Create Conda environments and install packages using pip
COPY create_conda_tf1_envs.sh /tmp/create_conda_envs.sh
RUN sh /tmp/create_conda_envs.sh && rm -f /tmp/create_conda_envs.sh

RUN source ~/.bashrc && conda activate tf1 && \
    pip install numpy==1.21.6 decorator==5.1.1 sympy==1.4 cffi==1.12.3 pyyaml==6.0.1 pathlib2==2.3.7 && \
    pip install pandas grpcio grpcio-tools protobuf==3.20.0 scipy==1.7.3 requests==2.31.0 && \
    pip install mpi4py==3.1.5 easydict==1.11 scikit-learn==1.0.2 attrs==23.2.0 psutil==5.9 && \
    pip install setuptools==41.2.0 wheel==0.40.0 && \
    HOROVOD_WITH_MPI=1 HOROVOD_WITH_TENSORFLOW=1 pip install horovod --no-cache-dir

# Create Conda environments and install packages using pip
COPY create_conda_tf2_envs.sh /tmp/create_conda_envs.sh
RUN sh /tmp/create_conda_envs.sh && rm -f /tmp/create_conda_envs.sh

RUN source ~/.bashrc && conda activate tf2 && \
    pip install numpy==1.19.5 decorator==5.1.1 sympy==1.4 cffi==1.12.3 pyyaml==6.0 && \
    pip install pathlib2==2.3.7 pandas grpcio grpcio-tools protobuf==3.20.0 scipy==1.7.3 && \
    pip install requests==2.31.0 mpi4py==3.1.4 easydict==1.10 scikit-learn==1.0.2 attrs==23.1.0 && \
    pip install psutil==5.9 && \
    pip install setuptools==41.2.0 wheel==0.40.0 && \
    HOROVOD_WITH_MPI=1 HOROVOD_WITH_TENSORFLOW=1 pip install horovod --no-cache-dir

# Configure zsh
RUN echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc && \
    echo 'source /opt/conda/etc/profile.d/conda.sh' >> /root/.zshrc && \
    echo 'conda activate tf2' >> /root/.zshrc  && \
    echo 'export LC_ALL="C.UTF-8"' >> /root/.zshrc && \
    echo 'export LESSCHARSET=utf-8' >> /root/.zshrc && \
    echo 'alias cls="clear"' >> /root/.zshrc && \
    echo 'alias src="source"' >> /root/.zshrc && \
    echo 'alias mkf="touch"' >> /root/.zshrc && \
    echo 'alias mkd="mkdir"' >> /root/.zshrc && \
    echo 'alias ls="lsd"' >> /root/.zshrc && \
    echo 'alias ll="lsd -l"' >> /root/.zshrc && \
    echo 'alias lsa="lsd -a"' >> /root/.zshrc && \
    echo 'alias lla="lsd -al"' >> /root/.zshrc && \
    echo 'alias py="python"' >> /root/.zshrc && \
    echo 'alias cg="cargo"' >> /root/.zshrc && \
    echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc && \
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc && \
    echo 'source /usr/local/Ascend/driver/bin/setenv.bash' >> /root/.zshrc  && \
    echo 'source /usr/local/Ascend/ascend-toolkit/set_env.sh' >> /root/.zshrc && \
    echo 'source /usr/local/Ascend/tfplugin/set_env.sh' >> /root/.zshrc && \
    sed -i '81s/==/=/g' /etc/profile.d/system-info.sh
    
RUN echo "strict-ssl=false" >> /root/.npmrc && \
    echo "registry=https://registry.npm.taobao.org" >> /root/.npmrc

# install node and pyright
RUN curl -k -o /tmp/node.tar.xz https://nodejs.org/dist/v20.14.0/node-v20.14.0-linux-arm64.tar.xz && \
    mkdir -p /usr/local/node && \
    tar -xJf /tmp/node.tar.xz -C /usr/local/node --strip-components=1 && \
    echo "export PATH=/usr/local/node/bin:\$PATH" >> /root/.zshrc && \
    export PATH=/usr/local/node/bin:$PATH && \
    /usr/local/node/bin/npm install -g pyright && \
    rm /tmp/node.tar.xz
    
# python3.8 and fix lldb-dap
RUN source ~/.bashrc && conda create -c conda-forge -n py38 python=3.8 && \
    mkdir -p /usr/local/lldb-dep/lib && \
    ln -s /opt/conda/lib/libedit.so.0.0.72 /usr/local/lldb-dep/lib/libedit.so.2 && \
    ln -s /opt/conda/envs/py38/lib/libpython3.8.so.1.0 /usr/local/lldb-dep/lib/libpython3.8.so.1.0 && \
    ln -s /opt/conda/envs/py38/lib/libncurses.so.6.5 /usr/local/lldb-dep/lib/libncurses.so.6 && \
    ln -s /opt/conda/envs/py38/lib/libpanel.so.6.5 /usr/local/lldb-dep/lib/libpanel.so.6 && \
    ln -s /opt/conda/envs/py38/lib/libtinfo.so.6.5 /usr/local/lldb-dep/lib/libtinfo.so.6 && \
    ln -s /opt/conda/envs/py38/lib/libtinfow.so.6.5 /usr/local/lldb-dep/lib/libtinfow.so.6

ENV LD_LIBRARY_PATH="/usr/local/lldb-dep/lib/:$LD_LIBRARY_PATH"

# upgrade setuptools
RUN source ~/.bashrc && conda activate tf1 && \
    pip uninstall setuptools -y && \
    pip install setuptools && \
    conda activate tf2 && \
    pip uninstall setuptools -y && \
    pip install setuptools

# Set zsh as the default shell in the Docker container
CMD ["/bin/zsh"]
