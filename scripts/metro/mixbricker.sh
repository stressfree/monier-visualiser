#!/bin/bash
# random layout algorithm for bricks
# call as     sh bricker.sh [number of source bricks] [rows to generate] [bricks per row] [random dimming factor] [display]"
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
	
	#current folder name
	cf=$(pwd|sed 's,^\(.*/\)\?\([^/]*\),\2,')
	outf="../$cf""_DIFFUSE.png"
	outm="../$cf""_TRANS.png"
	outo="../$cf""_OPC.png"
	outd="../$cf""_DISP.png"
	echo "Started - will try and output to $outf"
	# calculate crop details 
	# measure first tile
	isz=$(identify 1.png|cut -f3 -d \ )
	w=$(echo "$isz"|cut -f1 -d x)
	h=$(echo "$isz"|cut -f2 -d x)
	let "o=w / 2"
	let "w2=w * ($cols+1)"
	let "w=w * $cols"
	let "th=$h * $rows"
	crp="$w"x"$h"+"$o"+0
	echo "Crop offset for alternate rows is $crp"
	#option for mortar edge trimming
	edge="2"
	let "w1=($o * 2)"
	let "cw=($w1 - (2 * $edge))"
	let "ch=($h - (2 * $edge))"
	crp0="-crop $cw"x"$ch"+"$edge"+"$edge"" -resize "$w1"x"$h"! +repage"
	y=1
	while [ "$y" -le "$rows" ]
	do
		yyy=`printf %03d $y`
		x=1
		while [ "$x" -le "$cols" ]
		do
			xxx=`printf %03d $x`
			cp 0.png col$xxx.png
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
	convert row*.png -append "tmpmix_0.png"
	outn="../$cf""_b.png"
	convert "tmpmix_00.png" -fill magenta -colorize 100 -background black -flatten "$outn"
	outn="../$cf""_w.png"
	convert "tmpmix_00.png" -fill magenta -colorize 100 -background white -flatten "$outn"
	echo "Completed - Nasty Cut Map saved to $outn"
	# Clear any temp files
#	rm tmp*.png
	rm col*.png
	rm row*.png
	rm rrow*.png
fi
