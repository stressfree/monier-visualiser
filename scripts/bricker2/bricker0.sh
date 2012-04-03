#!/bin/bash
# random layout algorithm for bricks
# call as     sh bricker.sh [number of source bricks] [rows to generate] [bricks per row] [random dimming factor]"
#       i.e.  sh bricker.sh 10 31 20 90
# requires:
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
	outf="../$cf.png"
	echo "Started - will try and output to $outf"
	# calculate crop details 
	# measure first tile
	isz=$(identify 1.png|cut -f3 -d \ )
	w=$(echo "$isz"|cut -f1 -d x)
	h=$(echo "$isz"|cut -f2 -d x)
	let "o=w / 2"
	let "w=w * $cols"
	crp="$w"x"$h"+"$o"+0
	echo "Crop offset for alternate rows is $crp"
	y=1
	while [ "$y" -le "$rows" ]
	do
		x=1
		convert $(rint $pix).png $(rflip) tmp_.png
		let "dis =$(rint $dis1) + $dis0"
		composite -dissolve $dis% tmp_.png 0.png tmp0.png
		cp tmp0.png tmp.png
		echo "Row $y Column $x"
		while [ "$x" -lt "$cols" ]
		do
			cp tmp0.png tmp1.png
			convert $(rint $pix).png $(rflip) tmp_.png
			convert $(rint $pix).png $(rflip) blob$x.png
			let "dis =$(rint $dis1) + $dis0"
			composite -dissolve $dis% tmp_.png 0.png tmp0.png
			convert tmp0.png tmp1.png +append tmp.png
			cp tmp.png tmp0.png
			let "x +=1"
			echo "Row $y Column $x"
		done
		if [ $y = 1 ] ; then
 			cp tmp.png tmpz.png
		else
			cp tmpz.png tmpy.png
# 		extra step for alternate bondss
			r=$(( $y % 2 ))
			if [ $r -eq 0 ] ; then
				# even row - do half offset
				convert tmp.png tmp.png +append tmp2.png
				convert tmp2.png -crop $crp tmp.png
			fi
		convert tmpy.png tmp.png -append tmpz.png
		fi
	let "y +=1"
	done
	cp tmpz.png "$outf"
	# Clear any temp files
# 	rm tmp*.png
	isz=$(identify "$outf"|cut -f3 -d \ )
	echo "Completed - image size $isz saved to $outf"
	display  -background white -flatten -resize 50% $outf
	echo $cols
fi