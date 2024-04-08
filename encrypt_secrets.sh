#!/bin/sh

# Default values
FOLDER_TO_APPLY=example
REMOVE_YAML=false
AGE_KEY_FILE=~/age-encrypt-key.txt

while [ $# -gt 0 ]; do
    case "$1" in
        --key-path)
            AGE_KEY_FILE="$2"
            shift 2
            ;;
        --folder)
            FOLDER_TO_APPLY="$2"
            shift 2
            ;;
        --remove-yaml)
            REMOVE_YAML="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Extract the public key from the age key file. Look for the line that starts with '# public key:', then extract.
PUBLIC_AGE_KEY=$(grep '^# public key:' $AGE_KEY_FILE | cut -d ' ' -f 4)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/$FOLDER_TO_APPLY"

for file in *.yaml; do
    echo "$file" | grep -q "\.enc\.yaml$" && continue
    echo "Encrypting $file with key $PUBLIC_AGE_KEY to ${file%.yaml}.enc.yaml"
    sops --encrypt --age $PUBLIC_AGE_KEY --encrypted-regex '^(data)$' $file > "${file%.yaml}.enc.yaml"
done

# Remove the original .yaml files if REMOVE_YAML is set to "true"
if [ "$REMOVE_YAML" = "true" ]; then
    find . -maxdepth 1 -type f -name "*.yaml" ! -name "*.enc.yaml" -exec rm {} +
fi

cd -

