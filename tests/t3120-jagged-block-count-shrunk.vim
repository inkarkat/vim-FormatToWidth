" Test formatting block-to-end to passed smaller count.
" Tests that the jagged block is detected and no space padding is inserted.
" Tests that additional lines are created and the block extended.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit columns.txt

call vimtest#StartTap()
call vimtap#Plan(2)

execute "1normal 2f|l\<C-v>$19j15\\gq"
call vimtap#Is(getpos("'["), [0, 1, 52, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 26, 66, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
