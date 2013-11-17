augroup filetypedetect
  au BufRead,BufNewFile *.y setfiletype c
  au BufRead,BufNewFile *.t setfiletype perl 
  au BufRead,BufNewFile *.tx setfiletype xslate 
augroup END

