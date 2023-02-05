set nocompatible              
filetype off
syntax enable

" ---------- Plugins -------
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"" basics
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'ryanoasis/vim-devicons'
" Plugin 'powerline/powerline'
"" editor 
Plugin 'github/copilot.vim'
Plugin 'matze/vim-move'
Plugin 'tpope/vim-commentary'
Plugin 'Raimondi/delimitMate'
Plugin 'kshenoy/vim-signature'
"" git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
"" search 
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
" Plugin 'ctrlpvim/ctrlp.vim'
"" language 
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'rcjsuen/dockerfile-language-server-nodejs'
Plugin 'neoclide/vim-jsx-improve'
Plugin 'vim-python/python-syntax'
"" themes
Plugin 'arcticicestudio/nord-vim'
" Plugin 'altercation/vim-colors-solarized'
" Plugin 'sonph/onehalf', {'rtp': 'vim'}

call vundle#end()
filetype plugin indent on


" ----------- Theme Settings -----
set background=dark
"" colorscheme solarized 
colorscheme nord 
"" linenumber
set number 
set cursorline
highlight CursorLineNr cterm=NONE ctermfg=Yellow ctermbg=NONE
au WinLeave * set nocursorline 
au WinEnter * set cursorline 
set guicursor=

" ----------- Editor settings -----
set showbreak=+++
set showmatch
set ignorecase
set smartcase
set autoindent
set smartindent
" set foldmethod=indent
" set foldnestmax=2
set shiftwidth=4
set autoread
set noswapfile
autocmd FileType python set foldmethod=indent
autocmd FileType python set foldnestmax=2

" ---------- Shortcuts -------
"" some convinient stuff
:nmap <Space><Space> :
:nmap <leader>hs :split<Cr>
:nmap <leader>vs :vsplit<Cr>
" ----- NERDTree 
noremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> <:NERDTreeToggle<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" unmap the navigation keys
nmap <Up>    <Nop>
nmap <Down>  <Nop>
nmap <Left>  <Nop>
nmap <Right> <Nop>
" remap hard to use keys
nnoremap Q @q
"" navigation in insert mode without arrow keys
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" ---- COC shortcuts - more in plugins
"" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
"" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
"" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" ----- fzf shortcuts
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }


" ---------- Search settings ------
set hlsearch
nnoremap <silent> <esc> :noh<cr><esc>
" augroup AutoHighlighting
"     au!
"     autocmd CmdlineEnter /,\? set hlsearch
"     autocmd CmdlineLeave /,\? set nohlsearch
" augroup END
" ---- fzf 
"" Customize fzf colors to match your color scheme
"" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors = 
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
"" Enable per-command history
"" - History files will be stored in the specified directory
"" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
""   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" ---------- Plugin Settings -----

" ----  Air Line
" let g:AirlineTheme='solarized'
let g:AirlineTheme='nord'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" ----  NERDtree
 let NERDTreeMinimalUI = 1
 let NERDTreeShowHidden = 1
"" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" ----  Vim-Move
"set move_normal_option
let g:move_key_modifier = 'C'
let g:move_key_modifier_visualmode = 'C'


" ----  Git-gutter
hi clear SignColumn
let g:airline#extensions#hunks#non_zero_only = 1

" ----  Deliminate
" let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" ----  Coc Settings
"" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
"" utf-8 byte sequence
set encoding=utf-8
"" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
set pumheight=10
"" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
"" delays and peor user experience
set updatetime=300

"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved
set signcolumn=yes
"" Use tab for trigger completion with characters ahead and navigate
"" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

"" Make <CR> to accept selected completion item or notify coc.nvim to format
"" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

"" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

"" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

"" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  "" Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "" Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

"" Applying code actions to the selected code block
"" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

"" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
"" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
"" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

"" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

"" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

"" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

"" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

"" Use CTRL-S for selections ranges
"" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

"" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

"" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

"" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

"" Add (Neo)Vim's native statusline support
"" NOTE: Please see `:h coc-status` for integrations with external plugins that
"" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"" Mappings for CoCList
"" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>"     

