#!/bin/sh

# Generated manually;
#
# check the requirement's and create Makefile.
# configuration script for pnm's utilities. 

# defaults
export CWD="${PWD}"
export tab="$(printf '\t')"
export status="true"
export root=""
export prefix="/usr"

# parsing the options
while [ "${#}" -gt 0 ] ; do
    case "${1}" in
		--root|-r)
            shift
            [ -n "${1}" ] && {
                export root="${1}" 
                shift
            }
        ;;
        --prefix|-p)
            shift
            [ -n "${1}" ] && {
                export prefix="${1}"
                shift
            }
        ;;
        *)
            shift
        ;;
    esac
done

# check requirements
for i in "bash" "make" "cat" "cp" "mkdir" "ln" ; do
    if ! command -v "${i}" > /dev/null ; then
        printf "\tconfigure: command: '${i}' not found..\n"
        export status="false"
    fi
done

if [ "${status}" = "false" ] ; then
    exit 1
fi

# create Makefile
cat - > Makefile <<EOF
PREFIX  = ${root}${prefix}
LIBDIR  = \$(PREFIX)/local/lib/pnm
BINDIR  = \$(PREFIX)/bin

install:
${tab}bash alternatives.sh
${tab}mkdir -p \$(BINDIR) \$(LIBDIR)/bash
${tab}cp ./lib/bash/* \$(LIBDIR)/bash

uninstall:
${tab}rm \$(LIBDIR)/bash/realpath.sh

reinstall:
${tab}rm \$(LIBDIR)/bash/realpath.sh
${tab}bash alternatives.sh
${tab}mkdir -p \$(BINDIR) \$(LIBDIR)/bash
${tab}cp ./lib/bash/* \$(LIBDIR)/bash
EOF