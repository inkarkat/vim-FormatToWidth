" Test formatting block to passed larger count.
" Tests that the remainder of the original block that lost its text is filled with spaces.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit columns.txt

call vimtest#StartTap()
call vimtap#Plan(2)

execute "1normal f|l\<C-v>t|19j30\\gq"
call vimtap#Is(getpos("'["), [0, 1, 32, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 20, 61, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
