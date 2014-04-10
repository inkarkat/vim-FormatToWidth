" Test formatting lines to passed count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit text.txt

13normal V5j30\gq
3normal V5j40\gq

call vimtest#SaveOut()
call vimtest#Quit()
