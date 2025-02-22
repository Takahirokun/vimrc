" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END

" プラグイン
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

" auto completion and fuzzy finder
Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddu.vim'
Plug 'vim-denops/denops.vim'

" ddu's ui, source, filter, and kind
Plug 'Shougo/ddu-ui-ff'
Plug 'Shougo/ddu-ui-filer'
Plug 'Shougo/ddu-column-filename'
Plug 'Shougo/ddu-source-file_rec'
Plug 'Shougo/ddu-source-file'
Plug 'Shougo/ddu-filter-matcher_substring'
Plug 'Shougo/ddu-kind-file'

" ddc's UI
Plug 'Shougo/ddc-ui-native'

" Install sources
Plug 'Shougo/ddc-source-around'

" Install filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'

" lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings' 
Plug 'Shougo/ddc-source-lsp' 
Plug 'JuliaEditorSupport/julia-vim'

" snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'uga-rosa/ddc-source-vsnip'

" git
Plug 'tpope/vim-fugitive'

" markdown preview
Plug 'kat0h/bufpreview.vim', { 'do': 'deno task prepare' }

" vim theme
Plug 'itchyny/lightline.vim'
Plug 'cocopon/iceberg.vim'

" skk
Plug 'vim-skk/skkeleton'

" copilot
Plug 'github/copilot.vim'

call plug#end()

" for lsp debug
"let lsp_log_verbose=1
"let lsp_log_file='/tmp/lsp.log'

" NERDTree settings
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif 
noremap <C-@> :NERDTreeToggle<CR>

" ddc settings
" Customize global settings
" UI
call ddc#custom#patch_global('ui', 'native')

" sources.
call ddc#custom#patch_global('sources', [
			\ 'lsp',
			\ 'skkeleton',
			\ 'vsnip',
			\ 'around',
			\ ])

"" source options.
call ddc#custom#patch_global('sourceOptions', #{
      \ _: #{
      \    matchers: ['matcher_head'],
      \    sorters: ['sorter_rank'],
	  \ },
	  \ skkeleton: #{
	  \    mark: 'skkeleton', 
	  \    matchers: [], 
	  \    sorters: [], 
	  \    isVolatile: v:true,
	  \ }, 
	  \ around: #{mark: 'A'},
	  \ vsnip: #{mark: 'snippet'},
      \ lsp: #{
      \     mark: 'lsp',
      \     forceCompletionPattern: '\.\w*|:\w*|->\w*',
	  \ },
	  \})

"" source parameters.
call ddc#custom#patch_global('sourceParams', #{
      \ around: #{maxSize: 500},
      \ lsp: #{
      \     snippetEngine: denops#callback#register({
      \           body -> vsnip#anonymous(body)
      \     }),
	  \     lspEngine: 'vim-lsp',
      \     enableAdditionalTextEdit: v:true,
      \   }
      \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', #{
      \ around: #{maxSize: 100},
      \ })

"" Mappings
" <TAB>: completion.
inoremap <expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" ddu settings
" You must set the default ui.
call ddu#custom#patch_global({
    \ 'ui': 'ff',
    \ })

call ddu#custom#patch_global({
			\ 'sources': [{'name': 'file_rec', 
			\   'params': {
			\     'ignoredDirectories': ["node_modules",".git",".vscode"],
			\	}
			\ }],
			\   'sourceOptions': {
			\     '_': {
			\       'matchers': ['matcher_substring'],
			\     },
			\   },
			\   'kindOptions': {
			\     'file': {
			\       'defaultAction': 'open',
			\     },
			\   },
			\ 'filterParams': {
			\  'matcher_substring': {
			\    'highlightMatched': 'Title',
			\  },
			\},  
			\})

call ddu#custom#patch_local('filer', {
			\ 'ui': 'filer',
			\   'sources': [{'name': 'file', 'params': {}}],
			\   'sourceOptions': {
			\     '_': {
			\       'columns': ['filename'],
			\     },
			\   },
			\   'kindOptions': {
			\     'file': {
			\       'defaultAction': 'open',
			\     },
			\   },
			\   'uiParams': {
			\     'filer': {
			\       'winWidth': 40,
			\       'split': 'vertical',
			\       'splitDirection': 'topleft',
			\     }
			\   },
			\ })

" Use ddc.
call ddc#enable()

" ddu settings
autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><silent> t
        \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#do_action('quit')<CR>

endfunction

autocmd filetype ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <cr>
  \ <esc><cmd>call ddu#ui#do_action('closeFilterWindow')<cr>
  nnoremap <buffer><silent> <cr>
  \ <cmd>call ddu#ui#do_action('closeFilterWindow')<cr>
  nnoremap <buffer><silent> q
  \ <cmd>call ddu#ui#do_action('closeFilterWindow')<cr>
endfunction
 
