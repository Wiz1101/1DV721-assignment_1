#!/bin/bash

# check if a directory is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Please provide a directory as an argument."
    exit 1
fi

# A backup of a directory (sent as argument)
dir=$1

# The backup file path
backup_file="/tmp/backup_$(date +%Y-%m-%d).tar.gz"



# check if a directory exists
if [ ! -d "$dir" ]; then
  echo "Error: Directory $dir does not exist"
  exit 1
fi

# check if a Backup file exists
if [ -f "$backup_file" ]; then
  echo "Error: Backup file $backup_file already exists"
  exit 1
fi

start=$(date +%s)
tar -czf "$backup_file" "$dir"
end=$(date +%s)

echo "Backup successfully created!"
echo "Execution time: $((end-start)) seconds"



