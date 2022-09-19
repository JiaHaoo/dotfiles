" disable bell
set visualbell
set t_vb=

" use mouse scroll
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e
