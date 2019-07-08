""" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END

" プラグイン
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

Plug 'lervag/vimtex'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'Shougo/neosnippet.vim'
"Plug 'Shougo/neosnippet-snippets'

call plug#end()

" 表示関係
set t_Co=256
set background=dark
colorscheme hybrid
syntax on
set list                " 不可視文字の可視化
set number              " 行番号の表示
set ruler               " カーソル位置が右下に表示される
set wildmenu            " コマンドライン補完が強力になる
set showcmd             " コマンドを画面の最下部に表示する
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
""set colorcolumn=80      " その代わり80文字目にラインを入れる
set cursorline          " カーソル位置の強調
set pumheight=10        " 補完メニューの高さを10に
" vimの背景も透過させる
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none 
" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell
set foldmethod=indent    " 折り畳み
set foldlevel=100    " ファイルを開くときに折り畳みをしない

""" 編集関係
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする
set autoindent          " 改行時にインデントを引き継いで改行する
set shiftwidth=4        " インデントにつかわれる空白の数
au BufNewFile,BufRead *.yml set shiftwidth=2
set softtabstop=4       " <Tab>押下時の空白数
set expandtab           " <Tab>押下時に<Tab>ではなく、ホワイトスペースを挿入する
set tabstop=4           " <Tab>が対応する空白の数
au BufNewFile,BufRead *.yml set tabstop=2
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set nf=                 " インクリメント、デクリメントを10進数にする
" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>
" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start
" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif
" Swapファイル, Backupファイルを全て無効化する
set nowritebackup
set nobackup
set noswapfile

""" 検索関係
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト
" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

""" マクロおよびキー設定
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
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
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-p>    <C-w>+
nnoremap <S-m>  <C-w>-
" タブ間の移動
noremap <C-n> gt
nnoremap <C-p> gT
" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif         
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')
" RとC/C++のコンパイルを自動的に行う
filetype plugin on
augroup setAutoCompile
    autocmd!
    autocmd BufWritePost *.c :!gcc %:p
    autocmd BufWritePost *.cpp :!g++ -std=c++14 %:p
    autocmd BufWritePost *.R :!R -f %:p
augroup END
" NERDTreeに関する設定
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
" Use deoplete
let g:deoplete#enable_at_startup = 1
" vimtexとdeopleteを調和させる
 " This is new style
  call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
let g:neosnippet#disable_runtime_snippets = { 'tex' : 1 }
let s:my_snippet='~/.vim/snippets/'
let g:neosnippet#snippets_directory = s:my_snippet

