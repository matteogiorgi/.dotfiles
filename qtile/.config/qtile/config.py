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

webbrowser  = "brave"
terminal    = "alacritty"
keyboards   = ['gb', 'it', 'us']
keynames    = {'gb': 'Gbr', 'it': 'Ita', 'us': 'Usa'}
wallpapers  = '~/Pictures/wallpapers/wallogo'


color_white      = 'BFBFBF'  #BFBFBF
color_black      = '1E1F29'  #1E1F29
color_dark       = '282A36'  #282A36
color_gray       = '626483'  #626483
color_blue       = '3A3C4E'  #3A3C4E
color_cyan       = '8BE9FD'  #8BE9FD
color_green      = '50FA7B'  #50FA7B
color_red        = 'FF5555'  #FF5555
color_orange     = 'FFB86C'  #FFB86C
color_yellow     = 'F1FA8C'  #F1FA8C
color_magenta    = 'FF79C6'  #FF79C6
color_purple     = 'BD93F9'  #BD93F9
color_lightblue  = '6B89FF'  #6B89FF

color_whitegray  = '97979a'  #97979a
color_bluegray   = '586ECA'  #586ECA
color_purplegray = '9576c5'  #9576c5


last_playing = 'spotify'

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
        Key([], "q", lazy.shutdown()),                                        # quit            (Q)
        Key([], "r", lazy.restart()),                                         # restart         (R)
        Key([], "s", lazy.spawn("xfce4-settings-manager")),                   # settings        (S)
        Key([], "x", lazy.spawn("xkill")),                                    # xkill           (X)
    ]),

    # Windows keychords
    KeyChord([mod], "w", [                                                    #                 [W]
        Key([], "f", lazy.window.toggle_floating()),                          # floating        (F)
        Key([], "i", lazy.window.toggle_minimize()),                          # iconify         (I)
        Key([], "m", lazy.window.toggle_maximize()),                          # maximize        (M)
    ]),

    # Apps keychords
    KeyChord([mod], "a", [                                                    #                 [A]
        Key([], "j", lazy.spawncmd(prompt='$')),                              # prompt          (J)
        Key([], "k", lazy.spawn("kupfer")),                                   # kupfer          (K)
        Key([], "h", lazy.spawn("keyinfo")),                                  # keyinfo         (H)
        Key([], "b", lazy.spawn("bgrandom")),                                 # background      (B)
        Key([], "l", lazy.spawn("laynext")),                                  # layout          (L)
        Key([], "w", lazy.spawn(webbrowser)),                                 # webbrowser      (W)
        Key([], "a", lazy.spawn(terminal)),                                   # term            (A)
        Key([], "t", lazy.spawn(terminal+" -e tmux")),                        # tmux            (T)
        Key([], "m", lazy.spawn(terminal+" -e mocp")),                        # moc             (M)
        Key([], "c", lazy.spawn(terminal+" -e calcurse")),                    # calcurse        (C)
    ]),

    # Windows keymaps
    Key([mod], "q", lazy.window.kill()),                                      # kill window
    Key([mod], "f", lazy.layout.flip()),                                      # switch master-stack
    Key([mod], "j", lazy.layout.shuffle_down()),                              # move window down
    Key([mod], "k", lazy.layout.shuffle_up()),                                # move window up

    # Change layout and move through windows
    Key([mod], "BackSpace", lazy.next_layout()),                              # next layout
    Key([mod], "space", lazy.layout.down()),                                  # next window

    # Move between groups
    Key([mod], "h", lazy.screen.prev_group()),                                # previous group
    Key([mod], "l", lazy.screen.next_group()),                                # next group

    # Change windows ratios manually
    Key([mod], "plus", lazy.layout.grow()),                                   # plus
    Key([mod], "minus", lazy.layout.shrink()),                                # minus
    Key([mod], "0", lazy.layout.normalize()),                                 # zero

    # Rofi-menu keymaps
    Key([mod], "Return", lazy.spawn("rofirun -r")),                           # super-menu
    Key([mod], "Escape", lazy.spawn("rofirun -l")),                           # logout-menu
    Key([mod], "Tab", lazy.spawn("rofirun -w")),                              # windows-menu


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
        ("₁ ", 1),
        ("₂ ", 2),
        ("₃ ", 3),
        ("₄ ", 4),
        ("₅ ", 5),
        ("₆ ", 6),
        ("₇ ", 7),
        ("₈ ", 8),
        ("₉ ", 9)
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


layout_theme_columns = dict(
    border_width=2,
    margin=20,
    num_columns=1,
    split=False,
    border_on_single=True,
    border_focus_stack=color_white,
    border_normal_stack=color_gray
)

layout_theme_monad = dict(
    border_width=2,
    margin=20,
    border_focus=color_white,
    border_normal=color_gray
)


