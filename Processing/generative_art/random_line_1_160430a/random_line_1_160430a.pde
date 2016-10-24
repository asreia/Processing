size(500 ,400);
background(255);
stroke(#2A6464);
strokeWeight(1);
int step = 1;
float lastx = -999;
float lasty = height / 2;
float y = 50;
float defwidth = 20;
int borderx = 20;
int bordery = 10;

for(int  x = borderx; x <= width - borderx; x += step){
  defwidth = random(50);
  y = (lasty) + (random(defwidth) - (defwidth / 2));
  if(lastx > -999){
    line(x , y , lastx , lasty);
  }
  lastx = x;
  lasty = y;
}