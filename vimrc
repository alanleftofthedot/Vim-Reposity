"call pathogen#runtime_prepend_subdirectories(expand('~/.vimbundles'))

" Load up pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set background=dark             " Default to a dark background for themes
set ts=4 sts=4 sw=4 expandtab   " 4 tab spaces
"set softtabstop == shiftwidth
set history=50		            " keep 50 lines of command line history
set ruler		                " show the cursor position all the time
set smartcase                   " be smart about case for search
set hlsearch                    " highlight search terms
syntax on                       " syntax is on all the time
set nowrap                      " don't wrap lines
set backspace=indent,eol,start  " allow backspaceing over everything in insert mode
set autoindent                  " auto-indent lines
set shiftround                  " use multiple of shiftwidth when indenting with < and > 
set smarttab                    " insert tabs according to shiftwidth not tabstop
set undolevels=1000             " lots of undo
set wildignore=*.swp,*.bak,*.pyc,*.class 
set title                       " change the terminal's title
set visualbell                  " don't beep
set noerrorbells                " don't beep

filetype plugin indent on
autocmd filetype python set expandtab

if has("autocmd")
 " Enabled file type detection
 " Use the default filetype settings. If you also want to load indent files
 " to automatically do language-dependent indenting add 'indent' as well.
    filetype plugin on
    set showcmd		    " Show (partial) command in status line.
    set showmatch		" Show matching brackets.
    set ignorecase		" Do case insensitive matching
    set smartindent

endif " has ("autocmd")

" Enable the nifty syntax and colorscheme
if &t_Co >= 256 || has("gui_running")
    colorscheme solarized
endif

if &t_Co > 2 || has("gui_running")
" switch syntax highlighting on, when the terminal has colors
    syntax on
endif

if has('gui_running')
    set background=light
else
    set background=dark
endif

" set the leader to , from \
let mapleader=","

" load up the man page function "Man"
runtime ftplugin/man.vim

" set up tab completion of keywords while in insert mode
function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>

" misc options

" mapping for the winexplorer
map <c-w><c-f> :FirstExplorerWindow<cr>
map <c-w><c-b> :BottomExplorerWindow<cr>
map <c-w><c-t> :WMToggle<cr>

" map F3 to auto-rot13
" map <F3> ggg?G

" switch quickly from window to window and maximize the window with ^j and ^k
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_ 
" set this to allow minimum window height to be 0 instead of 1
" set wmh=0

" auto close for xml/html tags (^_)
au Filetype html,xml,xsl source ~/.vim/plugin/closetag.vim

" toggle highlight under cursor (^h)
function VIMRCWhere()
    if !exists("s:highlightcursor")
        match Todo /\k*\%#\k*/
        let s:highlightcursor=1
    else
        match None
        unlet s:highlightcursor
    endif
endfunction
map <C-H> :call VIMRCWhere()<CR> 

" toggle text html display
" (http://vim.sourceforge.net/tips/tip.php?tip_id=127)
function PreviewHTML_TextOnly()
	let l:fname = expand("%:p" )
	new
	set buftype=nofile nonumber
	exe "%!links " . l:fname . " -dump "
endfunction

map <Leader>pt  :call PreviewHTML_TextOnly()<CR>

" and the external version
function PreviewHTML_External()
	exe "silent !mozilla -remote \"openurl(file://"; . expand( "%:p" ) . ")\""
endfunction 

map <Leader>pp :call PreviewHTML_External()<CR> 

" map f !perl -MText::Autoformat -e'autoformat'

augroup filetype
	au!
	au! BufRead,BufNewFile *.html 	set syntax=mason
	au! BufRead,BufNewFile *.htm 	set syntax=mason
	au! BufRead,BufNewFile *.mc 	set syntax=mason
	au! BufRead,BufNewFile autohandler 	set syntax=mason
	au! BufRead,BufNewFile dhandler 	set syntax=mason
augroup END

"set spell
set spellfile=~/.vim/spell-en.add

" prevent it from unindenting #
set cinkeys-=0#
set indentkeys-=0#
inoremap # X<BS>#

" apply tabs
" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction
 
function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" NerdTree plugin
map <leader>e :execute 'NERDTreeToggle ' . getcwd()<CR>
"map <leader>e :NERDTreeToggle<CR>

"minibufexpl options
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1

"showMarks options
"let g:showmarks_enable=0


" quickly edit/reload vimrc file
"nmap <silent> <leader>ev :e $MYVIMRC<CR>
"nmap <silent> <leader>sv :so $MYVIMRC<CR>

" list whitespace nicely
"set list
"set listchars=tab:>.,trail:.,extends:#,nbsp:.

" dont' show the tabs in html and xml docs
"autocmd filetype html,xml set listchars-=tab:>.

" set paste be f2
set pastetoggle=<F2>

" Reformat paragraph toggle
vmap Q gq
nmap Q gqap

" nicer clear of highlight searches
nmap <silent> ,/ :nohlsearch<CR>

" Map W!! to run a sudo vi
" cmap w!! w !sudo tee % >/dev/null

" Play nice with the solarized scheme
"colorscheme solarized
"let g:solaraized_termcoors=256
