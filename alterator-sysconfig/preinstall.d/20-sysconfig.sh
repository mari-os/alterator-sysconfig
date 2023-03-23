#!/bin/sh -efu
# ***** BEGIN LICENSE BLOCK *****
# * Copyright (C) 2007  Alexey Gladkov <legion@altlinux.org>
# *
# * This program is free software; you can redistribute it and/or modify
# * it under the terms of the GNU General Public License as published by
# * the Free Software Foundation; either version 2 of the License, or
# * (at your option) any later version.
# *
# * This program is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# * GNU General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with this program; if not, write to the Free Software
# * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
# ***** END LICENSE BLOCK *****

SYSCONFIG_KEYBOARD="/etc/sysconfig/keyboard"
SYSCONFIG_CONSOLEFONT="/etc/sysconfig/consolefont"
VCONSOLE_CONF="/etc/vconsole.conf"
X11_KEYBOARD_CONF="/etc/X11/xorg.conf.d/00-keyboard.conf"

. install2-init-functions
. shell-config

mkdir -p "$destdir/etc/sysconfig/"

[ ! -f "/etc/sysconfig/i18n" ] ||
	install -Dm0644 "/etc/sysconfig/i18n" "$destdir/etc/sysconfig/i18n"

[ ! -f "/etc/sysconfig/langmap" ] ||
	install -Dm0644 "/etc/sysconfig/langmap" "$destdir/etc/sysconfig/langmap"

[ ! -f "$SYSCONFIG_CONSOLEFONT" ] ||
	install -Dm0644 "$SYSCONFIG_CONSOLEFONT" "$destdir/$SYSCONFIG_CONSOLEFONT"

[ ! -f "$SYSCONFIG_KEYBOARD" ] ||
	install -Dm0644 "$SYSCONFIG_KEYBOARD" "$destdir/$SYSCONFIG_KEYBOARD"

if [ -f "/etc/X11/xinit/Xkbmap" -o -d "$destdir/etc/X11/xinit" ]; then
	layout=`shell_config_get "/etc/X11/xinit/Xkbmap" "-layout" "[[:space:]]" | awk '$1=$1' 2>/dev/null`
	options=`shell_config_get "/etc/X11/xinit/Xkbmap" "-option" "[[:space:]]" | awk '$1=$1' 2>/dev/null`

	install -Dm0644 /dev/null "$destdir/$X11_KEYBOARD_CONF"
cat > "$destdir/$X11_KEYBOARD_CONF" << EOF
Section "InputClass"
Identifier "system-keyboard"
MatchIsKeyboard "on"
	Option "XkbLayout" "$layout"
	Option "XkbOptions" "$options"
EndSection
EOF
fi

[ ! -f "/etc/locale.conf" ] ||
	install -Dm0644 "/etc/locale.conf" "$destdir/etc/locale.conf"

[ ! -e "$destdir/$VCONSOLE_CONF" ] && install -Dm0644 /dev/null "$destdir/$VCONSOLE_CONF" || :
if [ -e "$SYSCONFIG_KEYBOARD" -a -e "$SYSCONFIG_CONSOLEFONT" ]; then
	unset SYSFONT
	unset SYSFONTACM
	unset UNIMAP
	unset KEYTABLE

	[ -e "$SYSCONFIG_KEYBOARD" ] && . "$SYSCONFIG_KEYBOARD" &>/dev/null || :
	[ -e "$SYSCONFIG_CONSOLEFONT" ] && . "$SYSCONFIG_CONSOLEFONT" &>/dev/null || :
	[ -n "${SYSFONT-}" ] && shell_config_set "$destdir/$VCONSOLE_CONF" "FONT" $SYSFONT 2>&1 || :
	[ -n "${SYSFONTACM-}" ] && shell_config_set "$destdir/$VCONSOLE_CONF" "FONT_MAP" $SYSFONTACM 2>&1 || :
	[ -n "${UNIMAP-}" ] && shell_config_set "$destdir/$VCONSOLE_CONF" "FONT_UNIMAP" $UNIMAP 2>&1 || :
	[ -n "${KEYTABLE-}" ] && shell_config_set "$destdir/$VCONSOLE_CONF" "KEYMAP" $KEYTABLE 2>&1 || :
fi
