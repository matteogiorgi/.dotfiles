# This minimal Qtile config file should work out of the box, the only thing
# fancy is the Mononoki font (if it isn't installed sans will be used in its
# place). I kept all default shortcuts as they are, just added new stuff.
# Do NOT fuck it up too much with piles of bloated rubbish, KISS!


import os
import subprocess

from pathlib import Path
from typing import List  # noqa: F401

from libqtile import layout, bar, widget, hook, qtile
from libqtile.config import Key, KeyChord, Screen, Group, Drag, Click
from libqtile.lazy import lazy


mod         = "mod4"

terminal    = 'lxterminal'
keyboards   = ['gb', 'it', 'us']
keynames    = {'gb': 'Gbr', 'it': 'Ita', 'us': 'Usa'}
wallpapers  = '~/Pictures/wallpapers/wallogo'


color_white       = 'BFBFBF'  #BFBFBF
color_black       = '1E1F29'  #1E1F29
color_dark        = '282A36'  #282A36
color_gray        = '626483'  #626483
color_blue        = '3A3C4E'  #3A3C4E
color_cyan        = '8BE9FD'  #8BE9FD
color_green       = '50FA7B'  #50FA7B
color_red         = 'FF5555'  #FF5555
color_orange      = 'FFB86C'  #FFB86C
color_yellow      = 'F1FA8C'  #F1FA8C
color_magenta     = 'FF79C6'  #FF79C6
color_purple      = 'BD93F9'  #BD93F9
color_lightred    = 'FF6E6E'  #FF6E6E

color_lightwhite  = 'A8A8B0'  #A8A8B0
color_lightblue   = '95A4DF'  #95A4DF
color_lightpurple = 'af8ce7'  #af8ce7

color_whitegray   = '86868E'  #86868E
color_bluegray    = '7783B2'  #7783B2
color_purplegray  = '8b71b8'  #8b71b8


last_playing = 'clementine'

def playpause(qtile):
    global last_playing
    if qtile.widgetMap['clementine'].is_playing() or last_playing == 'clementine':
        qtile.cmd_spawn("clementine --play-pause")
        last_playing = 'clementine'
    if qtile.widgetMap['spotify'].is_playing or last_playing == 'spotify':
        qtile.cmd_spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
        last_playing = 'spotify'

def next_prev(state):
    def f(qtile):
        if qtile.widgetMap['clementine'].is_playing():
            qtile.cmd_spawn("clementine --%s" % state)
        if qtile.widgetMap['spotify'].is_playing:
            cmd = "Next" if state == "next" else "Previous"
            qtile.cmd_spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.%s" % cmd)
    return f


