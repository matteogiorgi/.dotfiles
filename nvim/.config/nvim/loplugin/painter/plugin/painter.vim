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
                \ let s:linenc_bg = s:colorpicker('StatusLineNC' , 'guibg') |
                \ let s:linenc_fg = s:colorpicker('StatusLineNC' , 'guifg') |
                \ let s:normal_bg = s:colorpicker('Normal'       , 'guibg') |
                \ let s:normal_fg = s:colorpicker('Normal'       , 'guifg') |
                \ call s:h('VertSplit'                    , { 'bg': s:normal_bg , 'fg': s:linenc_bg , 'gui': 'bold'}) |
                \ call s:h('WhichKeyFloating'             , { 'bg': s:linenc_bg , 'fg': 'none'      , 'gui': 'bold'}) |
                \ call s:h('Floaterm'                     , { 'bg': s:linenc_bg , 'fg': 'none'      , 'gui': 'none'}) |
                \ call s:h('FloatermBorder'               , { 'bg': s:linenc_bg , 'fg': s:linenc_fg , 'gui': 'bold'}) |
                \ call s:h('CocExplorerNormalFloatBorder' , { 'bg': s:normal_bg , 'fg': s:linenc_bg , 'gui': 'bold'}) |
                \ call s:h('CocExplorerNormalFloat'       , { 'bg': s:normal_bg , 'fg': 'none'      , 'gui': 'none'}) |
                \ call s:h('CocExplorerSelectUI'          , { 'bg': s:linenc_bg , 'fg': s:normal_fg , 'gui': 'bold'})
augroup end
"}}}
