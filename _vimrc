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

Plug 'Shougo/neosnippet.vim'

Plug 'deoplete-plugins/deoplete-jedi'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'tpope/vim-fugitive'

Plug 'itchyny/lightline.vim'

call plug#end()

" 表示関係
set t_Co=256
set background=dark
set laststatus=2
colorscheme hybrid
filetype plugin on 
syntax enable
set list                " 不可視文字の可視化
set number              " 行番号の表示
set ruler               " カーソル位置が右下に表示される
set wildmenu            " コマンドライン補完が強力になる
set showcmd             " コマンドを画面の最下部に表示する
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
"set cursorline          " カーソル位置の強調
"hi CursorLineNr ctermfg=248
"hi clear cursorline
set pumheight=10        " 補完メニューの高さを10に
set completeopt-=preview " Previewを消す
" vimの背景も透過させる
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none 
" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell
" terminal
noremap ter :ter ++curwin
set termwinkey=<C-L>

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
    let s .= '%#TabLineFill#%T'
    return s
endfunction
set tabline=%!MyTabLine()

""" 検索関係
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト

""" マクロおよびキー設定
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
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
" タブの作成・タブ間の移動
noremap st :tabnew
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
augroup setAutoCompile
    autocmd!
    autocmd BufWritePost *.c :!gcc %:p
    autocmd BufWritePost *.cpp :!g++ -std=c++14 %:p
    autocmd BufWritePost *.R :!R -f %:p
augroup END
" NERDTreeに関する設定
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-a> :NERDTreeToggle<CR>
" Use deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 500
let g:deoplete#on_insert_enter = 0
let g:deoplete#on_text_changed_i=0
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#enable_refresh_always = 0
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

"" vimtex
let g:vimtex_fold_enabled = 0
 " vimtexとdeopleteを調和させる
 " This is new style
  call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})  
" deoplete-jediの設定
let g:deoplete#sources#jedi#enable_typeinfo = 0 " disable type information of completions
" LSP configuration
let g:LanguageClient_serverCommands = {
  \ 'c': ['clangd'],
  \ 'cpp': ['clangd'],
  \ }
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> rn :call LanguageClient#textDocument_rename()<CR>
" lightline settings
let g:lightline = {
    \'enable': {
        \ 'statusline': 1,
        \ 'tabline': 0
        \ } 
    \}
