#!/bin/bash
# -*- coding: utf-8 -*-
#
#  base-spinner.sh
#  
#  Copyright 2019 Thomas Castleman <contact@draugeros.org>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#
#VERSION: 0.0.8-beta1
#
#Passed Options Need To Be:
# $1: Message to display
# $2: PID to watch. Will exit when PID disappears
sp="/-\|"
i=1
message="$1"
while [ -d "/proc/$2" ]; do
	/bin/sleep 0.25s
	/usr/bin/printf "\r\033[K"
	/usr/bin/printf "[${sp:i++%${#sp}:1}] $message"
done
/usr/bin/printf "\r\033[K"