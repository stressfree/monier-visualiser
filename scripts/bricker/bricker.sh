#!/bin/bash
# random layout algorithm for bricks
# call as     sh bricker.sh [number of source bricks] [rows to generate] [bricks per row] [random dimming factor] [rflip] [rflop] [display]"
#       i.e.  sh bricker.sh 10 31 20 90
# [display] argument is optional -anything in there will make it show
# requires:
# imagemagick installed
# a black border brick image named 0.png
# source brick images named 1.png, 2.png etc in this folder


function rint {
	n=$RANDOM
	let "n %= $1"
	let "n += 1" 
	echo $n
}
function rflip {
	n=$RANDOM
	let "n %= 2"
	rf=""
	if [ $n = 0 ] ; then
		rf=$rf" -flip "
	fi
	echo $rf
}
function rflop {
	n=$RANDOM
	let "n %= 2" 
	if [ $n = 0 ] ; then
		rf=$rf" -flop "
	fi
	echo $rf
}

if [ -z "$4" ] ; then
	echo "Not enough arguments : call as"
	echo "     sh bricker.sh [number of source bricks] [rows to generate] [bricks per row] [random dimming factor]"
	echo "i.e. sh bricker.sh 10 31 20 90"
else
	# process args
	pix=$1
	rows=$2
	cols=$3
	dis0=$4
	let "dis1=100-$4"
	fli=$5
	flo=$6
	
	#current folder name
	cf=$(pwd|sed 's,^\(.*/\)\?\([^/]*\),\2,')
	outf="../_out/$cf""_DIFFUSE.png"
	outw="../_wall/$cf"".png"
	outm="../_out/$cf""_MASK.png"
	
	echo "Started - will try and output to $outf"
	# calculate crop details 
	# measure first tile
	isz=$(identify 1.png|cut -f3 -d \ )
	w=$(echo "$isz"|cut -f1 -d x)
	h=$(echo "$isz"|cut -f2 -d x)
	let "o=w / 2"
	let "w=w * $cols"
	let "w2=w * ($cols+1)"
	let "th=$h * $rows"
	crp="$w"x"$h"+"$o"+0
	echo "Crop offset for alternate rows is $crp"
	y=1
	while [ "$y" -le "$rows" ]
	do
		yyy=`printf %03d $y`
		x=1
		while [ "$x" -le "$cols" ]
		do
			echo "Row $y Column $x"
			xxx=`printf %03d $x`
			rfl=""
			rflx=""
			if [ $fli = 1 ] ; then
				rfl=$(rflip);
			fi
			if [ $fli = 1 ] ; then
				rflx=$(rflop);
			fi
			
			
# 			convert $(rint $pix).png $rfl $rflx tmp_.png
					
#option for mortar edge trimming
edge="4"
let "w1=($o * 2)"
let "cw=($w1 - (2 * $edge))"
let "ch=($h - (2 * $edge))"
crp0="-crop $cw"x"$ch"+"$edge"+"$edge"" -resize "$w1"x"$h"! +repage"
convert $(rint $pix).png $rfl $rflx $crp0 tmp_.png

			let "dis =$(rint $dis1) + $dis0"
			composite -dissolve $dis% tmp_.png 0.png col$xxx.png
			let "x +=1"
		done
		convert col*.png +append row$yyy.png
			r=$(( $y % 2 ))
			if [ $r -eq 0 ] ; then
				# even row - do half offset
				convert row$yyy.png row$yyy.png +append tmp2.png
				convert tmp2.png -crop $crp row$yyy.png
			fi
	let "y +=1"
	done
	convert row*.png -append "$outf"
	convert -font Trebuchet-MS-Regular -size 400x20 -background transparent -fill white -pointsize 13 caption:"$cf" "tmpt.png"
	composite -compose atop tmpt.png "$outf" "$outw"
	convert "$outf" -background white -flatten -resize 30% "$outw"
	isz=$(identify "$outf"|cut -f3 -d \ )
	echo "Completed - image size $isz saved to $outf"	
	# tile the mask
	composite -tile 0.png -size  "$w"x"$h" xc:none rrow0.png
	convert -size "$w"x"$h" tile:0.png rrow0.png
	convert -size "$w2"x"$h" -tile-offset -"$o"+0 tile:0.png rrow1.png
	convert rrow0.png rrow1.png -append rrow2.png
	composite -tile rrow2.png -size  "$w"x"$th" xc:none "$outm"
	echo "Completed - image size $isz saved to $outm"
	outn="../_out/$cf""_NCM.png"
	convert "$outf" -fill magenta -colorize 100 -background cyan -flatten "$outn"
	# Clear any temp files
	rm tmp*.png
	rm col*.png
	rm row*.png
	rm rrow*.png
	# optionally display result files if fifth argument given
	if [ $7 = "1" ] ; then
		display  -background white -flatten -resize 50% "$outf"
		display  -background white -flatten -resize 50% "$outm"
 	fi

fi