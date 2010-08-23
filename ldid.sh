#!/bin/bash

# Cydia Substrate - Powerful Code Insertion Platform
# Copyright (C) 2008-2010  Jay Freeman (saurik)

# GNU Lesser General Public License, Version 3 {{{
#
# Cycript is free software: you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# Cycript is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
# License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Cycript.  If not, see <http://www.gnu.org/licenses/>.
# }}}

file=$1
shift 1

archs=($(lipo -detailed_info "${file}" | grep '^architecture ' | cut -d ' ' -f 2))

if [[ ${#archs[@]} == 0 ]]; then
    ldid -S "${file}"
else
    files=()

    for arch in "${archs[@]}"; do
        lipo -extract "${arch}" "${file}" -output "${file}.${arch}"
        if [[ ${arch} == arm* ]]; then ldid -S "${file}.${arch}"; fi
        files[${#files[@]}]=${file}.${arch}
    done

    lipo -create "${files[@]}" -output "${file}"
    rm -f "${files[@]}"
fi
