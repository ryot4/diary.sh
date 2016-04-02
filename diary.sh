#!/bin/sh

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
