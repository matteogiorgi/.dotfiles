" ColorPicker{{{
function! s:colorpicker(group, field)
    let l:colorgroup = execute('hi '.a:group)
    let l:start = stridx(l:colorgroup, a:field) + strlen(a:field) + 1
    let l:end = l:start + 6
    return l:colorgroup[l:start:l:end]
endfunction
"}}}

" h-function{{{
function! s:h(group, style)
    execute 'highlight' a:group
                \ 'guifg=' (has_key(a:style, 'fg')  ? a:style.fg  : 'NONE')
                \ 'guibg=' (has_key(a:style, 'bg')  ? a:style.bg  : 'NONE')
                \ 'guisp=' (has_key(a:style, 'sp')  ? a:style.sp  : 'NONE')
                \ 'gui='   (has_key(a:style, 'gui') ? a:style.gui : 'NONE')
endfunction
"}}}


" Colorscheme behaviour{{{
augroup statuslinepainter
    autocmd VimEnter,Colorscheme *
                \ let s:linenc_bg   = s:colorpicker('StatusLineNC' , 'guibg') |
                \ let s:linenc_fg   = s:colorpicker('StatusLineNC' , 'guifg') |
                \ let s:line_bg     = s:colorpicker('StatusLine'   , 'guibg') |
                \ let s:line_fg     = s:colorpicker('StatusLine'   , 'guifg') |
                \ let s:normal_bg   = s:colorpicker('Normal'       , 'guibg') |
                \ let s:normal_fg   = s:colorpicker('Normal'       , 'guifg') |
                \ let s:string_fg   = s:colorpicker('String'       , 'guifg') |
                \ let s:comment_fg  = s:colorpicker('Comment'      , 'guifg') |
                \ let s:keyword_fg  = s:colorpicker('Keyword'      , 'guifg') |
                \ let s:function_fg = s:colorpicker('Function'     , 'guifg') |
                \ call s:h('VertSplit'                    , { 'bg': s:normal_bg , 'fg': s:linenc_bg   , 'gui': 'bold'}) |
                \ call s:h('WhichKeyFloating'             , { 'bg': s:linenc_bg , 'fg': 'none'        , 'gui': 'bold'}) |
                \ call s:h('WhichKey'                     , { 'bg': s:linenc_bg , 'fg': s:string_fg   , 'gui': 'bold'}) |
                \ call s:h('WhichKeySeperator'            , { 'bg': s:linenc_bg , 'fg': s:comment_fg  , 'gui': 'bold'}) |
                \ call s:h('WhichKeyGroup'                , { 'bg': s:linenc_bg , 'fg': s:keyword_fg  , 'gui': 'bold'}) |
                \ call s:h('WhichKeyDesc'                 , { 'bg': s:linenc_bg , 'fg': s:function_fg , 'gui': 'bold'}) |
                \ call s:h('Floaterm'                     , { 'bg': s:linenc_bg , 'fg': 'none'        , 'gui': 'none'}) |
                \ call s:h('FloatermBorder'               , { 'bg': s:linenc_bg , 'fg': s:linenc_fg   , 'gui': 'bold'}) |
                \ call s:h('CocExplorerNormalFloatBorder' , { 'bg': s:normal_bg , 'fg': s:linenc_bg   , 'gui': 'bold'}) |
                \ call s:h('CocExplorerNormalFloat'       , { 'bg': s:normal_bg , 'fg': 'none'        , 'gui': 'none'}) |
                \ call s:h('CocExplorerSelectUI'          , { 'bg': s:linenc_bg , 'fg': s:line_fg     , 'gui': 'bold'})
augroup end
"}}}
