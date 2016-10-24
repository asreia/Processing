import java.util.Random;

float u = -100 , a = 50;

Random r;
void setup(){
  size(600 , 300);
  frameRate(60);
  background(0);
  smooth();
  r = new Random();
  stroke(0 , 255 , 0);
  line(300 , 0 , 300 , height);
  stroke(0 , 0 , 255);
  line((width / 2) + u , 0 , (width / 2) + u , height);
}
void draw(){
  strokeWeight(10);
  stroke(#FFFFFF , 8);
  translate(width / 2 , height / 2);
  point((float)((r.nextGaussian() * a) + u) , 0);
}