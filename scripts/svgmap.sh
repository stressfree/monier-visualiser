#!/bin/bash
# parse and svg file to coordinate points
# Script outputs to code to stdout
# Example Usage > sh make_swatch_html.sh >output_file.html
if [ -z $1 ] ; then fname='../r/2_1_1/1aa.svg'; else fname=$1;  fi
if [ -z $2 ] ; then yoff=0; else yoff=$2;  fi

cp houses3.xml houses3a.xml
rm 3x.xml
svgoutdir="../web/styles/"
tmp="b.svg"
export IFS=" "
# functions for field extraction
function fl {
	#current line
	echo "$line"|cut -f$1
}
function fl0 {
	#current line
	echo "$l0"|cut -f$1
}

#quick cleanup here
awk '{printf("%s", $0 (NR==1 ? "" : ""))}' $fname|sed -e 's/>/>\n/g'>$tmp


	while read line
	do   
		grs=$(echo $line|grep '<g ')
		if [ -n "$grs" ] ; then
			grid=$(echo "$grs"|cut -f2 -d\")
			echo Begin $grid
			echo   "\
<?xml version=\"1.0\" encoding=\"UTF-8\"?> \
<svg xmlns=\"http://www.w3.org/2000/svg\"> \
<g fill=\"none\" stroke=\"#f00\" stroke-dasharray=\"5,3,2\" stroke-width=\"2\">  \
<animate attributeName=\"stroke-dasharray\" values=\"1,2;5,6;3,4;1,2\" \
dur=\"2s\" repeatCount=\"indefinite\"/>" > $svgoutdir$grid.svg
# 			<?xml version="1.0" encoding="UTF-8"?>
# <svg xmlns="http://www.w3.org/2000/svg">
# <g fill="none">  <animate attributeName="stroke-dasharray" values="1,2;5,6;3,4;1,2" dur="1s" repeatCount="indefinite"/>

			
			
			xm=$(echo "<coordinateGroups id=\"11\_6\_$grid\">"|sed -e 's/\-//1')
			grid0=$(echo $grid|sed -e 's/\-//1')
		fi
		grs=$(echo $line|grep ' d=')
		if [ -n "$grs" ] ; then
			grp=$(echo "$grs"|sed -e 's/\ d=\"/\|/1'|cut -f2 -d\||cut -f1 -d\")
			i=0;
			x=0;
			y=$yoff;
			
			if [[ $grid == *-* ]] ;  then
				xm=$xm'<coordinateGroup exclude="True"><coordinatePairs>'
			else
				xm=$xm'<coordinateGroup exclude="False"><coordinatePairs>'
			fi

			svgout='<path d="m ';

			for pair in $grp; do
				if [ $i != 0 ] && [ $pair != "z" ] && [ $pair != "Z" ] ; then 
					arr=(${pair//,/ })
					svgout=$svgout" ${arr[0]},${arr[1]}"
# 					556.21228,242.75452 0.0392,26.96783 26.94319,0.703 0.17578,-24.25115 -18.79659,3.99358 -2.46319,-7.05395 z" 
					x=$(echo "scale=9; $x+${arr[0]}" | bc)
					y=$(echo "scale=9; $y+${arr[1]}" | bc)
					x0=$(echo $x | awk '{printf("%d\n", $1)}')
					y0=$(echo $y | awk '{printf("%d\n", $1)}')
					#multiply x 0.6 for case 2
					x06=$(echo "scale=9; $x*0.6" | bc | awk '{printf("%d\n", $1)}')
					y06=$(echo "scale=9; $y*0.6" | bc | awk '{printf("%d\n", $1)}')
					xm=$xm"<pair x=\"$x06\" y=\"$y06\" />";
				fi
				((i++))
			done
			svgout=$svgout" z\" />"
			islast=0
			echo $svgout >> $svgoutdir$grid.svg
			xm=$xm"</coordinatePairs></coordinateGroup>"
		fi
		grs=$(echo $line|grep '</g>')
		if [ -n "$grs" ] ; then
# 			xm=$xm"</coordinateGroups>"
			if [[ $grid == *-* ]] ;  then
				echo "sed -i 's|<coordinateGroups\ id=\"11\_6\_$grid0\">|$xm|g' houses3a.xml" >>3x.xml
			else
				echo "sed -i 's|<coordinateGroups\ id=\"11\_6\_$grid0\".*|$xm|g' houses3a.xml" >>3x.xml
			fi
			if [ $islast == 0 ] ; then
				echo "</g></svg>">> $svgoutdir$grid.svg
				islast=1
			fi
		fi
	done < $tmp
# rm $tmp
sort 3x.xml|sh
sed -i "s|../Render 2011/monier-visualiser/||g" houses3a.xml
sed -i "s|r/2_1_1/|r/2_1_1a/|g" houses3a.xml
cp houses3a.xml ../../../Visualiser_Offline/houses/houses3.xml