#!/bin/bash

AWK_PROG=/Users/linhai/mybin/getinfo.awk

show_usage()
{
    cat << EOF
Usage: $0 [PATH NAME]
EOF
    exit
}

if [ $# -eq 1 ]
then
        FILES_PATH=$1
else
        if [ $# -ne 0 ]
        then
                show_usage
	else
		FILES_PATH=.
        fi
fi

TEMP_PATH=tmp_`cat /dev/urandom | head -n 10 | md5 | cut -c 1-6`
mkdir $TEMP_PATH

for FILE_NAME in `ls "${FILES_PATH}"/*.Z`
do
	FILE_NAME=`basename "${FILE_NAME}"`
	HOST_NAME=`echo "${FILE_NAME}" | cut -f 1 -d.`
	TYPE_MODEL=`echo "${FILE_NAME}" | cut -f 2 -d.`
	MACHINE_SN=`echo "${FILE_NAME}" | cut -f 3 -d.`
	SUB_DIR_NAME=`echo "${FILE_NAME}" | cut -f 1-4 -d.`
	
	zcat "${FILES_PATH}/${FILE_NAME}" | tar xf - -C "${TEMP_PATH}" "${SUB_DIR_NAME}/lscfg-vp"

	$AWK_PROG -v host_name="${HOST_NAME}" -v type_model="${TYPE_MODEL}" -v machine_sn="${MACHINE_SN}" "${TEMP_PATH}/${SUB_DIR_NAME}/lscfg-vp"

#	echo $HOST_NAME $TYPE_MODEL $MACHINE_SN

done
rm -rf tmp*
