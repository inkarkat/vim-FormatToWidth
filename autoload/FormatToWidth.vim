" FormatToWidth.vim: Apply the gq command to the selected / count width.
"
" DEPENDENCIES:
"   - ingo/buffer/temprange.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/mbyte/virtcol.vim autoload script
"   - ingo/register.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.003	14-Apr-2014	Optimization: Pass 0 undoCnt because inside the
"				FormatToWidth#FormatBlock() function, no new
"				undo sequence is created, anyway, so the temp
"				range has to be explicitly deleted.
"				Silence the blockwise yanking.
"   1.00.002	11-Apr-2014	Complete implementation.
"	001	10-Apr-2014	file creation
let s:save_cpo = &cpo
set cpo&vim

function! FormatToWidth#FormatWithWidth( width, endMotion )
    let l:save_textwidth = &l:textwidth
    let &l:textwidth = a:width
    try
	execute 'normal! gq' . a:endMotion
    finally
	let &l:textwidth = l:save_textwidth
    endtry
endfunction

function! FormatToWidth#FormatLines( width )
    call FormatToWidth#FormatWithWidth(a:width, "g'>")
endfunction

function! FormatToWidth#FormatCharacters( count )
    let [l:startLnum, l:startCol] = getpos("'<")[1:2]
    let l:startVirtCol = ingo#mbyte#virtcol#GetVirtStartColOfCurrentCharacter(l:startLnum, l:startCol)

    silent normal! gvd
    let l:width = (a:count ? a:count : ingo#compat#strdisplaywidth(matchstr(@@, '^\%(\n\@!.\)*')))

    if col('.') < l:startCol || l:startCol == 1 && empty(getline(l:startLnum))
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
    call FormatToWidth#FormatWithWidth(l:width, "g'[")
    let l:lastLnum = line('.')

    if l:startVirtCol > 1
	" Indent the formatted lines.
	let l:indent = repeat(' ', l:startVirtCol - 1)
	for l:lnum in range(l:startLnum + 2, l:lastLnum)
	    let l:line = getline(l:lnum)
	    if ! empty(l:line)
		call setline(l:lnum, l:indent . l:line)
	    endif
	endfor
    endif

    if ! empty(l:remainder)
	let @@ = l:remainder
	silent put
    endif

    execute l:startLnum . 'join!'

    call setpos("'[", [0, l:startLnum, l:startCol, 0])
    call setpos("']", [0, l:lastLnum - 1, l:startVirtCol, 0])   " I18N: Can use virtcol as col, because it's just space indent.
endfunction

function! FormatToWidth#FormatBlock( count )
    silent normal! gvy
    let l:width = (a:count ? a:count : str2nr(getregtype('')[1:]))

    let l:originalLines = split(@@, '\n', 1)
    call map(l:originalLines, 'substitute(v:val, "\\s\\+$", "", "")')
    let l:originalLineNum = len(l:originalLines)
"****D echomsg '****' l:width string(l:originalLines)
    let l:formattedLines = ingo#buffer#temprange#Execute(l:originalLines,
    \   printf('call FormatToWidth#FormatWithWidth(%d, "G")', l:width),
    \   0)  " Inside a function, no new undo sequence is created.
    let l:formattedLineNum = len(l:formattedLines)
"****D echomsg '****' string(l:formattedLines)
    let l:additionalLineNum = l:formattedLineNum - l:originalLineNum
    if l:additionalLineNum > 0
	call append("'>", repeat([''], l:additionalLineNum))
    else
	let l:formattedLines = l:formattedLines[0 : l:originalLineNum - 1] +
	\   repeat([''], (l:originalLineNum - l:formattedLineNum + 1))
    endif

    call setreg('', join(l:formattedLines, "\n"), "\<C-v>" . l:width)
    normal! gvP
endfunction

function! FormatToWidth#Format( mode )
    if a:mode ==# 'V'
	let l:width = (v:count ? v:count : ingo#compat#strdisplaywidth(getline("'<")))
	call FormatToWidth#FormatLines(l:width)
    elseif a:mode ==# 'v'
	call ingo#register#KeepRegisterExecuteOrFunc(function('FormatToWidth#FormatCharacters'), v:count)
    else
	call ingo#register#KeepRegisterExecuteOrFunc(function('FormatToWidth#FormatBlock'), v:count)
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
