#!/bin/sh

set -e

rust_version=1.78.0
helix_version=24.03
lsd_version=1.1.2
hyperfine_version=1.18.0
ruff_version=0.4.7
starship_version=1.19.0
tokei_version=12.1.2
gitui_version=0.26.3
delta_version=0.17.0
fd_version=10.1.0
z_version=0.9.4
bat_version=0.24.0
ripgrep_version=14.1.0
llvm_version=18.1.6

github_boost=https://github.moeyy.xyz/

function install_delta() {
    delta_install_path="/usr/local/delta"
    wget --no-check-certificate -O /tmp/delta.tar.gz ${github_boost}https://github.com/dandavison/delta/releases/download/$delta_version/delta-$delta_version-aarch64-unknown-linux-gnu.tar.gz
    mkdir -p $delta_install_path
    tar -xzf /tmp/delta.tar.gz -C $delta_install_path
    mv -f $delta_install_path/delta*/* $delta_install_path/
    $delta_install_path/delta --version
    rm /tmp/delta.tar.gz
    echo "export PATH=$delta_install_path:\$PATH" >> /root/.zshrc
}

function install_fd() {
    fd_install_path="/usr/local/fd"
    wget --no-check-certificate -O /tmp/fd.tar.gz ${github_boost}https://github.com/sharkdp/fd/releases/download/v$fd_version/fd-v$fd_version-aarch64-unknown-linux-musl.tar.gz
    mkdir -p $fd_install_path
    tar -xzf /tmp/fd.tar.gz -C $fd_install_path
    mv -f $fd_install_path/fd*/* $fd_install_path/
    $fd_install_path/fd --version
    rm /tmp/fd.tar.gz
    echo "export PATH=$fd_install_path:\$PATH" >> /root/.zshrc
}

function install_zoxide() {
    z_install_path="/usr/local/zoxide"
    wget --no-check-certificate -O /tmp/zoxide.tar.gz ${github_boost}https://github.com/ajeetdsouza/zoxide/releases/download/v$z_version/zoxide-$z_version-aarch64-unknown-linux-musl.tar.gz
    mkdir -p $z_install_path
    tar -xzf /tmp/zoxide.tar.gz -C $z_install_path
    $z_install_path/zoxide --version
    rm /tmp/zoxide.tar.gz
    echo "export PATH=$z_install_path:\$PATH" >> /root/.zshrc
}

function install_bat() {
    bat_install_path="/usr/local/bat"
    wget --no-check-certificate -O /tmp/bat.tar.gz ${github_boost}https://github.com/sharkdp/bat/releases/download/v$bat_version/bat-v$bat_version-aarch64-unknown-linux-gnu.tar.gz
    mkdir -p $bat_install_path
    tar -xzf /tmp/bat.tar.gz -C $bat_install_path
    mv -f $bat_install_path/bat*/* $bat_install_path/
    $bat_install_path/bat --version
    rm /tmp/bat.tar.gz
    echo "export PATH=$bat_install_path:\$PATH" >> /root/.zshrc
}

function install_ripgrep() {
    ripgrep_install_path="/usr/local/ripgrep"
    wget --no-check-certificate -O /tmp/ripgrep.tar.gz ${github_boost}https://github.com/BurntSushi/ripgrep/releases/download/$ripgrep_version/ripgrep-$ripgrep_version-aarch64-unknown-linux-gnu.tar.gz
    mkdir -p $ripgrep_install_path
    tar -xzf /tmp/ripgrep.tar.gz -C $ripgrep_install_path
    mv -f $ripgrep_install_path/ripgrep*/* $ripgrep_install_path/
    $ripgrep_install_path/rg --version
    rm /tmp/ripgrep.tar.gz
    echo "export PATH=$ripgrep_install_path:\$PATH" >> /root/.zshrc
}

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

function install_llvm() {
    llvm_install_path="/usr/local/llvm"
    wget --no-check-certificate -O /tmp/llvm.tar.xz ${github_boost}https://github.com/llvm/llvm-project/releases/download/llvmorg-$llvm_version/clang+llvm-$llvm_version-aarch64-linux-gnu.tar.xz
    mkdir -p $llvm_install_path
    tar -xJf /tmp/llvm.tar.xz -C $llvm_install_path --strip-components=1
    $llvm_install_path/bin/clangd --version
    ln -s $llvm_install_path/bin/lldb-dap $llvm_install_path/bin/lldb-vscode
    rm /tmp/llvm.tar.xz
    echo "export PATH=$llvm_install_path/bin:\$PATH" >> /root/.zshrc
}

