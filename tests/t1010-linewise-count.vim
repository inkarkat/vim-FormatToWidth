" Test formatting lines to passed count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit text.txt

call vimtest#StartTap()
call vimtap#Plan(2)

13normal V5j30\gq

3normal V5j40\gq
call vimtap#Is(getpos("'["), [0, 3, 1, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 14, 3, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
