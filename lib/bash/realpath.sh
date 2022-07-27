#!/bin/bash

#    emulate the realpath in bash - realpath rewritten for bash.
#    Copyright (C) 2022  lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# source: https://gist.github.com/lazypwny751/cb3715cd5cff388b8e172f958598c304

pnm:realpath() {
    # emulate real path, this function can't show real path only theory.
    if [[ -n "${1}" ]] ; then
        if [[ "${1:0:1}" = "/" ]] ; then
            local CWD=""
        else
            local CWD="${PWD//\// }"
        fi

        local realpath="${1//\// }"
        local i="" markertoken="/"

        for i in ${CWD} ${realpath} ; do
            if [[ "${i}" = "." ]] ; then
                setpath="${setpath}"
            elif [[ "${i}" = ".." ]] ; then
                setpath="${setpath%/*}"
            else
                case "${i}" in
                    ""|" ")
                        :
                    ;;
                    *)
                        setpath+="${markertoken}${i}"
                    ;;
                esac
            fi
        done

        if [[ -z "${setpath}" ]] ; then
            setpath="${markertoken}"
        fi

        echo "${setpath}"
    else
        echo -e "\t${FUNCNAME##*:}: insufficient parameter."
        return 1
    fi
}

if [[ "${BASH_SOURCE}" = "${BASH_SOURCE[-1]}" ]] ; then
    realpath "${1}"
fi