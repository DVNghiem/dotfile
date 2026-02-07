#!/bin/bash

# Backend Developer Environment Setup Script
# This script installs all necessary tools for backend development

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_info "Starting Backend Developer Environment Setup..."
print_info "Script directory: $SCRIPT_DIR"

# Update system packages
print_info "Updating system packages..."
if command_exists dnf; then
    sudo dnf update -y
elif command_exists apt-get; then
    sudo apt-get update
    sudo apt-get upgrade -y
elif command_exists yum; then
    sudo yum update -y
elif command_exists pacman; then
    sudo pacman -Syu --noconfirm
fi

# Install essential build tools and dependencies
print_info "Installing essential build tools..."
if command_exists dnf; then
    sudo dnf install -y \
        curl \
        wget \
        git \
        unzip \
        zip \
        tar \
        gcc \
        gcc-c++ \
        make \
        cmake \
        automake \
        autoconf \
        ca-certificates \
        gnupg2 \
        tree \
        htop \
        tmux \
        jq \
        ripgrep \
        fd-find \
        bat \
        net-tools \
        openssl \
        openssl-devel \
        pkg-config \
        ncurses-devel \
        readline-devel \
        zlib-devel \
        bzip2-devel \
        sqlite-devel \
        libffi-devel
elif command_exists apt-get; then
    sudo apt-get install -y \
        build-essential \
        curl \
        wget \
        git \
        unzip \
        zip \
        tar \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        tree \
        htop \
        tmux \
        jq \
        ripgrep \
        fd-find \
        bat \
        net-tools \
        openssl \
        libssl-dev \
        pkg-config
elif command_exists yum; then
    sudo yum groupinstall -y "Development Tools"
    sudo yum install -y curl wget git unzip zip tar tree htop tmux jq ripgrep fd-find bat
elif command_exists pacman; then
    sudo pacman -S --noconfirm base-devel curl wget git unzip zip tar tree htop tmux jq ripgrep fd bat
fi

# Install ZSH and configure shell
print_info "Installing ZSH..."
if [ -f "$SCRIPT_DIR/zsh/install.sh" ]; then
    bash "$SCRIPT_DIR/zsh/install.sh"
else
    print_warning "ZSH install script not found, skipping..."
fi

# Install Zoxide (smart directory navigation)
print_info "Installing Zoxide..."
if [ -f "$SCRIPT_DIR/zoxide/install.sh" ]; then
    bash "$SCRIPT_DIR/zoxide/install.sh"
else
    if ! command_exists zoxide; then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
fi

# Install NVM and Node.js
print_info "Installing NVM and Node.js..."
if [ -f "$SCRIPT_DIR/nvm/install.sh" ]; then
    bash "$SCRIPT_DIR/nvm/install.sh"
else
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
    fi
fi

# Install Rust and Cargo
print_info "Installing Rust..."
if [ -f "$SCRIPT_DIR/rust/install.sh" ]; then
    bash "$SCRIPT_DIR/rust/install.sh"
else
    if ! command_exists rustc; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
fi

# Install SDKMAN (Java, Kotlin, Gradle, Maven, etc.)
print_info "Installing SDKMAN..."
if [ -f "$SCRIPT_DIR/sdkman/install.sh" ]; then
    bash "$SCRIPT_DIR/sdkman/install.sh"
else
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
        sdk install java
        sdk install gradle
        sdk install maven
    fi
fi

# Install Python and pip
print_info "Installing Python development tools..."
if command_exists dnf; then
    sudo dnf install -y python3 python3-pip python3-devel python3-virtualenv
elif command_exists apt-get; then
    sudo apt-get install -y python3 python3-pip python3-venv python3-dev
elif command_exists yum; then
    sudo yum install -y python3 python3-pip python3-devel
elif command_exists pacman; then
    sudo pacman -S --noconfirm python python-pip
fi
# Install Docker
print_info "Installing Docker..."
if [ -f "$SCRIPT_DIR/docker/install.sh" ]; then
    bash "$SCRIPT_DIR/docker/install.sh"
else
    if ! command_exists docker; then
        if command_exists dnf; then
            # Install Docker on Fedora
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            
            # Start and enable Docker service
            sudo systemctl start docker
            sudo systemctl enable docker
            
            # Add user to docker group
            sudo usermod -aG docker $USER
            print_warning "Please log out and back in for docker group changes to take effect"
        elif command_exists apt-get; then
            # Add Docker's official GPG key
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            
            # Set up the repository
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            
            # Add user to docker group
            sudo usermod -aG docker $USER
            print_warning "Please log out and back in for docker group changes to take effect"
        fi
    fi
