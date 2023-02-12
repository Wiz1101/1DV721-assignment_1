#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
  echo "[ERROR]:Please provide a URL as an argument."
  exit 1
fi

# Download the resource
wget $1 -q -O resource.bin

echo "~~~~~~~~~~~~~~START TO ANALYSE..."
echo ""
# Determine the type of file 
file_type=$(file resource.bin)
echo "Type of file: $file_type"

# Determine the size of the file
file_size=$(wc -c resource.bin | awk '{print $1}')
echo "Size of file: $file_size bytes"

# -----------------------------------------
if [[ $file_type == *"ASCII text"* ]]; then
  # Analyze the text file

  # Count the number of lines in the file
  lines=$(wc -l < resource.bin)
  echo "Number of lines in the file: $lines"

  # Count the number of words in the file
  words=$(wc -w < resource.bin)
  echo "Number of words in the file: $words"

  # Count the number of spaces in the file
  spaces=$(grep -o " " resource.bin | wc -l)
  echo "Number of spaces in the file: $spaces"

  # Print the first line of the file
  first_line=$(head -n 1 resource.bin)
  echo "First line of the file: $first_line"

  # Print the last line of the file
  last_line=$(tail -n 1 resource.bin)
  echo "Last line of the file: $last_line"

else
  # Analyze the binary file

  # Count the number of bytes in the file
  bytes=$(wc -c < resource.bin)
  echo "Number of bytes in the file: $bytes"

  # Print the 10-ish first bytes of the file in printable representation
  echo "First 10-ish bytes of the file in printable representation: "
  hexdump -C -n 10 resource.bin

  # Print the 10-ish last bytes of the file in printable representation
  echo "Last 10-ish bytes of the file in printable representation: "
  hexdump -C -s -10 resource.bin
fi

# Open the local downloaded file in your favorite web browser
# open -a Safari info.txt

# Remove the temporary file
rm resource.bin