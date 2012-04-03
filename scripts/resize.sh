#!/bin/bash
# Resize some images
# 
# no arguments to pass : amend lines below the break as required

rpath="../r/"

function r {
 	find "$rpath$1/" -iname '1.png' -exec echo convert $5 -resize $3 -depth 5 +repage \"{}\"  \"{}\" \;|sed -e "s|\/$1\/|\/$2\/|2"|sh
 	convert "$rpath$1/1.png"  $5 -resize $3\! -quality 85 +repage "$rpath$2/1.jpg"
}

#=============================================================================


r "2_1_1" "2_2_1a" "1600x1000" "*.png" "-crop 1600x1000+0+202" 
# r "2_1_1" "2_2_1" "1024x640"
# r "2_1_1" "2_3_1" "800x500"
# Lines below processed previously - do not need to be re-done
# r "1_1_1" "1_2_1" "1024x640"
# r "1_1_1" "1_3_1" "800x500"
