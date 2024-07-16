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
  # Check if the file contains the shebang and does not already contain the header
  if grep -q "^#!/usr/bin/env bash" "$file" && ! grep -q "######################################" "$file"; then
    # Insert the header under the shebang
    awk -v header="$header" 'NR==1 {print; print header} NR!=1' "$file" > temp && mv temp "$file"
  fi
done
