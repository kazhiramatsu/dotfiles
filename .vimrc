set nocompatible
set number
set noexpandtab
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
set fileencodings=utf-8,cp932,sjis,euc-jp,latin1

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=/Users/hiramatsu/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('/Users/hiramatsu/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
" NeoBundle 'Shougo/neosnippet.vim'
" NeoBundle 'Shougo/neosnippet-snippets'
" NeoBundle 'tpope/vim-fugitive'
" NeoBundle 'ctrlpvim/ctrlp.vim'
" NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
" NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }
NeoBundle 'tpope/vim-dispatch'

NeoBundle 'rust-lang/rust.vim'
NeoBundle 'racer-rust/vim-racer'

NeoBundleLazy 'OmniSharp/omnisharp-vim', {
      \   'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] },
      \   'build': {
      \     'windows' : 'msbuild server/OmniSharp.sln',
      \     'mac': 'xbuild server/OmniSharp.sln',
      \     'unix': 'xbuild server/OmniSharp.sln',
      \   },
      \ }


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

function! s:my_c_settings()
  inoremap <buffer> <expr> = smartchr#loop(' = ', ' == ', '=')
  set expandtab
endfunction

function! s:my_go_settings()
  inoremap <buffer> <expr> = smartchr#loop(' := ', ' == ', '=')
  autocmd FileType go setlocal noexpandtab
  autocmd FileType go setlocal tabstop=4
  autocmd FileType go setlocal shiftwidth=4
"  inoremap { {}<Left>
endfunction

function! s:my_html_settings()
  set expandtab
  set tabstop=2
  set shiftwidth=2
endfunction

function! s:my_js_settings()
  set expandtab
  set tabstop=2
  set shiftwidth=2
endfunction

augroup SmartChr
  autocmd!
  autocmd! FileType perl call s:my_perl_settings()
  autocmd! FileType c call s:my_c_settings()
  autocmd! FileType go call s:my_go_settings()
  autocmd! FileType javascript call s:my_js_settings()
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
"call lexima#add_rule({'char': '"', 'input_after': '";', 'filetype': 'perl'})
"call lexima#add_rule({'char': '(', 'input_after': ');', 'filetype': 'perl'})

"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 0

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.go = '\h\w\.\w*'
let g:neocomplete#sources#omni#input_patterns.rs = '\h\w\.\w*'

let g:neocomplete#enable_auto_close_preview = 0

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
"let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/neosnippets'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'podchecker']
" let g:syntastic_perl_lib_path = [ './lib', ]
" let g:syntastic_c_include_dirs = [ './include', '../include', '../../include' ]

let g:OmniSharp_start_server = 0
let g:OmniSharp_selector_ui = 'unite'

autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'

let g:rustfmt_autosave = 1
"let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'

set hidden
"let g:racer_cmd = '/Users/hiramatsu/.vim/bundle/vim-racer/racer/target/release/racer'
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_functions = 1
let g:go_highlight_build_constraints = 1

call neobundle#end()

filetype plugin indent on
syntax on 
set background=dark
colorscheme molokai

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

