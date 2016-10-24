void setup(){
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
  float noiseValue = random(10);
  
  for(int  x = borderx; x <= width - borderx; x += step){
    defwidth = random(50);
    y = (lasty) + ((noise(noiseValue) * defwidth) - (defwidth / 2));
    //y = (height / 2) + ((noise(noiseValue) * defwidth) - (defwidth / 2));
    if(lastx > -999){
      println("y    :" + y);
      println("lasty:" + lasty);
      line(x ,borderOut(y) , lastx , borderOut(lasty));
    }
    noiseValue += 0.01;
    lastx = x;
    lasty = y;
  }
}
float borderOut(float y){
   if(y >= 0){
     y %= height;
   }
   else{
      while(y < 0){
        y += height;
      }
   }
  return y;
}