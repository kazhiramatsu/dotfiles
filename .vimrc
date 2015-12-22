set nocompatible
set number
set expandtab
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
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set tabstop=2
set wrapscan
filetype off 
set updatetime=500
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set ambw=double
set t_Co=256
set visualbell t_vb=
set clipboard+=unnamed
set completeopt=menuone

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

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

function! g:my_vimfiler_settings()
  let g:vimfiler_as_default_explorer = 1
  nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
  nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
  nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
endfunction

augroup VimFiler
  autocmd!
  autocmd! FileType vimfiler call g:my_vimfiler_settings()
augroup END

function! g:my_perl_settings()
  inoremap <buffer> <expr> = smartchr#loop(' = ', ' => ', '=', '==')
  inoremap { {}<Left>
endfunction

function! g:my_c_settings()
  inoremap <buffer> <expr> = smartchr#loop(' = ', ' == ', '=')
endfunction

function! g:my_go_settings()
  inoremap <buffer> <expr> = smartchr#loop(' := ', ' == ', '=')
"  inoremap { {}<Left>
endfunction

augroup SmartChr
  autocmd!
  autocmd! FileType perl call g:my_perl_settings()
  autocmd! FileType c call g:my_c_settings()
  autocmd! FileType go call g:my_go_settings()
augroup END

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

call unite#custom_action('file', 'my_split', my_action)
call unite#custom_action('file', 'my_vsplit', my_action)

nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

call lexima#add_rule({'char': '"', 'input_after': '";', 'filetype': 'perl'})

filetype plugin indent on
syntax on 
set background=dark
colorscheme molokai

