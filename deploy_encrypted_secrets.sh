#!/bin/sh

# Pass --folder and --key-path optionally to the script
FOLDER_TO_APPLY=example
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
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# This variable is required and used by sops to decrypt
export SOPS_AGE_KEY_FILE=$AGE_KEY_FILE

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/$FOLDER_TO_APPLY"

for file in *.enc.yaml; do
    decrypted_file="${file%.enc.yaml}.yaml"
    sops --decrypt "$file" > "$decrypted_file"
    kubectl apply -f "$decrypted_file"
    rm "$decrypted_file"
done

cd -
