set nocompatible
set number
set shiftround
set autoindent
set backspace=indent,eol,start
set hidden
set history=500
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set nobackup
set noswapfile
set ruler
set shiftwidth=4
set showcmd
set showmatch
set smartcase
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set tabstop=4
set wrapscan
filetype off 
set updatetime=500
set ambw=double
set t_Co=256
set visualbell t_vb=
set clipboard+=unnamed
set completeopt=longest,menuone,preview
set fileencodings=utf-8,euc-jp,cp932,sjis,euc-jp,latin1
set list
set listchars=tab:›\ ,trail:-,extends:»,precedes:«,nbsp:%
set expandtab

inoremap <silent> <Esc> <Esc>
inoremap <silent> <C-[> <Esc>

inoremap <silent> <C-j> <C-^>

if &compatible
  set nocompatible               " Be iMproved
endif

set runtimepath+=/Users/hiramatsu/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('/Users/hiramatsu/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
"NeoBundle 'Shougo/neosnippet.vim'
"NeoBundle 'Shougo/neosnippet-snippets'
"NeoBundle 'Shougo/neocomplete'
" NeoBundle 'ctrlpvim/ctrlp.vim'
" NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
" NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" NeoBundleLazy 'rust-lang/rust.vim'
" NeoBundleLazy 'racer-rust/vim-racer'

" NeoBundleLazy 'OmniSharp/omnisharp-vim', {
"       \   'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] },
"       \   'build': {
"       \     'windows' : 'msbuild server/OmniSharp.sln',
"       \     'mac': 'xbuild server/OmniSharp.sln',
"       \     'unix': 'xbuild server/OmniSharp.sln',
"       \   },
"       \ }
"
" NeoBundle 'tpope/vim-dispatch'
" NeoBundleLazy 'udalov/kotlin-vim'
NeoBundle 'scrooloose/syntastic'
"NeoBundle 'mattn/emmet-vim'

let g:unite_enable_start_insert = 0
let g:unite_source_grep_max_candidates = 100000 

nnoremap <silent> <Space>f :Unite file_mru<CR>
nnoremap <silent> <Space>b :Unite buffer<CR>
nnoremap <silent> <Space>d :UniteWithInputDirectory file<CR>

nmap gcc <Plug>(caw:i:toggle)
xmap gcc <Plug>(caw:i:toggle)

let g:vimfiler_time_format = ''

nnoremap <silent> <Space>v :VimFilerCurrentDir -buffer-name=explorer -split -winwidth=40 -toggle -no-quit<Cr>

nnoremap <silent> <Space>g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" カーソル位置の単語をgrep検索
nnoremap <silent> <Space>cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
nnoremap <silent> <Space>r :<C-u>UniteResume search-buffer<CR>

let g:wildfire_water_map = '<S-Enter>'
let g:wildfire_water_map = "<BS>"
let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it', 'i>']

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

function! s:my_vimfiler_settings()
  let g:vimfiler_as_default_explorer = 1
  nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
  nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
  nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
endfunction

augroup VimFiler
  autocmd!
  autocmd! FileType vimfiler call s:my_vimfiler_settings()
augroup END

function! s:my_perl_settings()
  inoremap <buffer> <expr> = smartchr#loop(' = ', ' => ', '=', '==')
  inoremap <buffer> <expr> - smartchr#loop('->', '-', '--')
  inoremap <buffer> <expr> : smartchr#loop('::', ':')
endfunction

function! s:my_python_settings()
  inoremap <buffer> <expr> = smartchr#loop(' = ', '==')
endfunction

function! s:my_c_settings()
  inoremap <buffer> <expr> = smartchr#loop(' = ', ' == ', '=')
endfunction

function! s:my_go_settings()
  inoremap <buffer> <expr> = smartchr#loop(' := ', ' == ', '=')
  autocmd FileType go setlocal tabstop=4
  autocmd FileType go setlocal shiftwidth=4
"  inoremap { {}<Left>
endfunction

function! s:my_html_settings()
  set tabstop=2
  set shiftwidth=2
endfunction

function! s:my_js_settings()
  set tabstop=2
  set shiftwidth=2
endfunction

augroup SmartChr
  autocmd!
  autocmd! FileType perl call s:my_perl_settings()
  autocmd! FileType c call s:my_c_settings()
  autocmd! FileType go call s:my_go_settings()
  autocmd! FileType javascript call s:my_js_settings()
  autocmd! FileType python call s:my_python_settings()
augroup END

let my_action = { 'is_selectable' : 1 }
function! my_action.func(candidatems)
  wincmd p
  exec 'split '. a:candidates[0].action__path
endfunction

let my_action = { 'is_selectable' : 1 }                     
function! my_action.func(candidates)
  wincmd p
  exec 'vsplit '. a:candidates[0].action__path
endfunction

call unite#custom_action('file', 'my_split', my_action)
call unite#custom_action('file', 'my_vsplit', my_action)

nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)

let g:quickrun_config = {
      \   "_" : {
      \       "outputter/buffer/split" : ":botright",
      \       "outputter/buffer/close_on_empty" : 1,
      \   },
      \}

let g:quickrun_no_default_key_mappings = 1
nnoremap \r :write<CR>:QuickRun -mode n<CR>        
"nnoremap <Leader>q :<C-u>bw! \[quickrun\ output\]<CR>
nnoremap <Leader>q :only<CR>
nnoremap <Leader>s :<C-u>SyntasticReset<CR>

au FileType qf nnoremap <silent><buffer>q :quit<CR>

call lexima#add_rule({'at': '\%#)', 'char': '"', 'input_after': '"', 'filetype': 'perl'})

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'podchecker']
"let g:syntastic_go_checkers = ['go']
"let g:syntastic_perl_lib_path = ['/home/sharetask/sharetask_server/cgi-common/modules', '/home/sharetask/repo/kao/sprdb2/lib']
" let g:syntastic_perl_lib_path = [ './lib', ]
" let g:syntastic_c_include_dirs = [ './include', '../include', '../../include' ]

call neobundle#end()

filetype plugin indent on
syntax on 
set background=dark
colorscheme molokai

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

