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
    update-alternatives --install /usr/bin/g++ g++ ${gcc7_install_dir}/bin/g++ 100

# Create Conda environments and install packages using pip
COPY create_conda_tf1_envs.sh /tmp/create_conda_envs.sh
RUN sh /tmp/create_conda_envs.sh && rm -f /tmp/create_conda_envs.sh

# Create Conda environments and install packages using pip
COPY create_conda_tf2_envs.sh /tmp/create_conda_envs.sh
RUN sh /tmp/create_conda_envs.sh && rm -f /tmp/create_conda_envs.sh

# Ascend
RUN wget --no-check-certificate -O /tmp/cann-toolkit.run https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C18SPC805/Ascend-cann-toolkit_8.0.RC2.alpha002_linux-aarch64.run?response-content-type=application/octet-stream && \
    wget --no-check-certificate -O /tmp/tfa.run https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C18SPC805/Ascend-cann-tfplugin_8.0.RC2.alpha002_linux-aarch64.run?response-content-type=application/octet-stream && \
    cd /tmp && chmod +x *.run && ./cann-toolkit.run --full --force --quiet && ./tfa.run --install --quiet && \
    rm /tmp/*.run

RUN source ~/.bashrc && conda activate tf2 && \
    pip install numpy decorator sympy==1.4 cffi==1.12.3 pyyaml && \
    pip install pathlib2 pandas grpcio grpcio-tools scipy && \
    pip install requests mpi4py easydict scikit-learn==0.20.0 attrs && \
    pip install pyright

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
    rm -rf /root/.cache/pyright-python/nodeenv && \
    sed -i '81s/==/=/g' /etc/profile.d/system-info.sh

# Set zsh as the default shell in the Docker container
CMD ["/bin/zsh"]
