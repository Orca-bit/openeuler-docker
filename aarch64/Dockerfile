##
## many layers, use docker build --squash
##

# Use openEuler 22 as base image
# https://repo.openeuler.org/openEuler-22.03-LTS-SP3/docker_img/
FROM openeuler-22.03-lts-sp3:latest

COPY openEuler.repo /etc/yum.repos.d/

COPY install_gcc.sh /tmp/

# Install dependencies
RUN yum clean all && yum makecache && yum update -y && \
    sh /tmp/install_gcc.sh && rm -f /tmp/install_gcc.sh && \
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

# Create Conda environments and install packages using pip
COPY create_conda_tf1_envs.sh /tmp/create_conda_envs.sh
RUN sh /tmp/create_conda_envs.sh && rm -f /tmp/create_conda_envs.sh

# Create Conda environments and install packages using pip
COPY create_conda_tf2_envs.sh /tmp/create_conda_envs.sh
RUN sh /tmp/create_conda_envs.sh && rm -f /tmp/create_conda_envs.sh

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
    rm -rf /root/.cache/pyright-python/nodeenv && \
    sed -i '81s/==/=/g' /etc/profile.d/system-info.sh

# Set zsh as the default shell in the Docker container
CMD ["/bin/zsh"]
