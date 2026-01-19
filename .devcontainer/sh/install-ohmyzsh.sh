#!/bin/zsh

# oh-my-zsh install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# plugin install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sh -c "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-\"$HOME/.oh-my-zsh/custom\"}/plugins/zsh-autosuggestions && git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-\"$HOME/.oh-my-zsh/custom\"}/plugins/zsh-syntax-highlighting && git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-\"$HOME/.oh-my-zsh/custom\"}/plugins/zsh-completions && sed -i 's/plugins=(git)/plugins=(git aliases copypath history docker github composer brew zsh-completions zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc"
