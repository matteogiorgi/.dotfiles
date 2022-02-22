if exists("b:current_syntax") | finish | endif

execute 'syntax region startscreenHeader start=/\%1l/ end=/\%'. (len(g:startscreen_header) - 8) .'l/'
execute 'syntax region startscreenFooter start=/\%'. (len(g:startscreen_header) - 7) .'l/' . ' end=/\%'. (len(g:startscreen_header) + 2) .'l/'

highlight default link startscreenHeader Comment
highlight default link startscreenFooter Function

let b:current_syntax = 'startscreen'
