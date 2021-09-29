---------------------------
-- Doom awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()  -- "~/.config/awesome/themes"
local theme = {}

theme.font          = "mononoki Nerd Font 9"

theme.bg_normal     = "#282a36"
theme.bg_focus      = "#282a36"
theme.bg_urgent     = "#282a36"
theme.bg_minimize   = "#282a36"
theme.bg_systray    = "#282a36"

theme.fg_normal     = "#bfbfbf"
theme.fg_focus      = "#ffb68c"
theme.fg_urgent     = "#ff92df"
theme.fg_minimize   = "#626483"

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(1)
theme.border_normal = "#bfbfbf"
theme.border_focus  = "#ffb68c"
theme.border_marked = "#ff92df"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
-- theme.taglist_bg_focus = "#ff0000"


-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)


-- Variables set for theming the menu:
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)


-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
theme.tasklist_disable_icon = false


return theme
