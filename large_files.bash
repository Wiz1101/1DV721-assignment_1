#!/bin/bash

# check if a directory is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Please provide a directory as an argument."
    exit 1
fi

# Check if the direcory exists
if [ ! -d "$1" ]; then
  echo "Error: Directory '$1' does not exist"
  exit 1
fi

# Recursively find all files and their size
find "$1" -type f -printf "%s\t%p\n" | sort -nr > /tmp/large_files.txt

# Get the number of files scanned and total file size
file_count=$(wc -l < /tmp/large_files.txt)
total_size=$(awk '{sum+=$1} END {print sum}' /tmp/large_files.txt)

# Write the report on the 5 largest files
echo "5 largest files:"
head -n 5 /tmp/large_files.txt | awk '{printf "%d\t%s\n", $1, $2}'

# Calculate the total size of these 5 files
top_5_size=$(head -n 5 /tmp/large_files.txt | awk '{sum+=$1} END {print sum}')

# Write the total number of files scanned and the total file size
echo ""
echo "Total number of files scanned: $file_count"
echo "Total size of all files: $total_size"
echo "Total size of the 5 largest files: $top_5_size"

# Clean up
rm /tmp/large_files.txt
