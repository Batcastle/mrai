#!/bin/bash
# -*- coding: utf-8 -*-
#
#  edit-apt-sources.sh
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
#VERSION 0.1.5-beta1
set -e
set -o pipefail
file="$1"
usr=$(/usr/bin/users)
cache="/etc/mrai"
int=0
scripts="/usr/share/mrai"
called_as="$0"
R='\033[0;31m'
G='\033[0;32m'
NC='\033[0m'
#report errors
error_report () {
	/bin/echo -e "\n$R \bERROR:$NC $2\n"
	"$scripts"/log-out.sh "$1" "/usr/share/mrai/edit-apt-sources.sh" "$2" "$called_as" "$(/bin/pwd)"
	if [[ "$1" != "1" ]]; then
		exit "$1"
	fi
}
{
	while [ "$int" == "0" ]; do
		if [ -f /home/"$usr"/.selected_editor ] || [ -f "$cache"/selected_editor.conf ]; then
			if [ ! -f /home/"$usr"/.selected_editor ] && [ -f "$cache"/selected_editor.conf ]; then
				editor=$(/bin/cat "$cache"/selected_editor.conf | /bin/grep 'SELECTED_EDITOR=' | /bin/sed 's/SELECTED_EDITOR=//g')
				int="1"
			elif [ -f /home/"$usr"/.selected_editor ] && [ ! -f "$cache"/selected_editor.conf ]; then
				editor=$(/bin/cat /home/"$usr"/.selected_editor | /bin/grep 'SELECTED_EDITOR=' | /bin/sed 's/SELECTED_EDITOR=//g')
				/bin/cp /home/"$usr"/.selected_editor "$cache"/selected_editor.conf
				/bin/chown "$usr:$usr" $"cache"/selected_editor.conf
				int="1"
			elif [ -f /home/"$usr"/.selected_editor ] && [ -f "$cache"/selected_editor.conf ]; then
				editor=$(/bin/cat "$cache"/selected_editor.conf | /bin/grep 'SELECTED_EDITOR=' | /bin/sed 's/SELECTED_EDITOR=//g')	
				int="1"
			else
				exit 2
			fi
		else
			/usr/bin/select-editor
		fi
	done
} || {
	error_report "$?" "Could not parse selected_editor.conf or .selected-editor. Most likly file system permissions issue."
}
{
	{
		/bin/cp "$file" "$file.bak"
		eval "$editor $1"
	} || {
		error_report "$?" "Could not manipulate $file. Most likely not running as root or incorrect file system permissions."
	}
} && {
	{
		/bin/echo -e "\n$G \bUpdating Apt Repository Cache . . .\n"
		/usr/bin/apt update
	} || {
		error_report "$?" "apt update failed. Most likly bad network connection."
	}
} && {
	/bin/echo -e "\n$G \bConfiguring Apt Repos Complete!\n"
}