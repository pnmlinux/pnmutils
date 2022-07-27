#!/bin/sh

set -e

export CWD="${PWD}"

while [ "${#}" -gt 0 ] ; do
    case "${1}" in 
        --root|-r)
            shift
            if [ -n "${1}" ] ; then
                export ROOT="${1}"
                shift
            fi
        ;;
        --prefix|-p)
            shift
            if [ -n "${1}" ] ; then
                export PREFIX="${1}"
                shift
            fi
        ;;
    esac
done

if command -v "git" ; then
    # from github.
    for x in "pnmlinux/pdb" "pnmlinux/md2roff" ; do
        case "${x##*/}" in
            md2roff)
                if command -v "md2roff" > /dev/null && [ -f "${root}/${prefix}/local/lib/bash5/makeman.sh" ] ; then
                    printf "${x##*/} is okay..\n"
                else
                    if ! [ -d "requirements/${x##*/}" ] ; then
                        git clone "https://github.com/${x}.git" "requirements/${x##*/}" || exit 1          
                        cd "requirements/${x##*/}"
                        if [ -f "configure" ] ; then
                            sh ./configure
                            if [ -f "Makefile" ] ; then
                                make
                            fi
                        elif [ -f "configure.sh" ] ; then
                            sh ./configure.sh
                            if [ -f "Makefile" ] ; then
                                make
                            fi
                        elif [ -f "Makefile" ] ; then
                            make
                        else
                            printf "could not configurate '${x##*/}'.\n"
                        fi

                        if ! command "${x##*/}" ; then 
                            make install
                        fi

                        if ! [ -f "${root}/${prefix}/local/lib/bash5/makeman.sh" ] ; then
                            cp ./makeman.sh "${root}/${prefix}/local/lib/bash5/makeman.sh"
                        fi

                        printf "${x##*/} is done..\n"
                    fi
                fi
            ;;
            pdb)
                if [ -f "${root}/${prefix}/local/lib/bash5/pdb.sh" ] ; then
                    printf "${x##*/} is okay..\n"
                else
                    git clone "https://github.com/${x}.git" "requirements/${x##*/}" || exit 1          
                    cd "requirements/${x##*/}"
                    if [ -f "configure" ] ; then
                        sh ./configure
                        if [ -f "Makefile" ] ; then
                            make
                        fi
                    elif [ -f "configure.sh" ] ; then
                        sh ./configure.sh
                        if [ -f "Makefile" ] ; then
                            make
                        fi
                    elif [ -f "Makefile" ] ; then
                        make
                    else
                        printf "could not configurate '${x##*/}'.\n"
                    fi
                    ln "${root}/${prefix}/local/lib/bash5/pdb.sh" "${root}/${prefix}/local/lib/pnm/bash/pdb.sh"
                fi
            ;;
        esac
        cd "${CWD}"
    done
fi