#!/bin/bash
# Generate html body for swatches
# Script outputs to code to stdout
# Example Usage > sh make_swatch_html.sh >output_file.html
fname="productTypes.txt"
h="swatch.html"

grup=13;
sgrup=16;
prty=2;
prid=19;
color=25;
nm=23;
ttl=5;
div1="";
div2="";

# functions for field extraction
function fl {
	#current line
	echo "$line"|cut -f$1
}
function fl0 {
	#current line
	echo "$l0"|cut -f$1
}


echo "<div id=\"s_0\">"
for i in 1 2; do
	numfld=0
	while read line
	do   
		#for safety convert spaces to pipes, and the convert tabs to spaces 
		l=$(echo "$line"|sed -e 's/\ /\|/g'|sed -e 's/[\t]/\ /g')
		if [ $numfld = 0 ] ; then
			arr=($l)
			numfld=${#arr[@]}
		else
			hexcol=$(fl $color)
	# 		prodid=$(fl $prid)
			prt=$(fl $prty)
			prt0=$(fl0 $prty)
			grp=$(fl $grup)
			sgrp=$(fl $sgrup)
			grp0=$(fl0 $grup)
			title=$(fl $ttl)
			t=$(echo $title|sed -e 's/\ /\_/g')
			title0=$(fl0 $ttl)
					
			brk1=0;
			#Break Top Level for Title
				
			if [ "$title0" != "$title"  ] ; then
				case $i in
					1)
						if [ "$sgrp" != "" ] ; then 
							# stack stuff here for next round 
							hds[$prt]="\t\t<div id=\"s_"$prt"_0\" class=\"swatch swgroup\">"
							hdse[$prt]="\t\t</div>"
							titlegrp=$title'_'$grp
						fi
						;;
					2)
						echo -e $div2
						echo -e $div1
						echo -e "\t<div id=\"s_$prt\" class=\"swatchlist\">"
						if [ "$sgrp" != "" ] ; then 
							echo -e '\t\t<button id="pt_'$prt'_1" class="mainbut mainbut_on" onClick="sg(this)">'$(fl 8)'</button>'
							echo -e '\t\t<button id="pt_'$prt'_2" class="mainbut mainbut_on hid">'$(fl 9)'</button>'
						else
							echo -e '\t\t<button id="pt_'$prt'_2" class="mainbut mainbut_on">'$(fl 9)'</button>'
						fi
						echo -e '\t\t<button id="crx_'$prt'" class="mainbut close" onClick="paneloff()"></button>'
						echo -e ${hds[$prt]}
						echo -e ${hdse[$prt]}
						brk1=1;
						div1="\t</div>"
						div2=""
					;;
				esac
			fi
		#Break Top Level for Title
			if [ "$grp0" != "$grp"  ] ; then
				case $i in
					1)
						if [ "$sgrp" != "" ] ; then 
							hds[$prt]=${hds[$prt]}"\n\t\t\t<button id=\"sw_"$prt"_"$grp"\" onClick=\"sel(this)\">$sgrp</button>"
						fi
						;;
					2)
						echo -e $div2
						if [ "$sgrp" != "" ] ; then 
							echo -e "\t\t<div id=\"s_"$prt"_"$grp"\" class=\"swatch hid\">"
						else
							echo -e "\t\t<div id=\"s_"$prt"_"$grp"\" class=\"swatch\">"
						fi
						div2="\t\t</div>"
						;;
				esac
			fi
			if [ $i = 2  ] ; then
				if [ -z $hexcol ] ; then
					echo -e "\t\t\t<button id=\"sw_"$(fl $prid)"\">"$(fl 23)"</button>"
					
				else
					echo -e "\t\t\t<button id=\"sw_"$(fl $prid)"\">"$(fl 23)"<div></div></button>"
				fi
			fi
		fi
		l0=$line
	done < $fname
done
echo -e $div2
echo -e $div1
echo "</div>"