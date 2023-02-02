let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'liuchengxu/vista.vim'

call plug#end()

let mapleader=" "

" VIM Plug Status
nnoremap <leader>ps :PlugStatus<CR>

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c', 'cc', 'cpp'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    "setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <leader>gd <plug>(lsp-definition)
    nmap <buffer> <leader>gs <plug>(lsp-document-symbol-search)
    nmap <buffer> <leader>gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> <leader>gr <plug>(lsp-references)
    nmap <buffer> <leader>gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>[g <plug>(lsp-previous-diagnostic)
    nmap <buffer> <leader>]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
inoremap <expr> <C-X> pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"

" Vista Settings
let g:vista_default_executive = 'vim_lsp'
nnoremap <F4> :Vista!!<CR>

" Windows Settings
nnoremap <leader><Bar> :vsplit<CR>
nnoremap <leader>- :split<CR>

nnoremap <leader>nu :set nu<CR>
nnoremap <leader>nn :set nonu<CR>

colorscheme desert
syntax on
hi Pmenu ctermfg=White ctermbg=4 guibg=LightGrey
hi PmenuSel ctermfg=White ctermbg=24 guibg=LightBlue

" go to line start/end
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I

inoremap <C-L> <Right>
inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>

func Backspace()
  if col('.') == 1
    if line('.')  != 1
      call setreg('"', [])
      return  "\<ESC>Dk$p\<S-J>i"
    else
      return ""
    endif
  else
    return "\<Left>\<Del>"
  endif
endfunc

" If backspace not work, use below map
inoremap <c-q> <c-r>=Backspace()<CR>

" go back to last edit line
if has("autocmd")
          autocmd BufReadPost *
              \ if line("'\"") > 0 && line("'\"") <= line("$") |
              \   exe "normal g`\"" |
              \ endif
endif
set incsearch

"ruler format
set rulerformat=%60(%=%f\ \ Ln\ %-l,Col\ %-c\ \ %P%)

"show quickfix immediately after quickfix cmd
augroup quickfix
        autocmd!
        autocmd QuickFixCmdPost [^l]* cwindow
        autocmd QuickFixCmdPost l* lwindow
augroup END

"netrw
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 10
let g:netrw_banner = 0
function! s:close_explorer_buffers()
    for i in range(1, bufnr('$'))
        if getbufvar(i, '&filetype') == "netrw"
            silent exe 'bdelete! ' . i
            return
        endif
    endfor
    silent exe 'Vexplore'
endfunction
nnoremap <F3> :call <sid>close_explorer_buffers()<CR>
