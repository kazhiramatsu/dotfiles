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
set ambw=double
set t_Co=256
set visualbell t_vb=
set clipboard+=unnamed
set completeopt=menuone

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
endfunction

function! s:my_go_settings()
  inoremap <buffer> <expr> = smartchr#loop(' := ', ' == ', '=')
"  inoremap { {}<Left>
endfunction

augroup SmartChr
  autocmd!
  autocmd! FileType perl call s:my_perl_settings()
  autocmd! FileType c call s:my_c_settings()
  autocmd! FileType go call s:my_go_settings()
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
xnoremap \r :<C-U>write<CR>gv:QuickRun -mode v<CR> 
nnoremap \r :cclose<CR>:write<CR>:QuickRun -mode n<CR>
xnoremap \r :<C-U>cclose<CR>:write<CR>gv:QuickRun -mode v<CR>

au FileType qf nnoremap <silent><buffer>q :quit<CR>

call lexima#add_rule({'at': '\%#)', 'char': '"', 'input_after': '"', 'filetype': 'perl'})
"call lexima#add_rule({'char': '"', 'input_after': '";', 'filetype': 'perl'})
"call lexima#add_rule({'char': '(', 'input_after': ');', 'filetype': 'perl'})

filetype plugin indent on
syntax on 
set background=dark
colorscheme molokai

