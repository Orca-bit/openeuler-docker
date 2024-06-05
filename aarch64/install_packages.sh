#!/bin/sh

set -e
# RUN brew install lsd cmake helix hyperfine ruff starship unzip tokei \
#     gitui broot git-delta vim fd zoxide bat llvm ripgrep && \
#     ln -s /usr/lib64/libzstd.so.1 /home/linuxbrew/.linuxbrew/lib/libzstd.so.1 && \
#     ln -s /home/linuxbrew/.linuxbrew/bin/lldb-dap /home/linuxbrew/.linuxbrew/bin/lldb-vscode

rust_version=1.78.0
helix_version=24.03
lsd_version=1.1.2
hyperfine_version=1.18.0
ruff_version=0.4.7
starship_version=1.19.0
tokei_version=12.1.2
gitui_version=0.26.3

# rust
function install_rust() {
    rust_install_path="/usr/local/rust"
    wget --no-check-certificate https://static.rust-lang.org/dist/rust-$rust_version-aarch64-unknown-linux-gnu.tar.xz -O /tmp/rust.tar.xz
    mkdir -p $rust_install_path
    tar -xJf /tmp/rust.tar.xz -C $rust_install_path --strip-components=1
    cd $rust_install_path && ./install.sh --prefix=/usr/local
    rm /tmp/rust.tar.xz
    rustc --version
    rust-analyzer --version
}

# helix
function install_helix() {
    helix_install_path="/usr/local/helix"
    wget --no-check-certificate -O /tmp/helix.tar.xz https://github.com/helix-editor/helix/releases/download/$helix_version/helix-$helix_version-aarch64-linux.tar.xz
    mkdir -p $helix_install_path
    tar -xJf /tmp/helix.tar.xz -C $helix_install_path --strip-components=1
    $helix_install_path/hx --version
    rm /tmp/helix.tar.xz
    echo "export PATH=$helix_install_path:\$PATH" >> /root/.zshrc
}

# lsd
function install_lsd() {
    lsd_install_path="/usr/local/lsd"
    wget --no-check-certificate https://github.com/lsd-rs/lsd/releases/download/v$lsd_version/lsd-v$lsd_version-aarch64-unknown-linux-musl.tar.gz -O /tmp/lsd.tar.gz
    mkdir -p $lsd_install_path
    tar -xzf /tmp/lsd.tar.gz -C $lsd_install_path
    mv -f $lsd_install_path/lsd*/* $lsd_install_path/
    $lsd_install_path/lsd --version
    rm /tmp/lsd.tar.gz
    echo "export PATH=$lsd_install_path:\$PATH" >> /root/.zshrc
}

# hyperfine
function install_hyperfine() {
    hyperfine_install_path="/usr/local/hyperfine"
    wget --no-check-certificate https://github.com/sharkdp/hyperfine/releases/download/v$hyperfine_version/hyperfine-v$hyperfine_version-aarch64-unknown-linux-gnu.tar.gz -O /tmp/hyperfine.tar.gz
    mkdir -p $hyperfine_install_path
    tar -xzf /tmp/hyperfine.tar.gz -C $hyperfine_install_path
    mv -f $hyperfine_install_path/hyperfine*/* $hyperfine_install_path/
    $hyperfine_install_path/hyperfine --version
    rm /tmp/hyperfine.tar.gz
    echo "export PATH=$hyperfine_install_path:\$PATH" >> /root/.zshrc
}

# ruff
function install_ruff() {
    ruff_install_path="/usr/local/ruff"
    wget --no-check-certificate https://github.com/astral-sh/ruff/releases/download/v$ruff_version/ruff-$ruff_version-aarch64-unknown-linux-musl.tar.gz -O /tmp/ruff.tar.gz
    mkdir -p $ruff_install_path
    tar -xzf /tmp/ruff.tar.gz -C $ruff_install_path
    $ruff_install_path/ruff --version
    rm /tmp/ruff.tar.gz
    echo "export PATH=$ruff_install_path:\$PATH" >> /root/.zshrc
}

# starship
function install_starship() {
    starship_install_path="/usr/local/starship"
    wget --no-check-certificate https://github.com/starship/starship/releases/download/v$starship_version/starship-aarch64-unknown-linux-musl.tar.gz -O /tmp/starship.tar.gz
    mkdir -p $starship_install_path
    tar -xzf /tmp/starship.tar.gz -C $starship_install_path
    $starship_install_path/starship --version
    rm /tmp/starship.tar.gz
    echo "export PATH=$starship_install_path:\$PATH" >> /root/.zshrc
}

# tokei
function install_tokei() {
    tokei_install_path="/usr/local/tokei"
    wget --no-check-certificate https://github.com/XAMPPRocky/tokei/releases/download/v$tokei_version/tokei-aarch64-unknown-linux-gnu.tar.gz -O /tmp/tokei.tar.gz
    mkdir -p $tokei_install_path
    tar -xzf /tmp/tokei.tar.gz -C $tokei_install_path
    $tokei_install_path/tokei --version
    rm /tmp/tokei.tar.gz
    echo "export PATH=$tokei_install_path:\$PATH" >> /root/.zshrc
}

# gitui
function install_gitui() {
    gitui_install_path="/usr/local/gitui"
    wget --no-check-certificate https://github.com/extrawurst/gitui/releases/download/v0.26.3/gitui-linux-aarch64.tar.gz -O /tmp/gitui.tar.gz
    mkdir -p $gitui_install_path
    tar -xzf /tmp/gitui.tar.gz -C $gitui_install_path
    $gitui_install_path/gitui --version
    rm /tmp/gitui.tar.gz
    echo "export PATH=$gitui_install_path:\$PATH" >> /root/.zshrc
}

# broot
function install_broot() {
    wget --no-check-certificate https://dystroy.org/broot/download/aarch64-unknown-linux-musl/broot -O /usr/bin/broot
    broot --version
}

sw=$1

if [[ $sw == "rust" ]];then
    install_rust
elif [[ $sw == "helix" ]];then
    install_helix
elif [[ $sw == "lsd" ]];then
    install_lsd
elif [[ $sw == "hyperfine" ]];then
    install_hyperfine
elif [[ $sw == "ruff" ]];then
    install_ruff
elif [[ $sw == "starship" ]];then
    install_starship
elif [[ $sw == "tokei" ]];then
    install_tokei
elif [[ $sw == "gitui" ]];then
    install_gitui
elif [[ $sw == "broot" ]];then
    install_broot
fi