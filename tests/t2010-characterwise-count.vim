" Test formatting characters to passed count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit text.txt

call vimtest#StartTap()
call vimtap#Plan(4)

" Tests remainder after selection.
13normal 0Wv4jt:30\gq

call vimtap#Is(getpos("'["), [0, 13, 6, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 23, 6, 0], 'end of change')

3normal 0v8jf.40\gq
call vimtap#Is(getpos("'["), [0, 3, 1, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 18, 1, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
