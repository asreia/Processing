void setup(){
  size(854 , 480);
  smooth();
  stroke(0 , 255 , 0);
  strokeWeight(2);
}
float t = 0;
void draw(){
  background(255);
  float angle = 0;
  for(float x = 0; x < width; x++){
    float y = ((sin(t + (angle += (2 * PI) / width)) + 1) / 2) * height;
    point(x , y);
  }
  t += 0.1;
}