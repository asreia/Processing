float rate = 60;
float min = 0 , max;
void setup(){
  size(854 , 480);
  frameRate(rate);
  smooth();
  max = width;
}
float map_(float x , float nowMin , float nowMax , float newMin , float newMax){
  float nowD = nowMax - nowMin;
  float baseX = (x - nowMin) / nowD;
  float newD = newMax - newMin;
  return (baseX * newD) + newMin;
}
float sinValue = 0;
void draw(){
  background(255);
  sinValue += 2 / rate;
  if(sinValue > 2) sinValue = 0;
  float newX = map_(sin(sinValue * PI) , -1 , 1 , min , max);
  stroke(127 , 0 , 255);
  strokeWeight(100);
  point(newX , height / 2);
}