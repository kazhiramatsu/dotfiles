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
if $GOROOT != ''
  set rtp+=$GOROOT/misc/vim
endif
set completeopt=menu,preview
set rtp+=${GOPATH}/src/github.com/nsf/gocode/vim

inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

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

"inoremap <C-o> <Esc>

" nmap p <Plug>(yankround-p)
" nmap P <Plug>(yankround-P)
" nmap <C-p> <Plug>(yankround-prev)
" nmap <C-n> <Plug>(yankround-next)

function! s:define_perl_settings()
  inoremap <buffer><expr> = smartchr#one_of(' = ', ' => ', ' == ', '=')
endfunction

nmap <Leader>r <plug>(quickrun)
inoremap <C-d> $
inoremap <C-a> @

let g:unite_enable_start_insert = 0
"nnoremap <silent> <Space>f :UniteWithCurrentDir buffer file_mru file<CR>
"nnoremap <silent> <Space>b :UniteWithBuffer buffer file_mru file<CR>
nnoremap <silent> <Space>f :Unite file_mru<CR>
nnoremap <silent> <Space>b :Unite buffer<CR>
"nnoremap <silent> <Space>bk :Unite bookmark<CR>
"nnoremap <silent> <Space>f :UniteWithInput file<CR>
nnoremap <silent> <Space>d :UniteWithInputDirectory file<CR>
"nnoremap <silent> <Space>v :VimShell<CR>

nnoremap <silent> <Space>r :QuickRun perl<CR>

"let g:unite_source_history_yank_enable = 1
"nnoremap <silent> <Space>p :<C-u>Unite history/yank<CR>

"let g:neosnippet#enable_snipmate_compatibility = 1


" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

nmap gcc <Plug>(caw:i:toggle)
xmap gcc <Plug>(caw:i:toggle)

" snippets expand key

"noremap es :<C-u>NeoComplCacheEditSnippets<CR>

" if executable('ag')
"   " Use ag in unite grep source.
"   let g:unite_source_grep_command = 'ag'
"   let g:unite_source_grep_default_opts = '--nocolor --nogroup --hidden'
"   let g:unite_source_grep_recursive_opt = ''
" elseif executable('ack-grep')
"   " Use ack in unite grep source.
"   let g:unite_source_grep_command = 'ack-grep'
"   let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
"   let g:unite_source_grep_recursive_opt = ''
" endif

" let g:neocomplcache_enable_at_startup = 1
" let g:neocomplcache_enable_smart_case = 1
" let g:neocomplcache_enable_camel_case_completion = 1
" let g:neocomplcache_enable_underbar_completion = 1
" let g:neocomplcache_min_syntax_length = 5

"let g:clang_periodic_quickfix = 1
"let g:clang_complete_copen = 1
"let g:clang_use_library = 1

" this need to be updated on llvm update
"let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'
" specify compiler options
"let g:clang_user_options = '-std=c++11 -stdlib=libc++'
"let g:clang_auto_user_options = '.clang_complete'
"let g:clang_auto_user_options = 'path'

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_force_overwrite_completefunc=1

let g:clang_complete_auto = 0
let g:clang_auto_select = 0

let g:neocomplcache#sources#rsense#home_directory = '/usr/local/Cellar/rsense/0.3'
let g:rsenseHome = "/usr/local/Cellar/rsense/0.3"
"let g:rsenseUseOmniFunc = 1

"Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_omni_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)' 
let g:neocomplcache_omni_patterns.go = '[^.[:digit:] *\t]\%(\.\|->\)'

if !exists('g:neocomplcache#sources#omni#input_patterns')
  let g:neocomplecache#sources#omni#input_patterns = {}
endif
let g:neocomplecache#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplcache_auto_completion_start_length = 3

let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

"let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_disable_escape_highlight = 1
let g:vimshell_split_command = 'edit'

let g:vimfiler_time_format = ''

"nnoremap <silent> <Space>g :Unite grep<CR>


nnoremap <silent> <Space>h :VimShellPop .<CR>
nnoremap <silent> <Space>v :VimFilerCurrentDir -buffer-name=explorer -split -winwidth=40 -toggle -no-quit<Cr>

nnoremap <silent> <Space>g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" カーソル位置の単語をgrep検索
nnoremap <silent> <Space>cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
nnoremap <silent> <Space>r :<C-u>UniteResume search-buffer<CR>

"
"nmap <silent> <Space>p :YRShow<CR> 

"nnoremap <silent> <Space>p :<C-u>CtrlPYankRound<CR>

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

"let g:unite_source_grep_default_opts = '-iRHn'

call unite#custom_action('file', 'my_split', my_action)
call unite#custom_action('file', 'my_vsplit', my_action)

nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

augroup Omni
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
augroup END

augroup MyVimshell
  autocmd!
  autocmd FileType vimshell
        \       imap <expr> <buffer> <C-n> pumvisible() ? "\<C-n>" : "\<Plug>(vimshell_history_neocomplete)"
augroup END

augroup Go
  autocmd!
  autocmd FileType go compiler go
augroup END

augroup SmarChar
  autocmd!
  autocmd FileType perl,ruby,javascript call s:define_perl_settings() 
augroup END

filetype plugin indent on
syntax on 
set background=dark
colorscheme molokai

let g:clang_complete_getopts_ios_sdk_directory = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk'
let g:clang_auto_user_options = 'path, .clang_complete, ios'
let g:clang_complete_getopts_ios_default_options = '-w -fblocks -fobjc-arc -D __IPHONE_OS_VERSION_MIN_REQUIRED=40300'
let g:clang_complete_getopts_ios_ignore_directories = ["^\.git", "\.xcodeproj"]
