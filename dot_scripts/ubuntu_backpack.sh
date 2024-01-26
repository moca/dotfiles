#!/bin/bash

sudo apt-get update

# Install core tooling if not already installed
if [ ! -x "$(command -v zsh)" ]; then
    sudo apt install -y zsh tree htop bat
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Change the default shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)"
fi

# Make sure zsh is executed when opening a new terminal session with bash
EXEC_ZSH='[ -x "$(command -v zsh)" ] && exec zsh || echo "zsh not found, continuing with bash"'
if ! grep -Fxq "$EXEC_ZSH" ~/.bashrc; then
    echo "$EXEC_ZSH" >> ~/.bashrc
fi


# Install starship prompt engine
if [ ! -x "$(command -v starship)" ]; then
    sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
    # Add the following line to your shell profile file (e.g., .bashrc, .zshrc)
    echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"    # For Zsh
fi


# Get virtualenv readiness
if [ ! -x "$(command -v virtualenv)" ]; then
    sudo apt-get install -y python3-venv
fi


# Install AWS CLI V2
if [ ! -d "/usr/local/aws-cli/v2/" ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip

    # Make s3 commands blazing fast
    # See more at https://aws.amazon.com/blogs/storage/improving-amazon-s3-throughput-for-the-aws-cli-and-boto3-with-the-aws-common-runtime/
    aws configure set s3.preferred_transfer_client crt
else 
    echo "AWS CLI already updated to V2"
fi


# Install neuron index for Inf/Trn instances
# See more at https://awsdocs-neuron.readthedocs-hosted.com/en/latest/frameworks/torch/index.html
if [ ! -x "$(command -v neuron-top)" ]; then
    # This index will also work on virtual environments
    python -m pip config set global.extra-index-url https://pip.repos.neuron.amazonaws.com
fi


# Install NVtop for GPU monitoring
if [ -x "$(command -v nvidia-smi)" ] && [ ! -x "$(command -v nvtop)" ] ; then
    sudo add-apt-repository ppa:flexiondotorg/nvtop
    sudo apt update
    sudo apt install -y nvtop
    # Prefer to use AMI with drivers installed
    # sudo apt install -y ubuntu-drivers-common
    # sudo ubuntu-drivers install --gpgpu # OR sudo ubuntu-drivers autoinstall
    # sudo apt install -y nvidia-driver-535-server
else
    echo "Nvidia drivers not found. Skipping nvtop installation."
fi


# Install Dust for disk usage analysis
if [ ! -x "$(command -v dust)" ]; then    
    wget https://github.com/bootandy/dust/releases/download/v0.8.6/du-dust_0.8.6_amd64.deb
    sudo dpkg -i du-dust_0.8.6_amd64.deb
    rm du-dust_0.8.6_amd64.deb
fi

# Install Chezmoi
if [ ! -x "$(command -v chezmoi)" ]; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply moca -b $HOME/.local/bin
fi

# Config GIT
git config --global core.excludesfile ~/.gitignore

echo "\n\n ############################"
echo "nOMG! You're ready to go!"
echo "Cloning time at https://github.com/moca/"