" ddu-ui-filer settings
" To move or copy the selected files, you must 'p' after using 'mv' or 'c'
autocmd filetype ddu-filer call s:ddu_filer_my_settings()
function! s:ddu_filer_my_settings() abort
  nnoremap <buffer><expr> <CR>
		\ ddu#ui#get_item()->get('isTree', v:false) ?
		\ "<Cmd>call ddu#ui#do_action('itemAction',
		\  {'name': 'narrow'})<CR>" :
		\ "<Cmd>call ddu#ui#do_action('itemAction',
		\  {'name': 'open'})<CR>"
  nnoremap <buffer><silent> <Space>
    \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer> o
    \ <Cmd>call ddu#ui#do_action('expandItem',
    \ {'mode': 'toggle'})<CR>
  nnoremap <buffer><silent> q
    \ <Cmd>call ddu#ui#do_action('quit')<CR>  
  nnoremap <buffer><silent> ..
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': '..'}})<CR>
  nnoremap <buffer><silent> r
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'rename'})<CR>
  nnoremap <buffer><silent> d
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'delete'})<CR>
  nnoremap <buffer><silent> mv
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'move'})<CR>
  nnoremap <buffer><silent> c
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'copy'})<CR>
  nnoremap <buffer><silent> p
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste'})<CR>
  nnoremap <buffer><silent> t
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newFile'})<CR>
  nnoremap <buffer><silent> mk
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newDirectory'})<CR>
endfunction

nmap <silent> ;f <Cmd>call ddu#start({})<CR>
nmap <silent> ;r <Cmd>call ddu#start({'name':'filer'})<CR>

" lsp settings
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server', 'deno']

" snippet
" NOTE: You can use other key to expand snippet.
" Expand
imap <expr> <C-e>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-e>'
smap <expr> <C-e>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-e>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

" skkeleton.
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
"let g:skkeleton#debug = v:true
function! s:skkeleton_init() abort
     call skkeleton#config({
   	   \ 'globalDictionaries': ["~/.eskk/SKK-JISYO.L"],
       \ 'eggLikeNewline': v:true,
       \ })
     call skkeleton#register_kanatable('rom', {
       \ "z\<Space>": ["\u3000", ''],
       \ "xn": ["ん", ''],
       \ })
    endfunction
    augroup skkeleton-initialize-pre
      autocmd!
      autocmd User skkeleton-initialize-pre call s:skkeleton_init()
    augroup END

" copilot settings
let g:copilot_filetypes = {
	\ '*': v:false,
	\ 'python': v:true,
	\ }

" lightline settings
let g:lightline = {
    \'enable': {
        \ 'statusline': 1,
        \ 'tabline': 0
        \ },
    \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
        \ },
    \ 'component_function': {
        \   'gitbranch': 'fugitive#head'
        \ },
\}


" display
set t_Co=256
set background=dark
set laststatus=2
colorscheme iceberg
filetype plugin indent on 
syntax enable
set number              " 行番号の表示
set ruler               " カーソル位置が右下に表示
set wildmenu            " コマンドライン補完を表示する
set showcmd             " コマンドを画面の最下部に表示する
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
set pumheight=10        " 補完メニューの高さを10に
set completeopt-=preview " Previewを消す
" vimの背景も透過させる
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none 
" スクリーンベルを無効化
set t_vb=
set novisualbell
" terminal
noremap ter :ter ++curwin
"set termwinkey=<C-L>
" カーソルを挿入モードとノーマルとで切り替え
if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif

""" 編集関係
"set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8 " エンコード
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする
set autoindent          " 改行時にインデントを引き継いで改行する
set shiftwidth=4        " インデントにつかわれる空白の数
set softtabstop=4       " <Tab>押下時の空白数
set tabstop=4           " <Tab>が対応する空白の数
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>
" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start
" クリップボードをデフォルトのレジスタとして指定。
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif
" Swapファイル, Backupファイルを全て無効化する
set nowritebackup
set nobackup
set noswapfile
" tabline settings
function MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return bufname(buflist[winnr - 1])
endfunction
hi clear TabLine
hi clear TabLineSel
hi clear TabLineFill
hi TabLine ctermfg=244, ctermbg=235, term=underline
hi TabLineSel ctermfg=256, ctermbg=232
hi TabLineFill ctermbg=235, term=underline
function MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
    " 強調表示グループの選択
    if i + 1 == tabpagenr()
        let s .= '%#TabLineSel#' 
    else
        let s .= '%#TabLine#' 
    endif
    " タブページ番号の設定 (マウスクリック用)
    let s .= '%' . (i + 1) . 'T'

    " ラベルは MyTabLabel() で作成する
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '

    let s.= '%#TabLineFill#|'
    endfor

    " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセットする
    
    return s
endfunction
set tabline=%!MyTabLine()

" 検索関係
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト

" マクロおよびキー設定
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

inoremap [ []<left>
inoremap ( ()<left>
inoremap { {}<left>
inoremap " ""<left>
inoremap ' ''<left>

" {}でEnterを押すとインデントが入って括弧の中に移動
function! IndentBraces()
    let nowletter = getline(".")[col(".")-1]    " 今いるカーソルの文字
    let beforeletter = getline(".")[col(".")-2] " 1つ前の文字

    " カーソルの位置の括弧が隣接している場合
    if nowletter == "}" && beforeletter == "{"
        return "\n\t\n\<UP>\<RIGHT>\<RIGHT>\<RIGHT>\<RIGHT>"
    else
        return "\n"
    endif
endfunction
" Enterに割り当て
inoremap <silent> <expr> <CR> IndentBraces()
 
" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" ウィンドウサイズを変更
nnoremap <S-Left>  <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-d>    <C-w>+
nnoremap <S-u>  <C-w>-
" タブの作成・タブ間の移動
noremap tn :tabnew
noremap <C-n> gt
nnoremap <C-p> gT
" grepで自動的にquickfix-windowを開く
autocmd QuickFixCmdPost *grep* cwindow
"C/C++のコンパイルを自動的に行う
augroup setAutoCompile
    autocmd!
    autocmd BufWritePost *.c :!gcc %:p
    autocmd BufWritePost *.cpp :!g++ -std=c++14 %:p
augroup END 
