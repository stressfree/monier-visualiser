convert marseille_.png marseille_.png +append m.png
convert m.png m.png +append m.png
convert m.png m.png +append m.png
convert m.png m.png +append m.png
convert m.png -crop 1000x200+65+0 +repage m0.png
convert m0.png m.png -append m1.png
convert m1.png m1.png -append m1.png
convert m1.png -crop 527x800+0+0 +repage marseille_disp.png
rm m.png m1.png m0.png
 
