if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  autocmd BufRead,BufNewFile *.t setlocal ft=perl tabstop=4 shiftwidth=4
  autocmd BufRead,BufNewFile *.tx setlocal ft=html tabstop=2 shiftwidth=2
  autocmd BufRead,BufNewFile *.y setlocal ft=c tabstop=2 shiftwidth=2
  autocmd BufRead,BufNewFile *.psgi setlocal ft=perl tabstop=4 shiftwidth=4
  autocmd BufRead,BufNewFile *.pl setlocal ft=perl tabstop=4 shiftwidth=4
  autocmd BufRead,BufNewFile *.pm setlocal ft=perl tabstop=4 shiftwidth=4
  autocmd BufRead,BufNewFile *.c,*.h setlocal ft=c tabstop=2 shiftwidth=2
  autocmd BufRead,BufNewFile *.go setlocal ft=go noexpandtab tabstop=4 shiftwidth=4
augroup END

