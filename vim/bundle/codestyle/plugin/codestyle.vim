
if !exists('g:style_dir')
   let g:style_dir = substitute(globpath(&rtp, 'style/'), '\n', ',', 'g')
endif

fun! CodeStyle(style)
   let l:style_defs = substitute(globpath(g:style_dir, a:style . '.vim'), '\n', ',', 'g')
   let l:style_defs_list = split(l:style_defs, ',')

   for l:style_def in l:style_defs_list
      if filereadable(l:style_def)
         exec ":source " . l:style_def
         return
      endif
   endfor

   echom 'unknown coding style ' . a:style
endf

fun! FindStyle()
   let l:my_dir = escape(expand('%:p:h'), ' ~|!"$%&()=?{[]}+*#'."'")
   let l:style_files = findfile('.codestyle', l:my_dir . ';', -1)

   for l:style_file in l:style_files
      if filereadable(l:style_file)
         let l:style_name = join(readfile(l:style_file), '\n')

         call CodeStyle(l:style_name)

         return
      end
   endfor
endf

if has("autocmd")
   autocmd BufNewFile,BufRead * call FindStyle()
endif
