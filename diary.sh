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

if [ -z ${DIARY_PREFIX} ]; then
	DIARY_PREFIX=${HOME}/diary
fi

year=$(LC_TIME=C date +'%Y')
month=$(LC_TIME=C date +'%m')
month_without_leading_zero=$(echo ${month} | sed 's/^0//')
day_without_leading_zero=$(LC_TIME=C date +'%d' | sed 's/^0//')

diary_file=${DIARY_PREFIX}/${year}/${month}

if [ ! -d ${DIARY_PREFIX}/${year} ]; then
	mkdir -p ${DIARY_PREFIX}/${year}
fi

if [ ! -f ${DIARY_PREFIX}/${year}/${month} ]; then
        echo "# ${year}/${month_without_leading_zero}" > ${diary_file}
fi

# write the header for the day if it does not exist
header="## ${month_without_leading_zero}/${day_without_leading_zero}"
if ! grep -F "${header}" ${DIARY_PREFIX}/${year}/${month} > /dev/null; then
	printf "\n${header}\n\n\n" >> ${diary_file}
fi

if [ -n ${EDITOR} ]; then
	exec ${EDITOR} ${diary_file}
else
	exec vi ${diary_file}
fi
