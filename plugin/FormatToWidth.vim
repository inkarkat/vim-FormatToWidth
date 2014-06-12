" FormatToWidth.vim: Apply the gq command to the selected / count width.
"
" DEPENDENCIES:
"   - FormatToWidth.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	10-Apr-2014	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_FormatToWidth') || (v:version < 700)
    finish
endif
let g:loaded_FormatToWidth = 1

vnoremap <silent> <Plug>(FormatToWidth) :<C-u>call setline('.', getline('.'))<Bar>call FormatToWidth#Format(visualmode())<CR>
if ! hasmapto('<Plug>(FormatToWidth)', 'v')
    xmap <Leader>gq <Plug>(FormatToWidth)
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
