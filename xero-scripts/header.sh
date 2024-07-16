#!/usr/bin/env bash

# Define the header to add
header=$(cat << 'EOF'
######################################
# Author   :   DarkXero              #
# Website  :   http://xerolinux.xyz  #
######################################
EOF
)

# Loop through all files in the current directory and subdirectories
find . -type f | while read -r file; do
  # Check if the file does not contain the header
  if ! grep -q "######################################" "$file"; then
    # Add the header to the file
    echo "$header
$(cat "$file")" > "$file"
  fi
done
