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
export ANDROID_SDK_ROOT="$(brew --prefix)/share/android-sdk"
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"

# Allow aws-sdk to use aws CLI config
export AWS_SDK_LOAD_CONFIG=1

# AWS Session Token
export awssessiontoken() {
  creds=`aws sts get-session-token \
  --duration-seconds=57600 \
  --serial-number={{MFA_IDENTIFIER}} \
  --token-code=$1 | jq -r '.Credentials'`;

  secretAccessKey=$( jq -r  '.SecretAccessKey' <<< "${creds}" );
  sessionToken=$( jq -r  '.SessionToken' <<< "${creds}" );

  echo $accessKeyId;
  echo $secretAccessKey;
  echo $sessionToken;

  export AWS_ACCESS_KEY_ID=$( jq -r  '.AccessKeyId' <<< "${creds}" );
  export AWS_SECRET_ACCESS_KEY=$secretAccessKey;
  export AWS_SESSION_TOKEN=$sessionToken;
}

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

# Add python3 from brew install
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Get brew file install working
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
