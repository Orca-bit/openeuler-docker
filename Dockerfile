# Use openEuler 22 as base image
# https://repo.openeuler.org/openEuler-22.03-LTS-SP3/docker_img/
FROM openeuler-22.03-lts-sp3:latest

# Install dependencies
RUN yum update -y && \
    yum install -y \
    bzip2 \
    curl \
    git \
    zsh \
    wget \
    util-linux-user \
    sudo

# Change default shell to zsh
RUN chsh -s /bin/zsh

# Install Miniconda
RUN wget --no-check-certificate -O /tmp/Miniconda3-latest-Linux-x86_64.sh  https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda-latest-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm /tmp/Miniconda3-latest-Linux-x86_64.sh
    # /opt/conda/bin/conda clean --all --yes

ENV PATH="/opt/conda/bin:$PATH"

# Update .condarc file to disable SSL verification and add conda-forge channel
COPY .condarc /root/

# Create Conda environments and install packages using pip
RUN conda create -n tf1 python=3.7.5 -y && conda activate tf1 && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow==1.15.0 numpy decorator sympy==1.4 cffi==1.12.3 pyyaml pathlib2 pandas grpcio grpcio-tools protobuf==3.20.0 scipy requests mpi4py easydict scikit-learn==0.20.0 attrs && \
    conda deactivate && \
    conda create -n tf2 python=3.7.5 -y && conda activate tf2 && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow==2.6.5 numpy decorator sympy==1.4 cffi==1.12.3 pyyaml pathlib2 pandas grpcio grpcio-tools protobuf==3.20.0 scipy requests mpi4py easydict scikit-learn==0.20.0 attrs

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