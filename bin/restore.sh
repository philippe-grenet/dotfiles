#!/bin/zsh
# Restores a backup into the current directory (make sure it does not already exist).
# Ex: restore org.enc  => will write 'org' in the current dir.

if [ -z "$1" ]
   then
       echo "Usage: restore.sh <dir.enc>"
       echo "Restores <dir> from <dir>.enc (in local directory)"
       exit 1
fi

ENC="$1"
TARGET=`basename $1 .enc`
TAR="/tmp/$TARGET.tar"

if [ -f $TARGET ]
   then
       echo "$TARGET already exists!"
       exit 1
fi

echo "Restoring $ENC ⮕ $TARGET"
rm -f $TAR
openssl enc -d -aes-256-cbc -in $ENC -out $TAR
gtar xf $TAR
rm -f $TAR
