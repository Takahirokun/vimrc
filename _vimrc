""" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END

" プラグイン
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'Shougo/neosnippet.vim'

Plug 'lervag/vimtex'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'JuliaEditorSupport/julia-vim'

Plug 'tpope/vim-fugitive'

Plug 'itchyny/lightline.vim'
                           
Plug 'cocopon/iceberg.vim'

call plug#end()

" 表示関係
set t_Co=256
set background=dark
set laststatus=2
colorscheme iceberg
filetype plugin on 
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

    " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセッ
    " トする
    
    return s
endfunction
set tabline=%!MyTabLine()

""" 検索関係
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト

""" マクロおよびキー設定
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" [ と打ったら [] って入力されてしかも括弧の中にいる(以下同様)
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
"C/C++のコンパイルを自動的に行う
augroup setAutoCompile
    autocmd!
    autocmd BufWritePost *.c :!gcc %:p
    autocmd BufWritePost *.cpp :!g++ -std=c++14 %:p
augroup END
" NERDTreeに関する設定
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
noremap <C-a> :NERDTreeToggle<CR>

" Use deoplete
let g:deoplete#options#on_insert_enter = 0
let g:deoplete#options#on_text_changed_i = 0
let g:deoplete#options#refresh_always = 0

" neosnippet settings
let g:neosnippet#enable_complete_done = 1
let g:neosnippet#disable_runtime_snippets = {
\   '_' : 1,
\ }   
let g:neosnippet#snippets_directory='~/.vim/snippets' 
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
 
" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
""imap <expr><TAB>
""\ pumvisible() ? "\<C-n>" :
"" \ neosnippet#expandable_or_jumpable() ?
"" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"" vimtex
hi texMath ctermfg=149
let g:vimtex_fold_enabled = 0
 " vimtexとdeopleteを調和させる
 " This is new style
  call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})  
let g:tex_flavor = "latex"

" LSP configuration
let g:LanguageClient_serverCommands = {
  \ 'c': ['clangd'],
  \ 'cpp': ['clangd'],
  \ }
set completefunc=LanguageClient#complete
nmap <silent>K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> rn <Plug>(lcn-rename)
 
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
