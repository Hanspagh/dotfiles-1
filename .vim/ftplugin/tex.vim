" Don't do any clever folding
"let g:Tex_FoldedSections=''
"let g:Tex_FoldedEnvironments=''
"let g:Tex_FoldedMisc=''

setlocal concealcursor=

" Don't conceal symbols
" let g:tex_conceal = ""

" Use zathura for previewing latex
let g:livepreview_previewer = 'zathura'
" let g:livepreview_engine = 'latexmk -pdf'
"
" .tex files are always filetype latex
let g:tex_flavor = 'latex'
