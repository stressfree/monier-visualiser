#!/bin/bash
# Generate Swatches and CSS for swatches from tab-delimited text file to do stuff we need;
fname="productTypes.txt"
relswatchpth="../../../Visualiser_Offline/"
csspath="../web/styles/swatch.css"
swatchtarget="../web/styles/s.jpg"
numfld=0;
color=25;
grup=13;
swatch=21;
prty=2;
prid=19;
swatchoffs=0;
swatchoffsincr=38;
rm $csspath

# functions for field extraction
function fl {
	#current line
	echo "$line"|cut -f$1
}
function fl0 {
	#current line
	echo "$l0"|cut -f$1
}

while read line
do   
	#for safety convert spaces to pipes, and the convert tabs to spaces 
	l=$(echo "$line"|sed -e 's/\ /\|/g'|sed -e 's/[\t]/\ /g')
	if [ $numfld = 0 ] ; then
		arr=($l)
		numfld=${#arr[@]}
	else
		hexcol=$(fl $color)
		prodid=$(fl $prid)
		grp=$(fl $grup)
		prt=$(fl $prty)
		grp0=$(fl0 $grup)
		if [ -z $hexcol ] ; then
 			swatchimg=$(fl $swatch)
 			swOK=${#swatchimg} 
   			if [ $swatchimg> 0 ] ; then
				if [ $swatchoffs = 0 ] ; then
					convert $relswatchpth$(fl $swatch) -crop 140x38+0+0 sw.jpg
				else
					convert $relswatchpth$(fl $swatch) -crop 140x38+0+0 tmp.jpg
					convert sw.jpg tmp.jpg -append sw0.jpg
					mv sw0.jpg sw.jpg
				fi
				echo "#sw_$prodid {background:url(s.jpg) 120px -$swatchoffs"px" no-repeat;}">>$csspath
				#extra step for product group selectors
				if [ "$grp0" != "$grp" ] ; then
# 					convert $relswatchpth$(fl $swatch) -crop 140x38+0+0 -type Grayscale tmp.jpg
# 					convert $relswatchpth$(fl $swatch) -type Grayscale $grp".png";
					composite $grp.png grey.png tmp.png
					convert tmp.png -crop 140x38+0+0 tmp.jpg
					bv=$(convert tmp.jpg -crop 1x1+0+0 txt:- )
 					bv=$(convert tmp.jpg -crop 1x1+0+0 txt:- |sed -e 's/).*//1'|sed -e 's/.*,//1'|sed -e 's/rgb.*//1'|sed -e 's/\ //g')
					
					bv=$(echo $bv|sed -e 's/[^0-9]*//g')
					bv2="rgb($bv,$bv,$bv)"
					echo $bv2
					
					convert sw.jpg tmp.jpg -append sw0.jpg
					mv sw0.jpg sw.jpg
					let "swatchoffs += $swatchoffsincr"
				echo "#sw_$prt"_"$grp {background:url(s.jpg) 120px -$swatchoffs"px" no-repeat;}">>$csspath
				fi
			fi
 			let "swatchoffs += $swatchoffsincr"
		else
			echo "#sw_$prodid div {background:$hexcol;}">>$csspath
		fi
	fi
	l0=$line
done < $fname

convert sw.jpg -quality 82  $swatchtarget
# rm *.jpg
echo Completed!