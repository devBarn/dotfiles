# /usr/local/bin/zsh
plugins=(git nvm)

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="frisk"

# Load aliases definitions
[[ -s "$HOME/.dotfiles/.aliases" ]] && source "$HOME/.dotfiles/.aliases"

# Load directory jumper Z
[[ -s "$HOME/.dotfiles/.bin/z.sh" ]] && source "$HOME/.dotfiles/.bin/z.sh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Android Tools
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Allow aws-sdk to use aws CLI config
export AWS_SDK_LOAD_CONFIG=1

# AWS Credentials

# Add MySQL to PATH
export PATH=$PATH:/usr/local/mysql-8.0.12-macos10.13-x86_64/bin/

# Add FlyWay to PATH
export PATH="$HOME/flyway-5.2.4/:$PATH"

# Add .dotfiles binaries to PATH
export PATH="$HOME/.dotfiles/.bin/:$PATH"

# Add yarn from brew install
export PATH="/usr/local/Cellar/yarn/1.17.3/bin:$PATH"

# Add ruby from brew install
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

nvmrc_check() {
  if [[ $PWD == $PREV_PWD ]]; then
    return
  fi

  PREV_PWD=$PWD
  if [[ -f ".nvmrc" ]]; then
    nvm use
    NVM_DIRTY=true
  elif [[ $NVM_DIRTY = true ]]; then
      nvm use default
      NVM_DIRTY=false
  fi
}

# Load git prompt script from https://github.com/lyze/posh-git-sh
source ~/.dotfiles/.bin/git-prompt.sh

precmd() {
  nvmrc_check
  __posh_git_ps1 "%D{%f/%m/%y}-%T %c" "‍ 🏉  🤓  🚀  =>"
}
