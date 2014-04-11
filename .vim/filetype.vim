if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  autocmd BufRead,BufNewFile *.t set ft=perl tabstop=4 shiftwidth=4
  autocmd BufRead,BufNewFile *.y set ft=c tabstop=2 shiftwidth=2
  autocmd BufRead,BufNewFile *.tx set ft=xslate tabstop=2 shiftwidth=2
augroup END

