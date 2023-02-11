#!/bin/bash

# check if a directory is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Please provide a directory as an argument."
    exit 1
fi

# A backup of a directory (sent as argument)
dir=$1

# The backup file path
backup="/tmp/backup_$(date +%Y-%m-%d).tar.gz"



# check if a directory exists
if [ ! -d "$dir" ]; then
  echo "Error: Directory $dir does not exist"
  exit 1
fi

# check if a Backup file exists
if [ -f "$backup" ]; then
  echo "Error: Backup file $backup already exists"
  exit 1
fi

#create a zip file
tar -czf "$backup" "$dir" 
start=$(date +%s)
end=$(date +%s)

echo "Backup successfully created!"
echo "Execution time: $((end-start)) seconds"



