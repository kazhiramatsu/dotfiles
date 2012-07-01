set nocompatible
set number
set expandtab
set shiftround
set autoindent
set backspace=indent,eol,start
set hidden
set history=50
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set nobackup
set ruler
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set tabstop=2
set wrapscan
filetype off 
set updatetime=500
"set encoding=utf-8
"set fileencoding=utf-8
"set fileencodings=utf-8,euc-jp,iso-2022-jp,utf-8,ucs-2le,ucs-2,cp932 
set ambw=double
set t_Co=256
set visualbell t_vb=
 
set makeprg=/usr/local/php/bin/php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l

let g:unite_enable_start_insert = 1
"nnoremap <silent> <Space>f :UniteWithCurrentDir buffer file_mru file<CR>
"nnoremap <silent> <Space>b :UniteWithBuffer buffer file_mru file<CR>
nnoremap <silent> <Space>f :Unite file_mru<CR>
"nnoremap <silent> <Space>b :Unite buffer<CR>
"nnoremap <silent> <Space>bk :Unite bookmark<CR>
"nnoremap <silent> <Space>f :UniteWithInput file<CR>
nnoremap <silent> <Space>d :UniteWithInputDirectory file<CR>
"nnoremap <silent> <Space>v :VimShell<CR>

nmap <silent> <Space>v <Plug>(vimshell_create)

nnoremap <silent> <C-p> :bprevious<CR>
nnoremap <silent> <C-n> :bnext<CR>

"autocmd FileType javascript inoremap <buffer> <expr> -> smartchr#one_of('function', '->')
autocmd FileType perl inoremap <expr> = smartchr#one_of(' = ', ' => ', ' == ')

let g:surround_no_mappings = 1
autocmd FileType * call s:define_surround_keymappings()

function! s:define_surround_keymappings()
    if !&modifiable
        return
    endif

    nmap <buffer> ds <Plug>Dsurround
    nmap <buffer> cs <Plug>Csurround
    nmap <buffer> ys <Plug>Ysurround
    nmap <buffer> yS <Plug>YSurround
    nmap <buffer> yss <Plug>Yssurround
    nmap <buffer> ySs <Plug>YSsurround
    nmap <buffer> ySS <Plug>YSsurround
endfunction

nmap gcc <Plug>(caw:i:toggle)
xmap gcc <Plug>(caw:i:toggle)

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" snippets expand key
imap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)
smap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)

let g:neocomplcache_enable_at_startup = 1
let g:unite_source_grep_default_opts = '-iRHn'

"let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_disable_escape_highlight = 1
let g:vimshell_split_command = 'edit' 

nnoremap <silent> <Space>g :Unite grep:%:<CR>

nnoremap <silent> <Space>v  :VimFiler -buffer-name=explorer -split -winwidth=45 -toggle -no-quit<Cr>
autocmd! FileType vimfiler call g:my_vimfiler_settings()
function! g:my_vimfiler_settings()
  nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
  nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
  nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
endfunction

let my_action = { 'is_selectable' : 1 }
function! my_action.func(candidates)
  wincmd p
  exec 'split '. a:candidates[0].action__path
endfunction


let my_action = { 'is_selectable' : 1 }                     
function! my_action.func(candidates)
  wincmd p
  exec 'vsplit '. a:candidates[0].action__path
endfunction

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

call unite#custom_action('file', 'my_split', my_action)
call unite#custom_action('file', 'my_vsplit', my_action)

filetype plugin indent on
syntax on
colorscheme wombat256mod
