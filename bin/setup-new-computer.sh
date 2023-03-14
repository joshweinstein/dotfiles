# install basics
brew install git zsh ack rbenv vim

# write shims for .bashrc, .zshrc, .vimrc in home dir
echo "source ~/bin/dotfiles/vimrc" > .vimrc
echo "source ~/bin/dotfiles/bashrc" > .bashrc
echo "source ~/bin/dotfiles/zshrc" > .zshrc

# make these directories to stop Press Enter behavior
mkdir -p ~/.vim/_backup
mkdir -p ~/.vim/_tmp
mkdir -p ~/.vim/pack/plugins/start

# install vim plugins
git clone https://github.com/ctrlpvim/ctrlp.vim.git .vim/pack/plugins/start/
git clone https://github.com/mileszs/ack.vim.git .vim/pack/plugins/start/
git clone https://github.com/tpope/vim-fugitive.git .vim/pack/plugins/start/
git clone https://github.com/airblade/vim-gitgutter.git .vim/pack/plugins/start/
git clone https://github.com/tpope/vim-rhubarb.git .vim/pack/plugins/start/

# from ~/.vim, link in vim directories
cd ~/.vim
ln -sfn ~/bin/dotfiles/vim/colors colors
ln -sfn ~/bin/dotfiles/vim/ftdetect ftdetect
ln -sfn ~/bin/dotfiles/vim/ftplugin ftplugin
ln -sfn ~/bin/dotfiles/vim/indent indent
ln -sfn ~/bin/dotfiles/vim/syntax syntax
