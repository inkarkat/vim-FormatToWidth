" Test formatting block-to-end to kept width.
" Tests that the jagged block is detected and no space padding is inserted.
" Tests that the remainder of the original block that lost its text is empty.

edit columns.txt

call vimtest#StartTap()
call vimtap#Plan(2)

execute "1normal 2f|l\<C-v>$19j\\gq"
call vimtap#Is(getpos("'["), [0, 1, 52, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 20, 80, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