keys = [
    # System keychords
    KeyChord([mod], "s", [                                                    #                 [S]
        Key([], "s", lazy.spawn("xfce4-settings-manager")),                   # settings        (S)
        Key([], "l", lazy.spawn("betterlockscreen -l dim")),                  # lockscreen      (L)
        Key([], "x", lazy.spawn("xkill")),                                    # xkill           (X)
        Key([], "q", lazy.shutdown()),                                        # exit            (Q)
        Key([], "r", lazy.restart()),                                         # restart         (R)
        Key(["shift"], "q", lazy.spawn("systemctl -i poweroff")),             # quit-systen     (Shift-Q)
        Key(["shift"], "r", lazy.spawn("systemctl reboot")),                  # reboot-systen   (Shift-R)
    ]),

    # Apps keychords
    KeyChord([mod], "a", [                                                    #                 [A]
        Key([], "a", lazy.spawncmd(prompt='$')),                              # prompt          (A)
        Key([], "k", lazy.spawn("kitty")),                                    # kitty           (K)
        Key([], "e", lazy.spawn("emacs")),                                    # emacs           (E)
        Key([], "f", lazy.spawn("firefox")),                                  # firefox         (F)
        Key([], "b", lazy.spawn("bgrandom")),                                 # background      (B)
        Key([], "l", lazy.spawn("laynext")),                                  # layout          (L)
        Key([], "i", lazy.spawn("keyinfo")),                                  # info            (I)
        Key([], "t", lazy.spawn(terminal + " -e tmux")),                      # tmux            (T)
        Key([], "m", lazy.spawn(terminal + " -e mocp")),                      # moc             (M)
        Key([], "c", lazy.spawn(terminal + " -e calcurse")),                  # calcurse        (C)
    ]),

    # Windows keychords
    KeyChord([mod], "w", [                                                    #                 [W]
        Key([], "w", lazy.next_layout()),                                     # window layout   (L)
        Key([], "f", lazy.window.toggle_floating()),                          # floating        (F)
        Key([], "i", lazy.window.toggle_minimize()),                          # iconify         (I)
        Key([], "m", lazy.window.toggle_maximize()),                          # maximize        (M)
        Key([], "s", lazy.layout.toggle_split()),                             # split           (S)
        Key([], "h", lazy.layout.swap_column_left()),                         # flip left       (H)
        Key([], "l", lazy.layout.swap_column_right()),                        # flip right      (L)
    ]),

    # Windows keymaps
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "0", lazy.layout.normalize()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

    # Windows ratio keymaps
    Key([mod, "control"], "j",
        lazy.layout.decrease_nmaster(),
        lazy.layout.grow_down()),
    Key([mod, "control"], "k",
        lazy.layout.increase_nmaster(),
        lazy.layout.grow_up()),
    Key([mod, "control"], "h",
        lazy.layout.decrease_ratio(),
        lazy.layout.grow_left()),
    Key([mod, "control"], "l",
        lazy.layout.increase_ratio(),
        lazy.layout.grow_right()),

    # Move between groups
    Key([mod], "Tab", lazy.screen.next_group()),                              # next group
    Key([mod], "BackSpace", lazy.screen.prev_group()),                        # previous group

    # Rofi keymap
    Key([mod], "space", lazy.spawn("rofirun -w")),                            # windows-menu
    Key([mod], "Return", lazy.spawn("rofirun -r")),                           # app-menu
    Key([mod], "Escape", lazy.spawn("rofirun -l")),                           # logout-menu


    # Volume (uncomment the one that works for you)

    # Solution 1
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 3")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 3")),
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t")),

    # Solution 2
    # Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q -D pulse sset Master 3%+")),
    # Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q -D pulse sset Master 3%-")),
    # Key([], "XF86AudioMute", lazy.spawn("amixer -q -D pulse sset Master toggle")),

    # Solution 3
    # Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q sset Master 3%+")),
    # Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q sset Master 3%-")),
    # Key([], "XF86AudioMute", lazy.spawn("amixer -q sset Master toggle")),

    # Solution 4 (seems to work on every conf)
    # Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +3%")),
    # Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -3%")),
    # Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),


    # Music controls
    Key([], "XF86AudioPlay", lazy.function(playpause)),
    Key([], "XF86AudioNext", lazy.function(next_prev("next"))),
    Key([], "XF86AudioPrev", lazy.function(next_prev("prev"))),


    # Backlight controls (is it working?)
    Key([], "XF86KbdBrightnessUp", lazy.spawn("maclight keyboard up")),
    Key([], "XF86KbdBrightnessDown", lazy.spawn("maclight keyboard down")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("maclight screen up")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("maclight screen down")),
]


# Groups management (main solution)
group_names = [
        ("₁ ", 1),
        ("₂ ", 2),
        ("₃ ", 3),
        ("₄ ", 4),
        ("₅ ", 5),
        ("₆ ", 6),
        ("₇ ", 7),
        ("₈ ", 8),
        ("₉ ", 9)
]
groups  = [Group(name, position=pos) for name, pos in group_names]
keylist = []

for (name, pos) in group_names:
    keys.append(Key([mod], str(pos), lazy.group[name].toscreen()))
    keys.append(Key([mod, "shift"], str(pos), lazy.window.togroup(name, switch_group=True)))
    keylist.append(Key([], str(pos), lazy.window.togroup(name, switch_group=False)))

# Move windows
keys.append(KeyChord([mod], "m", keylist))


# Groups management (alternative simple solution)
# groups = [Group(i, position=int(i)) for i in "123456789"]
# for i in groups:
#     keys.extend([
#         Key([mod], i.name, lazy.group[i.name].toscreen()),
#         Key([mod, "control"], i.name,
#             lazy.window.togroup(i.name, switch_group=True)),
#     ])


layout_theme_pile = dict(
    border_width=2,
    margin=10,
    margin_on_single=10,
    num_columns=1,
    insert_position=0,
    split=False,
    border_on_single=True,
    border_focus=color_white,
    border_focus_stack=color_white,
    border_normal=color_gray,
    border_normal_stack=color_gray
)

