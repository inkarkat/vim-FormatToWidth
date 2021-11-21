" Test formatting block to kept width.
" Tests that the remainder of the original block that lost its text is filled with spaces.

call vimtest#SkipAndQuitIf(v:version <= 702, 'The test somehow leads to wrong results of the second processing in Vim 7.2 and earlier')

edit columns.txt

call vimtest#StartTap()
call vimtap#Plan(4)

execute "2normal f|l\<C-v>t|7j\\gq"
call vimtap#Is(getpos("'["), [0, 2, 32, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 9, 50, 0], 'end of change')

execute "1normal \<C-v>t|12j\\gq"
call vimtap#Is(getpos("'["), [0, 1, 1, 0], 'start of change')
call vimtap#Is(getpos("']"), [0, 13, 30, 0], 'end of change')

call vimtest#SaveOut()
call vimtest#Quit()
