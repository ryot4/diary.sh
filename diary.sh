#!/bin/sh

# Copyright (c) 2016, FUJII Ryota
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

edit()
{
    year=$(date +%Y)
    month=$(date +%m)
    day=$(date +%d)
    case "$DIARY_MODE" in
    day)
        diary_file="$DIARY_DIR/$year/$month/$day"
        ;;
    month)
        diary_file="$DIARY_DIR/$year/$month"
        ;;
    *)
        echo "unknown mode: \"$DIARY_MODE\""
        exit 1
        ;;
    esac
    dir="$(dirname "$diary_file")"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
    exec "${EDITOR:-vi}" "$diary_file"
}

search()
{
    grep -r "$1" "$DIARY_DIR" | sed "s|^$DIARY_DIR/||"
}

while getopts d:m: opt; do
    case $opt in
    d)
        DIARY_DIR="$OPTARG"
        ;;
    m)
        DIARY_MODE="$OPTARG"
        ;;
    esac
done
shift $((OPTIND - 1))

[ -n "$DIARY_DIR" ] || DIARY_DIR="$HOME/diary"
[ -n "$DIARY_MODE" ] || DIARY_MODE=day

cmd="$1"
shift

case "$cmd" in
edit|'')
    edit
    ;;
search)
    search "$*"
    ;;
*)
    echo "unknown command \"$cmd\""
    exit 1
    ;;
esac