layout_theme_tile = dict(
    add_after_last=False,
    add_on_top=True,
    expand=True,
    master_length=1,
    ratio=0.5,
    ratio_increment=0.1,
    shift_windows=False,
    border_width=2,
    margin=10,
    border_focus=color_white,
    border_normal=color_gray
)


layouts = [
    layout.Columns(name='Pile', **layout_theme_pile),
    layout.Tile(name='Tile', **layout_theme_tile)
]


widget_defaults = dict(
    font='mononoki Nerd Font',
    fontsize=14,
    padding=6,
    background=color_dark,
    foreground=color_white
)
extension_defaults = widget_defaults.copy()


# Custom callbacks
def toggle_calcurse():
    home = str(Path.home())
    if os.path.exists(home+'/.local/share/calcurse/.calcurse.pid') or\
            os.path.exists(home+'/.calcurse/.calcurse.pid'):
        os.system('killall calcurse')  # os.remove(home+"...")
    else:
        qtile.cmd_spawn(terminal + ' -e calcurse')


# Widgets list on primary screen bar
widgets_primary_display = [
    widget.GroupBox(
        highlight_method='text',
        margin_y=2,
        borderwidth=0,
        active=color_gray,
        inactive=color_gray,
        hide_unused=True,
        this_current_screen_border=color_white,
        this_screen_border=color_white,
        other_current_screen_border=color_white,
        other_screen_border=color_white,
        disable_drag=True
    ),

    widget.Spacer(length=6),

    widget.TextBox(
        foreground=color_blue,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.TaskList(
        foreground=color_gray,
        border=color_white,
        borderwidth=0,
        highlight_method='text',
        rounded=False,
        icon_size=14,
        margin_y=-1,
        padding_y=3,
        max_title_width=200,
        title_width_method='None',
        txt_floating='FLO·',
        txt_minimized='ICO·',
        txt_maximized='MAX·',
        urgent_alert_method='text',
        urgent_border=color_orange
    ),

    widget.Spacer(length=36),

    ### dark 2 blue ###
    widget.TextBox(
        background=color_dark,
        foreground=color_blue,
        fontsize=17,
        text='',
        padding=0
    ),

    widget.Prompt(
        background=color_blue,
        foreground=color_yellow,
        cursor_color=color_yellow,
        prompt='{prompt} ',
        cursor=True,
        cursorblink=0.25
    ),

    widget.Cmus(
        background=color_blue,
        play_color=color_white,
        noplay_color=color_gray,
        max_chars=10
    ),

    widget.Moc(
        background=color_blue,
        play_color=color_white,
        noplay_color=color_gray,
        max_chars=10
    ),

    widget.Systray(
        background=color_blue,
        icon_size=16
    ),

    widget.Spacer(
        background=color_blue,
        length=8
    ),

    ### blue 2 lightwhite ###
    widget.TextBox(
        background=color_blue,
        foreground=color_lightwhite,
        fontsize=17,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_lightwhite, length=6),  # +0

    widget.TextBox(
        background=color_lightwhite,
        foreground=color_black,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_lightwhite, length=0),  # +4

    widget.Battery(
        background=color_lightwhite,
        foreground=color_black,
        format='{percent:2.0%}',
        padding=4
    ),

    widget.Spacer(background=color_lightwhite, length=2),  # +4

    widget.TextBox(
        background=color_lightwhite,
        foreground=color_whitegray,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_lightwhite, length=6),  # +0

    widget.TextBox(
        background=color_lightwhite,
        foreground=color_black,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_lightwhite, length=1),  # +5

    widget.PulseVolume(
        background=color_lightwhite,
        foreground=color_black,
        padding=5
    ),

    widget.Spacer(background=color_lightwhite, length=1),  # +5

    ### lightwhite 2 lightblue ###
    widget.Spacer(background='a7a8b2', length=1),
    widget.Spacer(background='a6a8b5', length=1),
    widget.Spacer(background='a5a7b7', length=1),
    widget.Spacer(background='a4a7b9', length=1),
    widget.Spacer(background='a3a7bc', length=1),
    widget.Spacer(background='a2a7be', length=1),
    widget.Spacer(background='a1a7c0', length=1),
    widget.Spacer(background='a0a6c3', length=1),
    widget.Spacer(background='9fa6c5', length=1),
    widget.Spacer(background='9ea6c8', length=1),
    widget.Spacer(background='9ea6ca', length=1),
    widget.Spacer(background='9da6cc', length=1),
    widget.Spacer(background='9ca5cf', length=1),
    widget.Spacer(background='9ba5d1', length=1),
    widget.Spacer(background='9aa5d3', length=1),
    widget.Spacer(background='99a5d6', length=1),
    widget.Spacer(background='98a5d8', length=1),
    widget.Spacer(background='97a4da', length=1),
    widget.Spacer(background='96a4dd', length=1),

    widget.Spacer(background=color_lightblue, length=6),  # +0

    widget.TextBox(
        background=color_lightblue,
        foreground=color_black,
        text=' ',
        padding=0
    ),

    widget.CurrentLayout(
        background=color_lightblue,
        foreground=color_black,
        padding=1
    ),

    widget.Spacer(background=color_lightblue, length=5),  # +1

    widget.TextBox(
        background=color_lightblue,
        foreground=color_bluegray,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_lightblue, length=6),  # +0

    widget.TextBox(
        background=color_lightblue,
        foreground=color_black,
        text=' ',
        padding=0
    ),

    widget.Spacer(background=color_lightblue, length=3),  # +0

    widget.KeyboardLayout(
        background=color_lightblue,
        foreground=color_black,
        configured_keyboards=keyboards,
        display_map=keynames,
        option='caps:swapescape',
        padding=0
    ),

    widget.Spacer(background=color_lightblue, length=3),  # +0

    ### lightblue 2 purple ###
    widget.Spacer(background='96a3df', length=1),
    widget.Spacer(background='98a2e0', length=1),
    widget.Spacer(background='99a0e0', length=1),
    widget.Spacer(background='9a9fe1', length=1),
    widget.Spacer(background='9c9ee1', length=1),
    widget.Spacer(background='9d9de1', length=1),
    widget.Spacer(background='9e9ce2', length=1),
    widget.Spacer(background='9f9ae2', length=1),
    widget.Spacer(background='a199e3', length=1),
    widget.Spacer(background='a298e3', length=1),
    widget.Spacer(background='a397e3', length=1),
    widget.Spacer(background='a596e4', length=1),
    widget.Spacer(background='a694e4', length=1),
    widget.Spacer(background='a793e5', length=1),
    widget.Spacer(background='a892e5', length=1),
    widget.Spacer(background='aa91e5', length=1),
    widget.Spacer(background='ab90e6', length=1),
    widget.Spacer(background='ac8ee6', length=1),
    widget.Spacer(background='ae8de7', length=1),

    widget.Spacer(background=color_lightpurple, length=4),

    widget.Wallpaper(
        background=color_lightpurple,
        foreground=color_black,
        directory=wallpapers,
        random_selection=True,
        wallpaper_command=['feh', '--bg-fill'],
        label=' Bgrn'
    ),

    widget.TextBox(
        background=color_lightpurple,
        foreground=color_purplegray,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_lightpurple, length=6),

    widget.TextBox(
        background=color_lightpurple,
        foreground=color_black,
        text=' ',
        padding=0
    ),

    widget.Clock(
        background=color_lightpurple,
        foreground=color_black,
        padding=0,
        format='%H:%M',
        mouse_callbacks={'Button1': toggle_calcurse}
    ),

    widget.Spacer(background=color_lightpurple, length=9)
]


# Widgets list on secondary screen bar
widgets_secondary_display = [
    widget.GroupBox(
        highlight_method='text',
        margin_y=2,
        borderwidth=0,
        active=color_gray,
        inactive=color_gray,
        hide_unused=True,
        this_current_screen_border=color_white,
        this_screen_border=color_white,
        other_current_screen_border=color_white,
        other_screen_border=color_white,
        disable_drag=True
    ),

    widget.Spacer(length=6),

    widget.TextBox(
        foreground=color_blue,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.TaskList(
        foreground=color_gray,
        border=color_white,
        borderwidth=0,
        highlight_method='text',
        rounded=False,
        icon_size=14,
        margin_y=-1,
        padding_y=3,
        max_title_width=200,
        title_width_method='None',
        txt_floating='FLO·',
        txt_minimized='ICO·',
        txt_maximized='MAX·',
        urgent_alert_method='text',
        urgent_border=color_orange
    ),

    widget.Spacer(length=36),

    ### dark 2 blue ###
    widget.TextBox(
        background=color_dark,
        foreground=color_blue,
        fontsize=17,
        text='',
        padding=0
    ),

    widget.Cmus(
        background=color_blue,
        play_color=color_white,
        noplay_color=color_gray,
        max_chars=10
    ),

    widget.Moc(
        background=color_blue,
        play_color=color_white,
        noplay_color=color_gray,
        max_chars=10
    ),

    widget.Spacer(
        background=color_blue,
        length=8
    ),

    ### blue 2 lightwhite ###
    widget.TextBox(
        background=color_blue,
        foreground=color_lightwhite,
        fontsize=17,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_lightwhite, length=6),  # +0

    widget.TextBox(
        background=color_lightwhite,
        foreground=color_black,
        text=' ',
        padding=0
    ),

    widget.CurrentLayout(
        background=color_lightwhite,
        foreground=color_black,
        padding=1
    ),

    widget.Spacer(background=color_lightwhite, length=6),  # +0

    widget.TextBox(
        background=color_lightwhite,
        foreground=color_whitegray,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_lightwhite, length=6),  # +0

    widget.TextBox(
        background=color_lightwhite,
        foreground=color_black,
        text=' ',
        padding=0
    ),

    widget.Clock(
        background=color_lightwhite,
        foreground=color_black,
        padding=0,
        format='%H:%M',
        mouse_callbacks={'Button1': toggle_calcurse}
    ),

    widget.Spacer(background=color_lightwhite, length=9)
]


screens = [
    Screen(
        top=bar.Bar(widgets_primary_display, 20),
        bottom=bar.Gap(0),
        left=bar.Gap(0),
        right=bar.Gap(0)
    ),
    Screen(
        top=bar.Bar(widgets_secondary_display, 20),
        bottom=bar.Gap(0),
        left=bar.Gap(0),
        right=bar.Gap(0)
    ),
]


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]


dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=color_white,
    border_normal=color_gray,
    border_width=2,
    float_rules=[
        # Run utility of `xprop` to see the wm class and name of an X client.
        {'wmclass': 'confirm'},
        {'wmclass': 'dialog'},
        {'wmclass': 'download'},
        {'wmclass': 'error'},
        {'wmclass': 'file_progress'},
        {'wmclass': 'notification'},
        {'wmclass': 'splash'},
        {'wmclass': 'toolbar'},
        {'wmclass': 'confirmreset'},  # gitk
        {'wmclass': 'makebranch'},    # gitk
        {'wmclass': 'maketag'},       # gitk
        {'wname': 'branchdialog'},    # gitk
        {'wname': 'pinentry'},        # GPG key password entry
        {'wmclass': 'ssh-askpass'},   # ssh-askpass
    ])
