FROM debian:13

RUN apt update && apt upgrade -y && \
    apt install -y bash-completion ca-certificates curl git gnupg htop less locales-all man-db openssh-server psmisc python3-venv rsync sudo tmux vim wget iftop iotop build-essential zsh fio smartmontools apache2-utils arch-install-scripts cloc cmake make gdb jq ncdu progress rclone strace socat binutils dnsutils whois mtr lftp iperf3 ranger tcpdump zstd
RUN useradd -ms /usr/bin/zsh zzh1996 && \
    usermod -aG sudo zzh1996 && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER zzh1996
WORKDIR /home/zzh1996
SHELL ["/bin/bash", "-c"]

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    curl https://raw.githubusercontent.com/zzh1996/zshrc/master/zshrc.sh > ~/.zshrc.sh && \
    sed -i '/source $ZSH\/oh-my-zsh.sh/isource ~/.zshrc.sh' ~/.zshrc && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc && \
    curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

# Go
RUN if [[ $(uname -m) == "aarch64" ]]; then \
        wget https://go.dev/dl/go1.25.0.linux-arm64.tar.gz -O go.tar.gz; \
    else \
        wget https://go.dev/dl/go1.25.0.linux-amd64.tar.gz -O go.tar.gz; \
    fi && \
    sudo tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && /home/zzh1996/.foundry/bin/foundryup

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    source ~/.nvm/nvm.sh && \
    nvm install node

# uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Haskell
# RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

ENV TZ=America/Los_Angeles
CMD ["zsh"]
