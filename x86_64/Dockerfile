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

ENV gcc7_install_dir=/opt/openEuler/gcc-toolset-7/root/usr/

# replace gcc g++
RUN mv -f /usr/bin/gcc /usr/bin/gcc.bak && \
    update-alternatives --install /usr/bin/gcc gcc ${gcc7_install_dir}/bin/gcc 100 && \
    mv -f /usr/bin/g++ /usr/bin/g++.bak && \
    update-alternatives --install /usr/bin/g++ g++ ${gcc7_install_dir}/bin/g++ 100 && \
    mv -f /usr/bin/c++ /usr/bin/c++.bak && \
    update-alternatives --install /usr/bin/c++ c++ ${gcc7_install_dir}/bin/c++ 100

ENV PATH="/usr/lib64/openmpi/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH"

# Change default shell to zsh
RUN chsh -s /bin/zsh && echo "source /etc/profile" >> ~/.zshrc

# Install Miniconda
RUN wget --no-check-certificate -O /tmp/Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm /tmp/Miniconda3-latest-Linux-x86_64.sh && \
    /opt/conda/bin/conda clean --all --yes

ENV PATH="/opt/conda/bin:$PATH"

# git config
RUN git config --global http.sslverify false && git config --global core.editor vim

# Install zsh auto suggestions plugin
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Create Conda environments and install packages using pip
COPY create_conda_envs.sh /tmp/create_conda_envs.sh
RUN sh /tmp/create_conda_envs.sh && rm -f /tmp/create_conda_envs.sh

ENV HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
ENV HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
ENV HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
ENV HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"

# Create a non-root user for Homebrew
RUN useradd -m -s /bin/bash brewuser && \
    echo 'brewuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to non-root user and install Homebrew
USER brewuser

# Install Linuxbrew
RUN git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git /tmp/brew-install && \
    bash /tmp/brew-install/install.sh && \
    rm -rf /tmp/brew-install

# Switch back to root user
USER root

RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.bashrc && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.zshrc

ENV PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
ENV PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"

ENV RUSTUP_DIST_SERVER="https://rsproxy.cn"
ENV RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"    

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh -s -- -y && \
    echo 'source $HOME/.cargo/env' >> /etc/profile

# install ra
RUN /root/.cargo/bin/rustup component add rust-analyzer

# Install brew packages
RUN brew install lsd cmake helix hyperfine ruff starship unzip tokei \
    gitui broot git-delta vim fd zoxide bat llvm ripgrep && \
    ln -s /usr/lib64/libzstd.so.1 /home/linuxbrew/.linuxbrew/lib/libzstd.so.1 && \
    ln -s /home/linuxbrew/.linuxbrew/bin/lldb-dap /home/linuxbrew/.linuxbrew/bin/lldb-vscode

# cargo config
COPY cargo_config.toml /root/.cargo/config.toml

# helix config
COPY helix/config.toml helix/languages.toml /root/.config/helix/
COPY helix/themes/* /root/.config/helix/themes/

# vim config
RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime && \
    sh ~/.vim_runtime/install_basic_vimrc.sh && \
    rm -rf ~/.vim_runtime

RUN echo "strict-ssl=false" >> /root/.npmrc && \
    echo "registry=https://registry.npm.taobao.org" >> /root/.npmrc

# install node and pyright
RUN curl -k -o /tmp/node.tar.xz https://nodejs.org/dist/v20.14.0/node-v20.14.0-linux-x64.tar.xz && \
    mkdir -p /usr/local/node && \
    tar -xJf /tmp/node.tar.xz -C /usr/local/node --strip-components=1 && \
    echo "export PATH=/usr/local/node/bin:\$PATH" >> /root/.zshrc && \
    export PATH=/usr/local/node/bin:$PATH && \
    /usr/local/node/bin/npm install -g pyright && \
    rm /tmp/node.tar.xz

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

# Set zsh as the default shell in the Docker container
CMD ["/bin/zsh"]
