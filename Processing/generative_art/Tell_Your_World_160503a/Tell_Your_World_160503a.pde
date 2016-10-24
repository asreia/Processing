void setup(){
  size(854 , 480);
  background(240);
  stroke(#9CDE57);
  strokeWeight(4);
  smooth();
  frameRate(60);
  _noiseValue = random(10);
  beginShape();
}

float _noiseValue;
float _X , _Y;
void draw(){
  beginShape();
  for(int i = 0; i < 6; i++){
    _X = noise(_noiseValue) * width;
    _noiseValue += 1.2356;
    _Y = noise(_noiseValue) * height;
    _noiseValue += 1.427;
    fill(int(_X % 255) , int(_Y % 255) , random(255));
    curveVertex(_X , _Y);
  }
  endShape();
  int recFrameCnt = 300;
  fill(0);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("List_6_4_moveCircles_160508f-####.jpg");
}