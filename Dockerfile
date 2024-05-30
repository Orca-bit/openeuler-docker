# Use openEuler 22 as base image
# https://repo.openeuler.org/openEuler-22.03-LTS-SP3/docker_img/
FROM openeuler-22.03-lts-sp3:latest

COPY openEuler.repo /etc/yum.repos.d/

# Install dependencies
RUN yum clean all && yum makecache && yum update -y && \
    yum install -y \
    bzip2 \
    curl \
    git \
    zsh \
    wget \
    util-linux-user \
    gcc \
    g++ \
    sudo

# Change default shell to zsh
RUN chsh -s /bin/zsh && touch ~/.zshrc

# Install Miniconda
RUN wget --no-check-certificate -O /tmp/Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm /tmp/Miniconda3-latest-Linux-x86_64.sh && \
    /opt/conda/bin/conda clean --all --yes

ENV PATH="/opt/conda/bin:$PATH"

# Update .condarc file to disable SSL verification and add conda-forge channel
COPY .condarc /root/

# Create Conda environments and install packages using pip
COPY create_conda_envs.sh /tmp/create_conda_envs.sh
RUN sh /tmp/create_conda_envs.sh && rm -f /tmp/create_conda_envs.sh

# Install Linuxbrew
RUN wget --no-check-certificate -O /tmp/install.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh && \
    bash /tmp/install.sh && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc && \
    rm /tmp/install.sh

ENV PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
ENV PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"

# Install brew packages
RUN brew install lsd cmake helix hyperfine ruff starship unzip tokei gitui broot git-delta

# Install zsh auto suggestions plugin
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Configure zsh
RUN echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc && \
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Set zsh as the default shell in the Docker container
CMD ["/bin/zsh"]
