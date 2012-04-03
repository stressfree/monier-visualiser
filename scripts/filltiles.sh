#!/bin/bash
#make fill tiles

while read line
do   
  echo -e "$line\t"
  fn=$(echo $line|cut -f 4 -d \/ )
  echo $fn
  col=$(convert "$line" -crop 1x1+12+26 txt:- | sed -n 's/.* \(#.*\)/\1/p' |cut -f 1 -d \ )
  # create a square for each 
  echo "convert -size 1024x1024 xc:'$col' \"fill/$fn\""|sh
done < flist.txt