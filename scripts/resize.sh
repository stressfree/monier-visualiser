#!/bin/bash
# Rip data from offline visualiser to make pj version

# Resize some images

rpath="../r/"

function r {
 	find "$rpath$1/" -iname '*.png' -exec echo convert -resize $3 -depth 5 \"{}\"  \"{}\" \;|sed -e "s|\/$1\/|\/$2\/|2"|sh
 	convert "$rpath$1/1.png" -resize $3 -quality 85 "$rpath$2/1.jpg"
#  	find "$rpath$1/" -iname '*.png' -exec echo convert -resize $3 -depth 4 -quantize transparent \"{}\"  \"{}\" \;|sed -e "s|\/$1\/|\/$2\/|2"|sed -e 's|\.png|\.gif|2'|sh
}
r "1_1_1" "1_2_1" "1024x640"
r "1_1_1" "1_3_1" "800x500"

# find ./ -maxdepth 1 -iname '*.gif' -exec echo convert              \"{}\" -coalesce \"{}\" \;|sed -e 's|\.\/|\.\/tmp\/|2'|sh
# find ../products/renders -iname '*.png' -exec echo convert         -resize 1024x640 -depth 5 \"{}\"  \"{}\" \;|sed -e 's|\.\.\/products\/renders|1024|2'|sh
# find ../products/renders -iname '*.png' -exec echo convert         -resize 1024x640 -depth 4 -quantize transparent \"{}\"  \"{}\" \;|sed -e 's|\.\.\/products\/renders|1024|2'|sed -e 's|\.png|\.gif|2'|sh
# find ./tmp -iname '*.gif' -exec echo convert                       -resize 1024x640 -depth 5                 \"{}\"  \"{}\" \;|sed -e 's|\.\/tmp|1024|2'|sh
# 
# convert ../houses/aspects/c76756dc-7c11-416d-a2ae-f75cf0e90691.png -resize 1024x640 -depth 6                                                     1024/base.png

		
