" Test formatting characters to the width.

edit text.txt

call vimtest#StartTap()
call vimtap#Plan(4)

" Tests remainder after selection.
13normal 0Wv4jt:\gq

call vimtap#Is(getpos("'["), [0, 13, 6, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 24, 6, 0], 'end of change')

3normal 0v8jf.\gq
call vimtap#Is(getpos("'["), [0, 3, 1, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 18, 1, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
