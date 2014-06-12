#!/bin/bash
#
# Script to repack the initrd to include the software repository,
# to enable PXE-only network installation.
#
# Copyright (c) 2009 Citrix Systems
#

#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#


if [ "$#" != 2 ] ; then
    echo "This script takes a path to the mounted CD as a parameter,">&2
    echo "and the filename to write out the repacked initrd to.">&2
    exit 1
fi
CDROM="$1"
OUTPUT="$2"

P_DOT_M="${CDROM}/packages.main"
if [ ! -d "${P_DOT_M}" ] ; then
    echo "Error: Could not find the repository at ${P_DOT_M}.">&2
    exit 2
fi

INITRD="${CDROM}/isolinux/rootfs.gz"
if [ ! -r "${INITRD}" ] ; then
    echo "Error: Could not read the ramdisk filesystem from ${INITRD}.">&2
    exit 3
fi

if [ -e "${OUTPUT}" ] ; then
    echo "Error: output file ${OUTPUT} already exists.">&2
    exit 4
fi

STAGING=$(mktemp -t)
if [ $? != 0 ] ; then
    echo "Error: could not create a temporary file.">&2
    exit 5
fi

gunzip <"${INITRD}" >"${STAGING}"
if [ $? != 0 ] ; then
    echo "Error: could not unzip the initrd.">&2
    rm "${STAGING}"
    exit 6
fi

cd "${CDROM}"
find packages.main -print | cpio -H newc -A -O "${STAGING}" -o
if [ $? != 0 ] ; then
    echo "Error: could not append to the new initrd.">&2
    rm "${STAGING}"
    exit 7
fi

cd -
gzip <"${STAGING}" >"${OUTPUT}"
if [ $? != 0 ] ; then
    echo "Error: could not compress the new initrd.">&2
    rm "${STAGING}"
    rm "${OUTPUT}"
    exit 8
fi
rm -f "${STAGING}"
exit 0
