#!/bin/bash
# Rip data from offline visualiser to make pj version

# 1. Get the render data
grep product\ id ../houses/houses.xml|sed -e 's/.*id\=\"//1'|sed -e 's/\" \image\=\"/\t/1'|sed -e 's/\".*//g'>renders.txt
# 2. resize some images

find ./ -maxdepth 1 -iname '*.gif' -exec echo convert              \"{}\" -coalesce \"{}\" \;|sed -e 's|\.\/|\.\/tmp\/|2'|sh
find ../products/renders -iname '*.png' -exec echo convert         -resize 600x375 -depth 5 \"{}\"  \"{}\" \;|sed -e 's|\.\.\/products\/renders|600|2'|sh
find ../products/renders -iname '*.png' -exec echo convert         -resize 600x375 -depth 4 -quantize transparent \"{}\"  \"{}\" \;|sed -e 's|\.\.\/products\/renders|600|2'|sed -e 's|\.png|\.gif|2'|sh
find ./tmp -iname '*.gif' -exec echo convert                       -resize 600x375 -depth 5                 \"{}\"  \"{}\" \;|sed -e 's|\.\/tmp|600|2'|sh

convert ../houses/aspects/c76756dc-7c11-416d-a2ae-f75cf0e90691.png -resize 600x375 -depth 6                                                     600/base.png

		
