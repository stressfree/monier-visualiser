#!/bin/bash
# arguments given are for % opacity of white and black respectively

mkdir "$1_$2_$3"
while read line
do   
  fn=$(echo $line|cut -f 4 -d \/ )
  echo "composite -dissolve $1% \"fill/$fn\" white.gif tmp0.png"|sh
  echo "composite -dissolve $2% whitebump.png tmp0.png tmp1.png"|sh
  
  echo "composite -dissolve $3% blackbump.png tmp1.png \"$1_$2_$3/$fn\""|sh

done < flist.txt