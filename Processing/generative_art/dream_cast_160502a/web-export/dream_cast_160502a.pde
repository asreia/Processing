void setup(){
  size(854 , 480);
  frameRate(2400);
  background(255);
  smooth();
  R = random(255);
  G = random(255);
  B = random(255);
  stroke(R , G , B);
  strokeWeight(10);
  centX = width / 2;
  centY = height / 2;
}

float angle = 0;
float centX;
float centY;
float radius = 190;
boolean f = true;
float rad;
float R , G , B;
float noiseValue = 0.001;
int cnt = 1;
void draw(){
  stroke(noise(R += noiseValue) * 255 , noise(G += noiseValue) * 255 , noise(B += noiseValue) * 255);
  rad = radians(angle);
  angle++;
  if(f){
    radius -= 0.1;
    if(radius < -190) f = false;
  }
  else{
    radius += 0.1;
    if(radius > 190) f = true;
  }
  point(centX + (radius * cos(rad)) , centY + (radius * sin(rad)));
  
  if(frameCount % 40 == 1){
  int recFrameCnt = 300 * 40;
  fill(0);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("List_6_4_moveCircles_160508f-" + (cnt++) + ".jpg");
}
}