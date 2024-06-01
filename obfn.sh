#!/bin/bash

usage() {
    echo "Usage: $(basename "$0") <type> [path]"
    echo "  <type>: File type (png/jpg)"
    echo "  [path]: Path to directory"
    echo
    echo "  Example: ./$(basename "$0") \"png\" \"/images/folder\""
    echo
    exit 1
}

echo "Please make sure you have exiftool installed."
echo
echo "Starting script..."
echo

if [ $# -lt 1 ]; then
    usage
fi

if [ "$1" != "png" ] && [ "$1" != "jpg" ]; then
    echo "Non png/jpg files are not tested. Unexpected results may occur."
    echo "\"$(basename "$0") ?\" for usage"
fi

if [ "$1" = "?" ]; then
    usage
fi

if [ $# -gt 1 ]; then
    if [ -d "$2" ]; then
        cd "$2"
    else
        echo "Directory not found!"
        echo
        usage
    fi
fi

file_count=$(ls -1 *."$1" 2>/dev/null | wc -l)
if [ $file_count -eq 0 ]; then
    echo "No files found."
    exit 1
fi

get_number() {
    echo "$1" | grep -oE '[0-9]+'
}

paddings=$(echo -n $file_count | wc -c)

for file in $(ls *."$1" | sort -V); do
    number=$(get_number "$file")

    padded=$(printf "%0*d" $paddings $number)

    exiftool -Title="$padded" -overwrite_original "$file"
done