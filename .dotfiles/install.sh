#!/bin/sh

echo "Setting up your Mac..."

echo "Creating an SSH key for you..."
ssh-keygen -t rsa

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

echo "Installing xcode-stuff"
xcode-select --install

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

echo "Git config setting up"

git config --global user.name "Josh Harris"
git config --global user.email joshua.harris1085@gmail.com

# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/Workspace
mkdir $HOME/Code

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "Setting up Oh My Zsh theme..."
cd  /Users/josh/.oh-my-zsh/themes
curl https://github.com/sindresorhus/iterm2-snazzy/blob/master/Snazzy.itermcolors > snazzy.zsh-theme
cd

echo "Setting up Zsh plugins..."
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
echo "fpath+=$HOME/.zsh/pure" >> $HOME/.zshrc
source ~/.zshrc
autoload -U promptinit; promptinit
prompt pure

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Symlink editorconfig file to the home directory
ln -s $HOME/.dotfiles/.editorconfig $HOME/.editorconfig

# Set macOS preferences
# We will run this last because this will reload the shell
source $HOME/.dotfiles/.macos
