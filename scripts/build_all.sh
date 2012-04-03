#!/bin/bash
# Full Build Process
cp 1.html index.html;
sh make_swatch_html.sh >>index.html;
cat 3.html>>index.html;
cp index.html ../web/
	