#!/bin/bash
#make fill tiles from old renders
pth="../../../monier-visualiser/r/1_1_1/3_"


function fcol {
	#current line
	echo "$pth$1.png"
	col=$(convert "$pth$1.png" -crop 1x1+514+393 txt:- | sed -n 's/.* \(#.*\)/\1/p' |cut -f 1 -d \ )
# 	col=$(convert "$pth$1.png" -crop 1x1+580+371 txt:- | sed -n 's/.* \(#.*\)/\1/p' |cut -f 1 -d \ )
#   create a square for each 
  echo "convert -size 1024x1024 xc:'$col' \"fill/$2\""|sh
  mogrify "fill/$2" -gamma .8
}


fcol 209 hacienda_antique_olive.png
fcol 210 hacienda_caper.png
fcol 215 hacienda_cashew.png
fcol 208 hacienda_dark_brown.png
fcol 213 hacienda_desert_sand.png
fcol 212 hacienda_hapuka.png
fcol 217 hacienda_kava.png
fcol 211 hacienda_orange_peel.png
fcol 207 hacienda_paprika.png
fcol 214 hacienda_sambuca.png
fcol 216 hacienda_slate.png
fcol 206 hacienda_wild_rice.png


