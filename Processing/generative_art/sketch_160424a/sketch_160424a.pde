// setting and background
size(500,300);
smooth();
background(0xE6,0xE6,0xE6);

stroke(128 ,128 , 0 , 192);
strokeWeight(4);
float centX = width / 2;
float centY = height / 2;
line(centX - 70 , centY - 70 , centX + 70 , centY + 70);
line(centX + 70 , centY - 70 , centX - 70 , centY + 70);

fill(128 , 0 , 256 , 128);
ellipse(centX , centY , 50 , 50);
fill(0 , 0 , 256 , 255);
noStroke();
//noFill();
ellipse(centX -25 , centY , 50 , 50);