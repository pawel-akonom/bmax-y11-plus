#!/bin/bash

for GOOGLE_ACOUNT in $(ls -1 $HOME/.gdfuse); do
  google-drive-ocamlfuse -label $GOOGLE_ACOUNT /mnt/gdrive/$GOOGLE_ACOUNT
done
