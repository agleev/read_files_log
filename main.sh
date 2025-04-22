#!/bin/bash

extract_datetime(){
    local input_str1=$1
    local input_str2=$2
    datetime=$(echo "$input_str1" | grep -oP '\[\K[0-9- :]+(?=\])')
    datetime=$(echo "$input_str2" | grep -oP '\[\K[0-9- :]+(?=\])')
    timestamp1=$(date -d "$datetime1" +%s)
    timestamp2=$(date -d "$datetime2" +%s)
    diff_seconds=$((timestamp2 - timestamp1))
    diff_minutes=$((diff_seconds / 60))    
    echo "Time: $diff_minutes" >> $LOG
}

parce_log_file(){
    local subdir=$1
    log_files=$(find $subdir -maxdepth 1 -type f -name "*.log")
    for log_file in $log_files; do
        basename_sub_dir=$(basename $subdir)
        name_log_file=$(basename $log_file)
        basename_log_file="${name_log_file%.*}"

        if [ "$basename_log_file" == "$basename_sub_dir" ]; then

            local first=$(head -n 1 "$log_file")
            local last=$(tail -n 1 "$log_file")
            
            echo "Source $basename_sub_dir" >> $LOG
            echo "$first" >> $LOG
            echo "$last" >> $LOG
            extract_datetime $first $last
            echo "" >> $LOG

        fi
    done
}


DATA=$1
LOG=$2

if [ -z $DATA ]; then
    echo "Data dir is empty"
    exit 1
else
    if [ ! -e $DATA ]; then
        echo "Data dir dont exists"
        exit 1
    fi
fi


if [ -z $LOG ]; then
    LOG="$PWD/log.log"
    > $LOG
fi

SUBDIRS=$(ls -d $DATA/*/)


for subdata in $SUBDIRS; do
    parce_log_file $subdata
done
echo "Complete"
