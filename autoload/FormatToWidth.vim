" FormatToWidth.vim: Apply the gq command to the selected / count width.
"
" DEPENDENCIES:
"   - ingo/compat.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	10-Apr-2014	file creation

function! s:FormatWithWidth( width, endMotion )
    let l:save_textwidth = &l:textwidth
    let &l:textwidth = a:width
    try
	execute 'normal! gq' . a:endMotion
    finally
	let &l:textwidth = l:save_textwidth
    endtry
endfunction

function! FormatToWidth#FormatLines( width )
    call s:FormatWithWidth(a:width, "g'>")
endfunction

function! FormatToWidth#FormatCharacterwise( count )
    let l:startPos = getpos("'<")
    let l:startVirtCol = virtcol("'<")
    normal! gvd
    let l:width = (a:count ? a:count : ingo#compat#strdisplaywidth(matchstr(@@, '^\%(\n\@!.\)*')))

    if col('.') < l:startPos[2]
	" The cursor has moved left because there was no trailing text after the
	" selection.
	let l:remainder = ''
    else
	" The cursor column hasn't moved; there was trailing text after the
	" selection that we need to move.
	let l:selection = @@
	normal! d$
	let l:remainder = @@
	let @@ = l:selection
    endif

    silent put
    call s:FormatWithWidth(l:width, "g'[")
    let l:lastLnum = line('.')

    if l:startVirtCol > 1
	" Indent the formatted lines.
	let l:indent = repeat(' ', l:startVirtCol - 1)
	for l:lnum in range(l:startPos[1] + 2, l:lastLnum)
	    call setline(l:lnum, l:indent . getline(l:lnum))
	endfor
    endif

    if ! empty(l:remainder)
	let @@ = l:remainder
	silent put
    endif

    execute l:startPos[1] . 'join!'

    call setpos("'[", l:startPos)
    call setpos("']", [0, l:lastLnum - 1, 0, 0])
endfunction

function! FormatToWidth#Format( mode )
    if a:mode ==# 'V'
	let l:width = (v:count ? v:count : ingo#compat#strdisplaywidth(getline("'<")))
	call FormatToWidth#FormatLines(l:width)
    elseif a:mode ==# 'v'
	call ingo#register#KeepRegisterExecuteOrFunc(function('FormatToWidth#FormatCharacterwise'), v:count)
    else
	call ingo#register#KeepRegisterExecuteOrFunc(function('FormatToWidth#FormatBlockWise'), v:count)
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
