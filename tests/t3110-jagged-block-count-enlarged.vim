" Test formatting block-to-end to passed larger count.
" Tests that the jagged block is detected and no space padding is inserted.
" Tests that the remainder of the original block that lost its text is empty.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit columns.txt

call vimtest#StartTap()
call vimtap#Plan(2)

execute "1normal 2f|l\<C-v>$19j32\\gq"
call vimtap#Is(getpos("'["), [0, 1, 52, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 20, 83, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
