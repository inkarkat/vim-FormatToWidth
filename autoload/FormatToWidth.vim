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
    normal! gvy
    let l:width = (a:count ? a:count : str2nr(getregtype('')[1:]))
    let l:emptyLine = repeat(' ', l:width)

    let l:originalLines = split(@@, '\n', 1)
    call map(l:originalLines, 'substitute(v:val, "\\s\\+$", "", "")')
    let l:originalLineNum = len(l:originalLines)
"****D echomsg '****' l:width string(l:originalLines)
    let l:formattedLines = ingo#buffer#temprange#Execute(l:originalLines, printf('call FormatToWidth#FormatWithWidth(%d, "G")', l:width))
    let l:formattedLineNum = len(l:formattedLines)
"****D echomsg '****' string(l:formattedLines)

    let l:blockLines = l:formattedLines[0 : l:originalLineNum - 1] + repeat([l:emptyLine], (l:originalLineNum - l:formattedLineNum))
    let l:additionalLines = l:formattedLines[l:originalLineNum :]

    call setreg('', join(l:blockLines, "\n"), "\<C-v>" . l:width)
    normal! gvP

    if len(l:additionalLines) > 0
	let l:startVirtCol = ingo#mbyte#virtcol#GetVirtStartColOfCurrentCharacter(line("'<"), col("'<"))
	let l:indent = repeat(' ', l:startVirtCol - 1)
	call append("']", map(l:additionalLines, 'l:indent . v:val'))
	call setpos("']", [0, line("']") + len(l:additionalLines), len(l:additionalLines[-1]), 0])
    endif
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

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
