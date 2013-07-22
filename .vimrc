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
set shiftwidth=4
set showcmd
set showmatch
set smartcase
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set tabstop=4
set wrapscan
filetype off 
set updatetime=500
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set ambw=double
set t_Co=256
set visualbell t_vb=

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
      set fileencodings-=euc-jp
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

let g:syntastic_enable_signs=0

let g:unite_enable_start_insert = 1
"nnoremap <silent> <Space>f :UniteWithCurrentDir buffer file_mru file<CR>
"nnoremap <silent> <Space>b :UniteWithBuffer buffer file_mru file<CR>
nnoremap <silent> <Space>f :Unite file_mru<CR>
nnoremap <silent> <Space>b :Unite buffer<CR>
"nnoremap <silent> <Space>bk :Unite bookmark<CR>
"nnoremap <silent> <Space>f :UniteWithInput file<CR>
nnoremap <silent> <Space>d :UniteWithInputDirectory file<CR>
"nnoremap <silent> <Space>v :VimShell<CR>

nnoremap <silent> <Space>r :QuickRun perl<CR>

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ?  "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ?  "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

let g:neosnippet#enable_snipmate_compatibility = 1

nnoremap <silent> <C-p> :bprevious<CR>
nnoremap <silent> <C-n> :bnext<CR>

autocmd FileType javascript call s:define_javascript_settings() 
autocmd FileType perl call s:define_perl_settings() 
autocmd FileType perl inoremap <expr> = smartchr#one_of(' = ', ' => ', ' == ')
autocmd FileType html inoremap <expr> = smartchr#one_of('=')
autocmd FileType ruby call s:define_ruby_settings() 
autocmd FileType c call s:define_c_settings()

function! s:define_javascript_settings()
    if !&modifiable
        return
    endif
"    inoremap <expr> = smartchr#one_of(' = ', ' == ', ' === ')
    set tabstop=2
    set shiftwidth=2
endfunction

function! s:define_ruby_settings()
    if !&modifiable
        return
    endif
"    inoremap <expr> = smartchr#one_of(' = ', ' == ', ': ')
    set tabstop=2
    set shiftwidth=2
    set tags+=tags;
    NeoComplCacheCachingTags
endfunction

function! s:define_c_settings()
    if !&modifiable
        return
    endif

    set tabstop=4
    set shiftwidth=4
endfunction

function! s:define_perl_settings()
    if !&modifiable
        return
    endif

    set tabstop=4
    set shiftwidth=4
"    inoremap <expr> = smartchr#one_of(' = ', ' => ', ' == ')
endfunction

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

let g:neocomplcache_enable_at_startup = 1

"noremap es :<C-u>NeoComplCacheEditSnippets<CR>

let g:unite_source_grep_default_opts = '-iRHn'
" let g:neocomplcache_enable_at_startup = 1
" let g:neocomplcache_enable_smart_case = 1
" let g:neocomplcache_enable_camel_case_completion = 1
" let g:neocomplcache_enable_underbar_completion = 1
" let g:neocomplcache_min_syntax_length = 5


"let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_disable_escape_highlight = 1
let g:vimshell_split_command = 'edit'

let g:vimfiler_time_format = ''

"nnoremap <silent> <Space>g :Unite grep:%:<CR>
nnoremap <silent> <Space>h :VimShellPop .<CR>
nnoremap <silent> <Space>v :VimFilerCurrentDir -buffer-name=explorer -split -winwidth=40 -toggle -no-quit<Cr>

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


autocmd! FileType vimfiler call g:my_vimfiler_settings()
function! g:my_vimfiler_settings()
  let g:vimfiler_as_default_explorer = 1
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


call unite#custom_action('file', 'my_split', my_action)
call unite#custom_action('file', 'my_vsplit', my_action)


filetype plugin indent on
syntax on 
colorscheme wombat256mod