fi

# Install Neovim
print_info "Installing Neovim..."
if [ -f "$SCRIPT_DIR/nvim/install.sh" ]; then
    bash "$SCRIPT_DIR/nvim/install.sh"
else
    if ! command_exists nvim; then
        curl -LO https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz 
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf  nvim-linux-x86_64.tar.gz 
        sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
        rm nvim-linux-x86_64.tar.gz 
    fi
    
    # Install Neovim config
    if [ -d "$SCRIPT_DIR/nvim" ] && [ ! -d ~/.config/nvim ]; then
        mkdir -p ~/.config
        ln -sf "$SCRIPT_DIR/nvim" ~/.config/nvim
    fi
fi

# Install Terminal Emulators
print_info "Installing terminal emulators..."

# Alacritty
if [ -f "$SCRIPT_DIR/alacritty/install.sh" ]; then
    bash "$SCRIPT_DIR/alacritty/install.sh"
fi

# # WezTerm
# if [ -f "$SCRIPT_DIR/wezterm/install/all.sh" ]; then
#     bash "$SCRIPT_DIR/wezterm/install/all.sh"
# fi

# Install Additional Developer Tools
print_info "Installing additional developer tools..."

# lazygit (TUI for git)
if ! command_exists lazygit; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
fi

# lazydocker (TUI for docker)
if ! command_exists lazydocker; then
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# gh (GitHub CLI)
if ! command_exists gh; then
    if command_exists dnf; then
        sudo dnf install -y 'dnf-command(config-manager)'
        sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
        sudo dnf install -y gh
    elif command_exists apt-get; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y gh
    fi
fi

# fzf (fuzzy finder)
if ! command_exists fzf; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

# tldr (simplified man pages)
if ! command_exists tldr; then
    python3 -m pip install --user tldr
fi

# btop (better top)
if ! command_exists btop; then
    if command_exists dnf; then
        sudo dnf install -y btop
    elif command_exists apt-get; then
        sudo apt-get install -y btop
    fi
fi

# dust (better du)
if ! command_exists dust; then
    cargo install du-dust 2>/dev/null || print_warning "Failed to install dust via cargo"
fi

# eza (better ls)
if ! command_exists eza; then
    cargo install eza 2>/dev/null || print_warning "Failed to install eza via cargo"
fi

# Cleanup
print_info "Cleaning up..."
if command_exists dnf; then
    sudo dnf autoremove -y
    sudo dnf clean all
elif command_exists apt-get; then
    sudo apt-get autoremove -y
    sudo apt-get clean
fi

# Print installed versions
print_info "========================================="
print_info "Installation Complete!"
print_info "========================================="
echo ""
print_info "Installed tool versions:"
echo ""

command_exists git && echo "Git: $(git --version)"
command_exists docker && echo "Docker: $(docker --version)"
command_exists docker && echo "Docker Compose: $(docker compose version)"
command_exists node && echo "Node.js: $(node --version)"
command_exists npm && echo "npm: $(npm --version)"
command_exists python3 && echo "Python: $(python3 --version)"
command_exists pip3 && echo "pip: $(pip3 --version)"
command_exists go && echo "Go: $(go version)"
command_exists rustc && echo "Rust: $(rustc --version)"
command_exists cargo && echo "Cargo: $(cargo --version)"
[ -d "$HOME/.sdkman" ] && source "$HOME/.sdkman/bin/sdkman-init.sh" && command_exists java && echo "Java: $(java -version 2>&1 | head -n 1)"
command_exists nvim && echo "Neovim: $(nvim --version | head -n 1)"
command_exists gh && echo "GitHub CLI: $(gh --version | head -n 1)"
command_exists lazygit && echo "lazygit: $(lazygit --version)"

echo ""
print_warning "========================================="
print_warning "Post-installation steps:"
print_warning "========================================="
print_warning "1. Log out and back in for group changes (Docker) to take effect"
print_warning "2. Run 'source ~/.zshrc' or restart your terminal"
print_warning "3. Configure Git: git config --global user.name 'Your Name'"
print_warning "4. Configure Git: git config --global user.email 'your@email.com'"
print_warning "5. Authenticate GitHub CLI: gh auth login"
print_warning "6. Configure AWS CLI: aws configure (if using AWS)"
print_warning "7. For NVM: source ~/.nvm/nvm.sh (or restart terminal)"
print_warning "8. For SDKMAN: source ~/.sdkman/bin/sdkman-init.sh (or restart terminal)"
print_warning "9. For Rust: source ~/.cargo/env (or restart terminal)"
echo ""

print_info "Happy coding! 🚀"

