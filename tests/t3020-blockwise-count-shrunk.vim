" Test formatting block to passed smaller count.
" Tests that additional lines are created and the block extended.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit columns.txt

call vimtest#StartTap()
call vimtap#Plan(2)

execute "1normal f|l\<C-v>t|19j15\\gq"
call vimtap#Is(getpos("'["), [0, 1, 32, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 27, 46, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