auto_fullscreen = True
focus_on_window_activation = "smart"


# Some windows are better looking in floating mode
# (keep in mind I use Xfce4-settings package)
@hook.subscribe.client_new
def idle_dialogues(window):
    if((window.window.get_name() == 'Settings') or
       (window.window.get_name() == 'Kupfer') or
       (window.window.get_name() == 'Network Connections') or
       (window.window.get_name() == 'Bluetooth Devices') or
       (window.window.get_name() == 'Print Settings - localhost') or
       (window.window.get_name() == 'Appearance') or
       (window.window.get_name() == 'Qt5 Configuration Tool') or
       (window.window.get_name() == 'Default Applications') or
       (window.window.get_name() == 'Notifications') or
       (window.window.get_name() == 'Display') or
       (window.window.get_name() == 'Keyboard') or
       (window.window.get_name() == 'Mouse and Touchpad') or
       (window.window.get_name() == 'Volume Control') or
       (window.window.get_name() == 'Power Manager')):
        window.floating = True


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.Popen([home + '/.config/qtile/autostart.sh'])


# @hook.subscribe.layout_change
# def _(lay, grp):
#     if lay.name == "Doub":
#         screens[0].bottom=bar.Gap(5)
#         screens[0].left=bar.Gap(5)
#         screens[0].right=bar.Gap(5)
#         screens[1].bottom=bar.Gap(5)
#         screens[1].left=bar.Gap(5)
#         screens[1].right=bar.Gap(5)
#     else:
#         screens[0].bottom=bar.Gap(0)
#         screens[0].left=bar.Gap(0)
#         screens[0].right=bar.Gap(0)
#         screens[1].bottom=bar.Gap(0)
#         screens[1].left=bar.Gap(0)
#         screens[1].right=bar.Gap(0)

#     grp.layout_all()


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.


wmname = "LG3D"
