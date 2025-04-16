#!/bin/bash

DIR="."
for file in "$DIR"/*.svg; do
    if [ -f "$file" ]; then
        sed -i 's/#FFFFFF/#003351/g' "$file"
    fi
done
