#!/bin/zsh
# Creates a backup of a given directory (encrypted tar)
# Ex: backup.sh org

function usage() {
    echo "Usage: backup.sh <dir>";
    echo "  Creates archive file <dir>.enc containing the whole of <dir>.";
    echo "  The archive file is written in the current directory.";
}

if [ "$#" -ne 1 ]; then
    echo "Error: Missing argument. What directory do you want to backup?";
    usage;
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: $1 is not a directory";
    usage;
    exit 1
fi

SRC="$1"
TAR="/tmp/$1.tar"
ENC="$1.enc"

if read -q "REPLY?Do you want to back up directory '$SRC' into archive '$ENC?' [y/n] "; then
    echo "\nBacking up '$SRC' ⮕ '$ENC'";
    echo "Creating archive...";
    rm -f $TAR $ENC;
    gtar cf $TAR $SRC;
    echo "Encrypting..."
    openssl enc -aes-256-cbc -salt -in $TAR -out $ENC;
    rm -f $TAR;
else
    echo "\nAborting"
fi
