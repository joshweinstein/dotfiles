" Use comma as leader
let mapleader = ","

" Use jj to switch to normal mode
:inoremap jj <esc>

" Use Pathogen to manage plugins
call pathogen#infect()

""
"" Basic Setup
""
set nocompatible      " Use vim, no vi defaults
set number            " Show line numbers
set ruler             " Show line and column number
syntax enable         " Turn on syntax highlighting allowing local overrides
set encoding=utf-8    " Set default encoding to UTF-8

""
"" Whitespace
""
set nowrap                        " don't wrap lines
set tabstop=4                     " a tab is two spaces
set shiftwidth=4                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set backspace=indent,eol,start    " backspace through everything in insert mode
set showcmd                       " show length of visual selection @ bottom of screen

" Delete trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Use the same symbols as TextMate for tabstops and EOLs
set list listchars=tab:▸\ ,eol:¬

" Hide invisibles by default
set list!

""
"" Searching
""

set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

"Textmate indentation shortcuts
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

"Mappings for moving between window splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Open vertical splits to the right
set splitright

""
"" File types
""
" Some file types should wrap their text
function! s:setupWrapping()
  set wrap
  set linebreak
  set textwidth=72
  set nolist
endfunction

filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make set noexpandtab

  " Set the Ruby filetype for a number of common Ruby files without .rb
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,config.ru,*.rake} set ft=ruby

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Syntax highlighting for handlebars templates using handlebars.vim
  au BufRead,BufNewFile *.handlebars,*.hbs set ft=handlebars

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  " Add spell checking and automatic wrapping at 72 columns to commit messages
  autocmd Filetype gitcommit setlocal spell textwidth=72
endif

" Minitest syntax highlighting and i_CTRL-X_CTRL-U autocompletion
set completefunc=syntaxcomplete#Complete

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Map ,e and ,v to edit or view files in same directory as current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

"
" CtrlP Mappings
"
" Open files with <leader>f
map <leader>f :CtrlP<cr>
" Open files, limited to the directory of the current file, with <leader>gf
" This requires the %% mapping found above.
map <leader>gf :CtrlP %%<cr>
" Rails-style mappings
map <leader>gm :CtrlP app/models<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gr :CtrlP app/repositories<cr>
map <leader>ge :CtrlP app/serializers<cr>
map <leader>gl :CtrlP app/validators<cr>
map <leader>gv :CtrlP app/views<cr>
map <leader>gy :CtrlP app/assets/stylesheets<cr>
map <leader>ga :CtrlP app/argmaps<cr>
map <leader>gs :CtrlP spec<cr>
map <leader>gj :CtrlP app/assets/javascripts<cr>
map <leader>gjm :CtrlP app/assets/javascripts/models<cr>
map <leader>gjc :CtrlP app/assets/javascripts/collections<cr>
map <leader>gjv :CtrlP app/assets/javascripts/views<cr>
map <leader>gjt :CtrlP app/assets/javascripts/templates<cr>
map <leader>gjd :CtrlP app/assets/javascripts/commands<cr>
map <leader>gjs :CtrlP spec/javascripts/spec<cr>

"
" Functions
"
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

function! RunCurrentTest()
    " Write test file, then execute it.
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    let path_to_current_file = expand('%')
    let is_ruby_spec = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if is_ruby_spec
      exec '!zeus test ' . path_to_current_file
    else
      exec "!ruby spec/javascripts/support/compile_assets_and_run_test.rb %"
    end
endfunction
map <leader>T :call RunCurrentTest()<cr>

function! RunCurrentTestAsync()
    " Write test file, then execute it.
    :w
    let path_to_current_file = expand('%')
    let is_ruby_spec = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if is_ruby_spec
      :!echo "zeus test %" > test-commands
    else
      :!echo "ruby spec/javascripts/support/compile_assets_and_run_test.rb %" > test-commands
    end
endfunction
map <leader>t :call RunCurrentTestAsync()<cr><cr>

" re-set shell so that the function above executes with rvm ruby, not system
set shell=/bin/sh

"
" Colors
"
"Use 256 colors
set t_Co=256
colorscheme tir_black

" Supposed to speed up vim within tmux
set notimeout
set ttimeout
set timeoutlen=50

""
"" Mappings
""
" Press S to replace word under cursor with last yanked or deleted text
nnoremap S diw"0P"

" Toggle invisible characters
nmap <leader>l :set list!<cr>

""
"" Wild settings
""
" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

" Ignore jasmine-headless-webkit cache
set wildignore+=.jhw-cache

""
"" Backup and swap files
""
set backupdir=~/.vim/_backup//    " where to put backup files.
set directory=~/.vim/_temp//      " where to put swap files.

""
"" Folding
""
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1

""
"" Plug-In Config
""
" Ctrlp
let g:ctrlp_custom_ignore = {
    \ 'dir':  'public\/assets-test\|tmp'
    \}

"
" Ack.vim
"
let g:ackprg="ack -H --nocolor --nogroup --column --ignore-dir=public/assets"

" Vim Gutter
highlight clear SignColumn

" JSHint
let jshint2_save = 1