layouts = [
    layout.Columns(name='Pile', **layout_theme_columns),
    layout.MonadTall(name='Tall', **layout_theme_monad),
    layout.MonadWide(name='Wide', **layout_theme_monad),
    # layout.Floating(name='Float', **layout_theme_monad),
    # layout.Max(name='Max'),
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
        qtile.cmd_spawn(terminal+' -e calcurse')


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
        txt_floating='*',
        txt_minimized='-',
        txt_maximized='+',
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

    ### blue 2 white ###
    widget.TextBox(
        background=color_blue,
        foreground=color_white,
        fontsize=17,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_white, length=6),  # +0

    widget.TextBox(
        background=color_white,
        foreground=color_black,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_white, length=0),  # +4

    widget.Battery(
        background=color_white,
        foreground=color_black,
        format='{percent:2.0%}',
        padding=4
    ),

    widget.Spacer(background=color_white, length=2),  # +4

    widget.TextBox(
        background=color_white,
        foreground=color_whitegray,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_white, length=6),  # +0

    widget.TextBox(
        background=color_white,
        foreground=color_black,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_white, length=1),  # +5

    widget.PulseVolume(
        background=color_white,
        foreground=color_black,
        padding=5
    ),

    widget.Spacer(background=color_white, length=1),  # +5

    ### white 2 lightblue ###
    widget.Spacer(background='bbbcc2', length=1),
    widget.Spacer(background='b7bac5', length=1),
    widget.Spacer(background='b2b7c9', length=1),
    widget.Spacer(background='aeb4cc', length=1),
    widget.Spacer(background='aab2cf', length=1),
    widget.Spacer(background='a6afd2', length=1),
    widget.Spacer(background='a2acd5', length=1),
    widget.Spacer(background='9da9d9', length=1),
    widget.Spacer(background='99a7dc', length=1),
    widget.Spacer(background='95a4df', length=1),
    widget.Spacer(background='91a1e2', length=1),
    widget.Spacer(background='8d9fe5', length=1),
    widget.Spacer(background='889ce9', length=1),
    widget.Spacer(background='8499ec', length=1),
    widget.Spacer(background='8096ef', length=1),
    widget.Spacer(background='7c94f2', length=1),
    widget.Spacer(background='7891f5', length=1),
    widget.Spacer(background='738ef9', length=1),
    widget.Spacer(background='6f8cfc', length=1),

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
    widget.Spacer(background='6f8aff', length=1),
    widget.Spacer(background='738afe', length=1),
    widget.Spacer(background='778afe', length=1),
    widget.Spacer(background='7b8bfe', length=1),
    widget.Spacer(background='808cfe', length=1),
    widget.Spacer(background='848cfd', length=1),
    widget.Spacer(background='888cfd', length=1),
    widget.Spacer(background='8c8dfd', length=1),
    widget.Spacer(background='908efc', length=1),
    widget.Spacer(background='948efc', length=1),
    widget.Spacer(background='988efc', length=1),
    widget.Spacer(background='9c8ffb', length=1),
    widget.Spacer(background='a090fb', length=1),
    widget.Spacer(background='a490fb', length=1),
    widget.Spacer(background='a890fa', length=1),
    widget.Spacer(background='ad91fa', length=1),
    widget.Spacer(background='b192fa', length=1),
    widget.Spacer(background='b592fa', length=1),
    widget.Spacer(background='b992f9', length=1),

    widget.Spacer(background=color_purple, length=4),

    widget.Wallpaper(
        background=color_purple,
        foreground=color_black,
        directory=wallpapers,
        random_selection=True,
        wallpaper_command=['feh', '--bg-fill'],
        label=' Bgrn'
    ),

    widget.TextBox(
        background=color_purple,
        foreground=color_purplegray,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_purple, length=6),

    widget.TextBox(
        background=color_purple,
        foreground=color_black,
        text=' ',
        padding=0
    ),

    widget.Clock(
        background=color_purple,
        foreground=color_black,
        padding=0,
        format='%H:%M',
        mouse_callbacks={'Button1': toggle_calcurse}
    ),

    widget.Spacer(background=color_purple, length=9)
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
        txt_floating='*',
        txt_minimized='-',
        txt_maximized='+',
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

    ### blue 2 white ###
    widget.TextBox(
        background=color_blue,
        foreground=color_white,
        fontsize=17,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_white, length=6),  # +0

    widget.TextBox(
        background=color_white,
        foreground=color_black,
        text=' ',
        padding=0
    ),

    widget.CurrentLayout(
        background=color_white,
        foreground=color_black,
        padding=1
    ),

    widget.Spacer(background=color_white, length=6),  # +0

    widget.TextBox(
        background=color_white,
        foreground=color_whitegray,
        fontsize=10,
        text='',
        padding=0
    ),

    widget.Spacer(background=color_white, length=6),  # +0

    widget.TextBox(
        background=color_white,
        foreground=color_black,
        text=' ',
        padding=0
    ),

    widget.Clock(
        background=color_white,
        foreground=color_black,
        padding=0,
        format='%H:%M',
        mouse_callbacks={'Button1': toggle_calcurse}
    ),

    widget.Spacer(background=color_white, length=9)
]


screens = [
    Screen(top=bar.Bar(widgets_primary_display, 20)),
    Screen(top=bar.Bar(widgets_secondary_display, 20)),
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


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.


wmname = "LG3D"
