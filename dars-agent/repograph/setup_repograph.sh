#!/bin/bash

# Define variables
DOWNLOAD_URL="https://drive.usercontent.google.com/download?id=1-0d-OgGoOf3i54bWcf8H0egjQyTSZ8dG&export=download&authuser=0&confirm=t&uuid=4803840a-0992-4657-9eab-bc849435ca6e&at=AEz70l50Xa7Glr5g7yZbjN1EjtiP%3A1740328356479"
SCRIPT_DIR="$(dirname "$0")"
DEST_DIR="$SCRIPT_DIR/codegraph_cache/"
ZIP_FILE="downloaded_file.zip"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Download the file using wget
wget --no-check-certificate "$DOWNLOAD_URL" -O "$ZIP_FILE"

# Check if download was successful
if [ -f "$ZIP_FILE" ]; then
    echo "Download successful. Extracting..."
    unzip "$ZIP_FILE" -d "$DEST_DIR"
    
    # Check if extraction was successful
    if [ $? -eq 0 ]; then
        echo "Extraction successful. Organizing files..."
        
        # Move files to desired format
        find "$DEST_DIR/RepoGraph_cache" -type f -name "tags_*.json" | while read file; do
            base_name=$(basename "$file" .json)
            formatted_name=$(echo "$base_name" | sed 's/tags_//')
            new_dir="$DEST_DIR/$formatted_name"
            mkdir -p "$new_dir"
            mv "$file" "$new_dir/tags.json"
        done
        
        # Remove the original extracted directory
        rm -rf "$DEST_DIR/RepoGraph_cache"
        
        echo "Reformatting complete. Deleting ZIP file..."
        rm "$ZIP_FILE"
        
        # Run additional scripts
        echo "Creating Graph files using tags_to_graph.py..."
        cd "$SCRIPT_DIR"
        python3 tags_to_graph.py
        
        echo "Updating tags using update_tags.py..."
        python3 update_tags.py
    else
        echo "Extraction failed. Keeping ZIP file for inspection."
    fi
else
    echo "Download failed. Please check the file ID and network connection."
fi
