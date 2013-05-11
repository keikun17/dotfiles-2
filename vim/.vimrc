"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       General VIM settings                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use ! on function and command definitions to suppress warning
" on reload.
"
" This will automatically reload the vimfile on save.
" You can force it by doing :source % on the buffer that has this file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't emulate vi bugs
set nocompatible

"""""""""""""""""""""""""""""""""""""""""""""""
"                  VUNDLE                     "
"""""""""""""""""""""""""""""""""""""""""""""""
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

"""""""""""
" Plugins "
"""""""""""

" Textmate-styled snippets
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/vim-snippets"
" ^^^ snipmate dependencies ^^^ "
Bundle 'garbas/vim-snipmate'

" File finding
Bundle 'kien/ctrlp.vim'

" Paren, quotes, bracket editing
Bundle 'tpope/vim-surround'

" Autocomplete
Bundle 'Valloric/YouCompleteMe'

" Theme
Bundle 'altercation/vim-colors-solarized'

" AutoSave
Bundle 'vim-auto-save'

"""""""""""""
" Languages "
"""""""""""""

" Markdown
Bundle 'plasticboy/vim-markdown'

" Mustache
Bundle 'juvenn/mustache.vim'

" Google Go
Bundle 'nsf/gocode'

" Clojure
Bundle 'git://github.com/vim-scripts/paredit.vim.git'
Bundle 'vim-scripts/VimClojure'
Bundle 'jpalardy/vim-slime'

" Python
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'klen/python-mode'
Bundle 'saltstack/salt-vim'

" Javascript
Bundle 'pangloss/vim-javascript'

" Ruby
Bundle 'tpope/vim-rvm'

" Objective-C
Bundle 'git://github.com/msanders/cocoa.vim.git'


filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""
"               KEY BINDINGS                  "
"""""""""""""""""""""""""""""""""""""""""""""""

" Special key for custom bindings
let mapleader = ","
let g:mapleader = ","

" fast editing of vimrc file
" ,v => edits current file
map <leader>v :e ~/.vimrc<CR>

" jump to previous buffer
noremap <leader><leader> <c-^>
map <c-c> <esc>

" Emacs keys for navigation
" Command Line
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <c-bs> <c-w>
" Normal, Visual modes
"noremap <c-a> ^
"noremap <c-e> $
noremap <c-f> l
noremap <c-b> h
noremap <c-p> k
noremap <c-n> j
noremap <c-k> D
" Insert mode
inoremap <c-f> <esc>la
inoremap <c-b> <esc>ha
inoremap <c-k> <esc>Da
"noremap <c-a> <esc>^i
inoremap <c-e> <esc>$a
inoremap <c-bs> <c-w>

" Suppress all whitespace at end of lines when saving
noremap <leader>w :%s/\s\+$//e<cr>:w<cr>

" tab-navigation
noremap <c-h> gT
noremap <c-l> gt
noremap <c-t> :tabnew<cr>
noremap <c-c> :tabclose<cr>

" disable highlighting when hitting the return or esc key
nnoremap <CR> :nohlsearch<cr><cr>
"nnoremap <Esc> :nohlsearch<Esc>

" Type %/ or %? in command line to expand out to current buffer's file location
" (if it exists)
if has('unix')
    cnoremap %/ <C-R>=expand("%:h") . "/" <CR>
    cnoremap %? <C-R>=expand("%:h") . "/" <CR>
    cnoremap %% <C-R>=expand("%:h") . "/" <CR>
else
    cnoremap %/ <C-R>=expand("%:h") . "\\" <CR>
    cnoremap %? <C-R>=expand("%:h") . "\\" <CR>
    cnoremap %% <C-R>=expand("%:h") . "\\" <CR>
endif

" Smart tabbing behavior
function! CleverTab()
    if pumvisible()
        return "\<C-N>"
    endif
    let line_to_cursor = strpart( getline('.'), 0, col('.')-1 )
    if strlen( line_to_cursor ) == 0
        return "\<Tab>"
    elseif line_to_cursor =~ '\s\s*$'
        return "\<Tab>"
    elseif line_to_cursor =~ '/$'
        return "\<C-X>\<C-F>"
    elseif exists('&omnifunc') && &omnifunc != ''
        return "\<C-X>\<C-O>"
    else
        return "\<C-N>"
    endif
endfunction
inoremap <tab> <c-r>=CleverTab()<CR>
inoremap <s-tab> <C-p>

" Duplicate current line
noremap Y <esc>yyp

"""""""""""""""""""""""""""""""""""""""""""""""
"                CORE CONFIG                  "
"""""""""""""""""""""""""""""""""""""""""""""""

set clipboard=unnamed  " System-like clipboard behavior

set tags=./.tags;$HOME " Search path for ctags

set notimeout          " Don't wait for timeout between command combinations

set nowrap             " no line wrapping
set textwidth=0        " width of document
set formatoptions-=t   " don't automatically wrap text when typing

set switchbuf="usetab" " buffer switching behavior - use tab or window if available

set showmatch          " show paren matching

set scrolloff=3        " Keep more context when scrolling off the end of a buffer
set so=7               " move 7 lines when moving vertical
set magic              " Set for regular expressions' backslashes

" visualize invisible characters. Show spaces at the end of lines and tabs.
set list
set listchars=tab:\|\ ,trail:·,

set foldmethod=syntax  " code folding is determined by syntax
set foldlevelstart=20  " default fold level


""""""""""
" Search "
""""""""""

set hlsearch   " highlight search results
set incsearch  " incremental search
set ignorecase " that's case insensitive
set smartcase  " unless you type a capital letter
set wrapscan   " and the search wraps around the file

" make tab completion for files/buffers act like bash, but ignore sets of files
set wildignore=*.o,*.obj,*/.git/*,.svn,.cvs,*.rbc,*.pyc,*.class,*.jar
set wildignore+=*/build/*
set wildignore+=*/dist/*
set wildignore+=*/.ropeproject/*
set wildmode=longest:full:list
set wildmenu

" where <C-P> should get it's completion list
" . => current buffer
" w => buffers from other windows
" b => loaded buffers in buffer list
" u => unloaded buffers in buffer list (can be unreliable)
" U => buffers not in buffer list (can be unreliable)
" k => dictionary
" kspell => spell checking
" s => thesaurus
" i => scan current & included files
" d => scan current & included files for defined name or macro
" ] => tag completion
" t => alias for ]
set complete=.,w,b,t,d,i,t

" menu => Show menu when multiple autocomplete items are available
" preview => Show extra info about the currently selected completion in menu
" menuone => Shows menu when only one item is available for autocomplete
" longest => Only inserts longest common text for matches
set completeopt=menu,preview

set noinfercase  " autocomplete without being case sensitive


""""""""""""""""""""""""
" Files, Backups, Undo "
""""""""""""""""""""""""

set ffs=unix,dos,mac " default line endings

set history=600      " command line history
set undolevels=9000  " undo history

" auto reload vimrc when edited
autocmd! bufwritepost .vimrc source ~/.vimrc

" vim's backup / swap system
set backupdir=~/.vim/tmp/,~/.tmp,/var/tmp,/tmp
set directory=~/.vim/tmp/,~/.tmp,/var/tmp,/tmp
" disable all swap, backup and writebackups
set nobackup     " no backups
set writebackup  " except when writing files
set noswapfile   " no swapfiles

" Persistent undo
try
    if has('win32')
        set undodir=C:\Windows\Temp
    else
        set undodir=/tmp/vim_undodir
    endif
    set undofile
catch
endtry

set autoread                   " auto refresh files that were changed
set virtualedit=all            " let cursor stray beyond textfile bounds
set backspace=eol,indent,start " backspace behaves like normal programs

" Auto save buffers when focus is lost
au FocusLost * silent! :wa
" Auto save when switching buffers
set autowrite
" remember marks & undos for background buffers
set hidden

set number " enable line numbers
"set numberwidth=5

" Set encoding and language
set encoding=utf8
try
    lang en_US
catch
endtry

" Use templates when creating new files of same extensions
augroup templates
    au!
    autocmd BufNewFile *.* silent! execute '0r ~/.vim/skel/tmpl.'.expand('<afile>:e')
    autocmd BufNewFile * %substitute#\[:EVAL:\]\(.\{-\}\)\[:END:\]#\=eval(submatch(1))#ge
    autocmd BufNewFile * silent! foldopen!
augroup END
" but make sure a buffer with the template file isn't opened
set cpoptions-=a


"""""""
" GUI "
"""""""

" Customized titlebar, filename with 3 parent directories
auto BufEnter * let &titlestring=expand("%:p:h:h:h:t") . "/" . expand("%:p:h:h:t") . "/" . expand("%:p:h:t") . "/" . expand("%:p:t") . " - Vim"

" Always show status bar
set laststatus=2

" stylize the cursor in different modes
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=i:blinkon0


" Command bar height
set cmdheight=1

" No sound on errors or visual bells
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set lazyredraw      " don't redraw when running macros
set shortmess=aOstT " shortens messages to avoid 'press a key' prompt

" show matching parens, brackets and braces
set showmatch
set matchtime=1

" Display cursor location info in the bottom right of status bar
set ruler

if has("gui_running")
    " disable toolbar & scrollbars
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r

    set nospell

    set guifont=Inconsolata-dz:h14
    if has('win32')
        " alt key jumps to menu
        set winaltkeys=menu
    end
    if has('macunix')
        set transparency=5
    end
endif

" make active window larger
set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=5
set winminheight=5
set winheight=999

" highlight the line the cursor is on (can be slow for large files)
set cursorline

"""""""""
" Theme "
"""""""""
colorscheme jellybeans
"colorscheme twilight

" for twilight Colors
if has('gui_running')
    highlight CursorLine   guibg=#292929
    highlight StatusLine   guifg=Grey   guibg=NONE
    highlight StatusLineNC guifg=Grey10   guibg=Grey50
    " guibg=NONE so we get the nice transparency stuff
    highlight LineNr       guifg=Grey30   guibg=NONE
    highlight Search                      guibg=NONE     gui=underline
else
    highlight LineNr       ctermfg=DarkGrey    ctermbg=None
    highlight StatusLine   ctermfg=Grey        ctermbg=Black
    highlight StatusLineNC ctermfg=DarkGrey    ctermbg=Black
    highlight VertSplit    ctermfg=Black       ctermbg=Black
    highlight Pmenu        ctermfg=White       ctermbg=DarkGrey
    highlight PmenuSbar                        ctermbg=Yellow
    highlight PmenuThumb                       ctermbg=Black
    highlight PmenuSel     ctermfg=Black       ctermbg=Yellow
    highlight Search       ctermfg=None        ctermbg=NONE      cterm=underline
endif

"""""""""""""""""""""""""""""""""""""""""""""""
"        CUSTOM FUNCTIONS / COMMANDS          "
"""""""""""""""""""""""""""""""""""""""""""""""
command! ConvertTabsToSpaces :set expandtab|retab
command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
command! ConvertSpacesToTab :'<,'>SuperRetab 4
command! ConvertToUTF8 :set encoding=utf-8 fileencodings=.


"""""""""""""""""""""""""""""""""""""""""""""""
"                LANG CONFIG                  "
"""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""
" Defaults "
""""""""""""
set expandtab          " use spaces for tab key
set autoindent         " automatically detect how to indent
set smarttab           " be smart to how much to indent
set smartindent        " be smart for indenting a new line
set shiftround         " round indent to multiple of shiftwidth

set shiftwidth=4       " indent amounts
set tabstop=4          " how long a tab is represented
set softtabstop=4      " how many spaces a tab is (with expandtab)

augroup language_customizations
    " clear old defs
    autocmd!
    autocmd FileType ruby,haml,eruby,html,javascript,sass setlocal autoindent
    autocmd FileType ruby,haml,eruby,html,javascript,sass setlocal expandtab
    autocmd FileType ruby,haml,eruby,html,javascript,sass setlocal tabstop=2
    autocmd FileType ruby,haml,eruby,html,javascript,sass setlocal softtabstop=2

    autocmd FileType python setlocal expandtab
    autocmd FileType python setlocal tabstop=4 softtabstop=4
    " cindent instead of smartindent to not force hashes going to beginning of line
    " for python comments, that's annoying
    autocmd FileType python setlocal smartindent

    autocmd FileType go setlocal tabstop=4 softtabstop=4

    autocmd FileType html setlocal tabstop=2
    autocmd FileType html setlocal shiftwidth=2
    autocmd FileType html setlocal noexpandtab

    autocmd FileType clojure set lisp

    " make requires tabs
    autocmd FileType make setlocal noexpandtab
    autocmd FileType make setlocal nosmartindent

    autocmd FileType php setlocal noexpandtab
    autocmd FileType php setlocal foldmethod=indent

augroup END

"""""""""""""""""""""""""""""""""""""""""""""""
"              PLUGIN CONFIG                  "
"""""""""""""""""""""""""""""""""""""""""""""""

""""""""""
" Python "
""""""""""
let python_highlight_all = 1
let python_slow_sync = 1
let python_highlight_builtin_objs = 1
let python_highlight_builtin_funcs = 1
let g:pymode_lint_write = 0
let g:pymode_rope = 1
let g:pymode_rope_auto_project = 1

"""""""""""
" Clojure "
"""""""""""
let g:vimclojure#HighlightBuiltins=1
let g:vimclojure#ParenRainbow=1
let g:vimclojure#FuzzyIndent=1
let g:vimclojure#DynamicHighlighting=1

" HighlightBuiltins doesn't work....
autocmd Filetype clojure highlight link ClojureSpecial Define
filetype plugin indent on
syntax enable

"""""""""
" CtrlP "
"""""""""
let g:ctrlp_map = '<leader>f'
let g:ctrlp_cmd = 'CtrlP' " 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'


"""""""""""""""
" vim-clojure "
"""""""""""""""
let vimclojure#WantNailgun = 1

"""""""""""""""""
" vim-auto-save "
"""""""""""""""""
let g:auto_save = 1 " enable

