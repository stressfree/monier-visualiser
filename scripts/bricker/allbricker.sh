#!/bin/bash
#iterate bricker.sh over all subdirectories
# call with args : ie  sh allbricker.sh 10 4 4 90
# requires: bricker.sh in same directory
find ./ -maxdepth 1 -mindepth 1 -type d -exec echo "cd {};bash ../bricker.sh $1 $2 $3 $4 $5;cd ../" \;|bash
