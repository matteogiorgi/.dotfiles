let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#conceal#blacklist = []
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#syntax#codeblocks#embeds#use = 1
let g:pandoc#syntax#style#emphases = 1
let g:pandoc#syntax#style#underline_special = 1


" I don't have vim-pandoc plugin, poor me!
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
