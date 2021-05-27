" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Remap a few keys for Windows behavior
source $VIMRUNTIME/mswin.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
    set diffexpr=MyDiff()
endif
function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg1 = substitute(arg1, '!', '\!', 'g')
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg2 = substitute(arg2, '!', '\!', 'g')
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let arg3 = substitute(arg3, '!', '\!', 'g')
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
            if empty(&shellxquote)
                let l:shxq_sav = ''
                set shellxquote&
            endif
            let cmd = '"' . $VIMRUNTIME . '\diff"'
        else
            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    let cmd = substitute(cmd, '!', '\!', 'g')
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
    if exists('l:shxq_sav')
        let &shellxquote=l:shxq_sav
    endif
endfunction

call plug#begin ('~/.vim/pluggins')
Plug 'jamessan/vim-gnupg'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'
Plug 'https://github.com/flazz/vim-colorschemes'
Plug 'ervandew/supertab'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'https://github.com/chiel92/vim-autoformat'
let b:formatdef_custom_cpp='"astyle --mode=c --suffix=none --style=stroustrup -p -xg"'
let b:formatters_cpp = ['custom_cpp']
Plug 'https://github.com/vim-airline/vim-airline'
""Plug 'https://github.com/itchyny/lightline.vim'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsListSnippets = "<c-tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options
            \ = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'
let g:vimtex_view_general_options
            \ = '-reuse-instance -forward-search @tex @line @pdf'
            \ . ' -inverse-search "' . exepath(v:progpath)
            \ . ' --servername ' . v:servername
            \ . ' --remote-send \"^<C-\^>^<C-n^>'
            \ . ':execute ''drop '' . fnameescape(''\%f'')^<CR^>'
            \ . ':\%l^<CR^>:normal\! zzzv^<CR^>'
            \ . ':call remote_foreground('''.v:servername.''')^<CR^>^<CR^>\""'

Plug 'KeitaNakamura/tex-conceal.vim'
set conceallevel=1
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'ferrine/md-img-paste.vim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }


"Auto Complete
Plug 'neoclide/coc.nvim'

let g:coc_global_extensions = ['coc-vimlsp']
call plug#end()

"coc setting

set updatetime=100

" Markdown{{{
let g:vmt_auto_update_on_save = 0
let g:mkdp_browser  ='C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
let g:mkdp_preview_options = {
            \ 'mkit': {},
            \ 'katex': {},
            \ 'uml': {},
            \ 'maid': {},
            \ 'disable_sync_scroll': 0,
            \ 'sync_scroll_type': 'middle',
            \ 'hide_yaml_meta': 1,
            \ 'sequence_diagrams': {}
            \ }
let g:mkdp_auto_close=0
let g:mkdp_refresh_slow = 0
let g:vim_markdown_anchorexpr = "'<<'.v:anchor.'>>'"
let g:vim_markdown_math = 1
let g:mkdp_auto_start = 0
let g:vim_markdown_strikethrough = 1

let g:mdip_imgdir = 'pic'
let g:mdip_imgname = 'image'
""let g:mkdp_markdown_css='C:\Users\Administrator\AppData\Roaming\Typora\themes\solarized.css'
let g:mkdp_markdown_css=''
"}}}

set encoding=utf-8
set termencoding=utf-8
""set fileencoding=chinese
""set fileencodings=ucs-bom,utf-8,chinese
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

set langmenu=zh_CN.utf-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
language messages zh_cn.utf-8


set number
set nocompatible
" 自适应不同语言的智能缩进
filetype indent on
" 将制表符扩展为空格
set expandtab
" 设置编辑时制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=4
:set cindent
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {}<ESC>i
inoremap " ""<ESC>i


set autoindent
set shiftwidth=4
set tabstop=4
set expandtab
set smarttab


set cursorline
" 禁止光标闪烁
set gcr=a:block-blinkon0
" 禁止显示滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
" 禁止显示菜单和工具条
set guioptions-=m
set guioptions-=T
" 总是显示状态栏
set laststatus=2
" 显示光标当前位置
set ruler
" 开启行号显示
set number
" 高亮显示当前行/列
set cursorline
set cursorcolumn
" 高亮显示搜索结果
set hlsearch
" 设置 gvim 显示字体
"set encoding=utf-8
""set guifont=YaHei_Consolas_Hybrid:h12


""set guifont=Consolas:h15
""set guifont=YaHei_Monaco_Hybird:h15
""set guifont=微软雅黑Monaco:h15
set guifont=Hack:h13
set guifontwide=黑体:h15
""set gfw=msyh:h12
""set gfw=YaHei_Consolas_Hybird:h15
set lines=35 columns=130
set nowrap
" 基于缩进或语法进行代码折叠
"set foldmethod=indent
set foldmethod=syntax
" 启动 vim 时关闭折叠代码
set nofoldenable
" 设置显示／隐藏标签列表子窗口的快捷键。速记：identifier list by tag
set tags+=D:\Vim\stdcpp.tags
let OmniCpp_DefaultNamespaces = ["_GLIBCXX_STD"]
func CompileGpp()
    if &filetype == 'cpp'
        silent exec "w"
        exec "!g++ % -o %<"
    elseif &filetype == 'java'
        silent exec "w"
        exec "!javac %"
    endif
endfunc
"map <F5> : call CompileGpp() <CR>
imap <F2> <Esc>o{<CR><Esc>O
imap <F4> <Esc>$a
imap <F3> <Esc>wa
nmap <F10> :q<CR>
"缩写
""iab itn int
""iab mian main
""iab #i #include <
""iab us using
""iab na namespace
func Debug()
    exec "w"
    exec "!g++ % -g -o D%<"
    exec "!gdb D%<"
endfunc
"nmap <F10> : call Debug() <CR>
"nmap <F9>  :!gdb D%<<CR>
func Run()
    if&filetype=='python'
        exe  "w"
        exec "!python % "
    elseif &filetype=='cpp'
        exe  "! clang++ -target x86_64-pc-windows-gnu -std=c++11  -w -g  % -o  %<.exe & %<"
    elseif &filetype == 'java'
        exe "!javac % & java %<"
    endif
endfunc
nmap <F8> :call Run() <CR>

syntax enable
inoremap jk <esc>
""if has('gui_running')
"set background=dark
"else
"set background=dark
"endif

"colorscheme briofita
colorscheme material

set nobackup
set noundofile
set noswapfile

noremap <F5> :Autoformat<CR>:w<CR>
set cm=blowfish2



set autoread
set autowriteall
set relativenumber

"https://vi.stackexchange.com/questions/10296/navigation-in-insert-mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