# helix
function install_helix() {
    helix_install_path="/usr/local/helix"
    wget --no-check-certificate -O /tmp/helix.tar.xz ${github_boost}https://github.com/helix-editor/helix/releases/download/$helix_version/helix-$helix_version-aarch64-linux.tar.xz
    mkdir -p $helix_install_path
    tar -xJf /tmp/helix.tar.xz -C $helix_install_path --strip-components=1
    $helix_install_path/hx --version
    rm /tmp/helix.tar.xz
    echo "export PATH=$helix_install_path:\$PATH" >> /root/.zshrc
}

# lsd
function install_lsd() {
    lsd_install_path="/usr/local/lsd"
    wget --no-check-certificate ${github_boost}https://github.com/lsd-rs/lsd/releases/download/v$lsd_version/lsd-v$lsd_version-aarch64-unknown-linux-musl.tar.gz -O /tmp/lsd.tar.gz
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
    wget --no-check-certificate ${github_boost}https://github.com/sharkdp/hyperfine/releases/download/v$hyperfine_version/hyperfine-v$hyperfine_version-aarch64-unknown-linux-gnu.tar.gz -O /tmp/hyperfine.tar.gz
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
    wget --no-check-certificate ${github_boost}https://github.com/astral-sh/ruff/releases/download/v$ruff_version/ruff-$ruff_version-aarch64-unknown-linux-musl.tar.gz -O /tmp/ruff.tar.gz
    mkdir -p $ruff_install_path
    tar -xzf /tmp/ruff.tar.gz -C $ruff_install_path
    $ruff_install_path/ruff --version
    rm /tmp/ruff.tar.gz
    echo "export PATH=$ruff_install_path:\$PATH" >> /root/.zshrc
}

# starship
function install_starship() {
    starship_install_path="/usr/local/starship"
    wget --no-check-certificate ${github_boost}https://github.com/starship/starship/releases/download/v$starship_version/starship-aarch64-unknown-linux-musl.tar.gz -O /tmp/starship.tar.gz
    mkdir -p $starship_install_path
    tar -xzf /tmp/starship.tar.gz -C $starship_install_path
    $starship_install_path/starship --version
    rm /tmp/starship.tar.gz
    echo "export PATH=$starship_install_path:\$PATH" >> /root/.zshrc
}

# tokei
function install_tokei() {
    tokei_install_path="/usr/local/tokei"
    wget --no-check-certificate ${github_boost}https://github.com/XAMPPRocky/tokei/releases/download/v$tokei_version/tokei-aarch64-unknown-linux-gnu.tar.gz -O /tmp/tokei.tar.gz
    mkdir -p $tokei_install_path
    tar -xzf /tmp/tokei.tar.gz -C $tokei_install_path
    $tokei_install_path/tokei --version
    rm /tmp/tokei.tar.gz
    echo "export PATH=$tokei_install_path:\$PATH" >> /root/.zshrc
}

# gitui
function install_gitui() {
    gitui_install_path="/usr/local/gitui"
    wget --no-check-certificate ${github_boost}https://github.com/extrawurst/gitui/releases/download/v0.26.3/gitui-linux-aarch64.tar.gz -O /tmp/gitui.tar.gz
    mkdir -p $gitui_install_path
    tar -xzf /tmp/gitui.tar.gz -C $gitui_install_path
    $gitui_install_path/gitui --version
    rm /tmp/gitui.tar.gz
    echo "export PATH=$gitui_install_path:\$PATH" >> /root/.zshrc
}

# broot
function install_broot() {
    wget --no-check-certificate https://dystroy.org/broot/download/aarch64-unknown-linux-musl/broot -O /usr/local/bin/broot
    chmod +x /usr/local/bin/broot
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
elif [[ $sw == "delta" ]];then
    install_delta
elif [[ $sw == "fd" ]];then
    install_fd
elif [[ $sw == "zoxide" ]];then
    install_zoxide
elif [[ $sw == "bat" ]];then
    install_bat
elif [[ $sw == "ripgrep" ]];then
    install_ripgrep
elif [[ $sw == "llvm" ]];then
    install_llvm
fi