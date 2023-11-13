#!/bin/bash

sudo apt-get update

# Install core tooling if not already installed
if [ ! -x "$(command -v zsh)" ]; then    
    sudo apt-get install -y zsh tree htop 
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Change the default shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)"
fi

# Copy the default Oh My Zsh configuration file
# if [ ! -f "$HOME/.zshrc" ]; then
#     cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
# fi

# Check if Starship is not installed
if [ ! -x "$(command -v starship)" ]; then
    # Install Starship
    sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

    # Add the following line to your shell profile file (e.g., .bashrc, .zshrc)
    echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"    # For Zsh
fi


# Get virtualenv readiness
python3 -m venv --version ||  sudo apt-get install -y python3-venv


# Install neuron index for Inf/Trn instances
# See more at https://awsdocs-neuron.readthedocs-hosted.com/en/latest/frameworks/torch/index.html
if [ ! -x "$(command -v neuron-top)" ]; then    
    python -m pip config set global.extra-index-url https://pip.repos.neuron.amazonaws.com
fi


# Install AWS CLI V2
if [ ! -d "/usr/local/aws-cli/v2/" ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
else 
    echo "AWS CLI already updated to V2"
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

# Install AIML working directory
if [ ! -d "$HOME/aws_aiml_examples" ]; then
    git config --global user.name "Moca Guero"
    git config --global user.email "411543+moca@users.noreply.github.com"
    git clone https://github.com/moca/aws_aiml_examples ~/aws_aiml_examples
fi

echo '[ -x "$(command -v zsh)" ] && exec zsh || echo "zsh not found, continuing with bash"' >> ~/.bashrc