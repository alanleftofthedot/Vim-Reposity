"call pathogen#runtime_prepend_subdirectories(expand('~/.vimbundles'))

set ai
set bg=dark
set ts=4 sts=4 sw=4 expandtab " 4 tab spaces
"set softtabstop == shiftwidth
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set smartcase
set hlsearch
syntax on
if has("autocmd")
 " Enabled file type detection
 " Use the default filetype settings. If you also want to load indent files
 " to automatically do language-dependent indenting add 'indent' as well.
 filetype plugin on
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartindent

endif " has ("autocmd")


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
set nowrap

" mapping for the winexplorer
map <c-w><c-f> :FirstExplorerWindow<cr>
map <c-w><c-b> :BottomExplorerWindow<cr>
map <c-w><c-t> :WMToggle<cr>

" map F3 to auto-rot13
map <F3> ggg?G

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
