FORMAT TO WIDTH
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

Vim can reformat lines with the gq command, according to 'textwidth' and
'formatoptions', which is very handy. But sometimes you want to format to a
different width, or just a single block in a vertical column layout. That
requires a temporary :setlocal tw=N, and copying the block elsewhere to
reformat it, which is cumbersome.

This plugin provides a visual mode &lt;Leader&gt;gq command that reformats only the
selection; how exactly depends on the selection mode. The new width is
determined by a passed [count], or the width of the selection's first line.
With this, you can easily reformat lines to a certain width, or a blockwise
selection while leaving the text to the left and right alone.

### SOURCE

- [Inspiration for this plugin](http://stackoverflow.com/questions/22922274/how-does-one-rewrap-text-in-a-column-in-vim)

USAGE
------------------------------------------------------------------------------

    {Visual}<Leader>gq      Linewise selection: Format the selected text to the
                            width of the first selected line / to [count]
                            characters.
                            Blockwise selection: Format the selected text to the
                            width of the block / to [count] characters, and
                            change the selected text in-place. If the reformatted
                            text consists of less lines, the remainder of the
                            block will consist of spaces. If it's more lines,
                            these will be inserted as additional lines,
                            left-aligned with spaces to the start column of the
                            block.
                            Characterwise selection: Format the selected text to
                            the width of the first selected line / to [count]
                            characters, and align all following lines to the start
                            column of the selection.

### EXAMPLE LINEWISE

    To re-wrap the following text:
        The quick brown fox jumps over the lazy dog.
    to a 'textwidth' of 20, you select the entire line, then reformat to the
    specified width: V20<Leader>gq
        The quick brown fox
        jumps over the lazy
        dog.

### EXAMPLE BLOCKWISE

    You have a multi-column layout like this:
        Intro | The quick brown fox       -
              | jumps over the lazy dog.  - (he's very lazy)
    Let's reformat the middle column to use all the available space.
    You select the entire column as a block, e.g. with f|l<C-V>t-j, then reformat
    the selection with <Leader>gq:
        Intro | The quick brown fox jumps -
              | over the lazy dog.        - (he's very lazy)
    Okay, but now you want it wider: gv40<Leader>gq reformats to a 40-char column:
        Intro | The quick brown fox jumps over the lazy -
              | dog.                                    - (he's very lazy)

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-FormatToWidth
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim FormatToWidth*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.037 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

If you want to use a different mapping, map your keys to the
&lt;Plug&gt;(FormatToWidth) mapping target _before_ sourcing the script
(e.g. in your vimrc):

    xmap <Leader>gq <Plug>(FormatToWidth)

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-FormatToWidth/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.01    RELEASEME
-

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.037!__

##### 1.00    14-Apr-2014
- First published version.

##### 0.01    10-Apr-2014
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2014-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
