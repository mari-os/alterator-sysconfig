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

. install2-init-functions

mkdir -p "$destdir/etc/sysconfig/"

[ ! -f "/etc/sysconfig/i18n" ] ||
	install -Dm0644 "/etc/sysconfig/i18n" "$destdir/etc/sysconfig/i18n"

[ ! -f "/etc/sysconfig/langmap" ] ||
	install -Dm0644 "/etc/sysconfig/langmap" "$destdir/etc/sysconfig/langmap"

[ ! -f "/etc/sysconfig/consolefont" ] ||
	install -Dm0644 "/etc/sysconfig/consolefont" "$destdir/etc/sysconfig/consolefont"

[ ! -f "/etc/sysconfig/keyboard" ] ||
	install -Dm0644 "/etc/sysconfig/keyboard" "$destdir/etc/sysconfig/keyboard"

[ ! -f "/etc/X11/xinit/Xkbmap" -o ! -d "$destdir/etc/X11/xinit" ] ||
	install -Dm0644 "/etc/X11/xinit/Xkbmap" "$destdir/etc/X11/xinit/Xkbmap"

[ ! -f "/etc/locale.conf" ] ||
	install -Dm0644 "/etc/locale.conf" "$destdir/etc/locale.conf"
