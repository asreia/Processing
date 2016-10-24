float base_xnoise , base_ynoise;
int count = 0;

void setup(){
  size(854 , 480);
  frameRate(60);
  smooth();
  background(255);
  frameRate(1000);
  
  base_xnoise = random(10);
  base_ynoise = random(10);
  keyCode = DOWN;
}

void prelinNoise_2D_rotateLine(){
  float ynoise = base_ynoise;
  for(int y = 0; y <= height; y += 2){
    ynoise += 0.025;
    float xnoise = base_xnoise;
    for(int x = 0; x <= width; x += 2){
      xnoise += 0.025;
      drawPoint(x , y , noise(xnoise , ynoise));
    }
  } 
}

void drawPoint(float x , float y , float noiseFactor){
  pushMatrix();
  translate(x , y);
  rotate(noiseFactor * radians(360));
  colorMode(HSB);
  strokeWeight(1);
  stroke(noiseFactor * 360 , 150, 100 , 150);
  line(0 , 0 , 10 , 0);
  popMatrix();
}

void draw(){
  background(255);
  prelinNoise_2D_rotateLine();
  
  switch(keyCode){
    case UP:
      base_ynoise -= 0.1;
    break;
    case DOWN:
      base_ynoise += 0.1;
    break;
    case LEFT:
      base_xnoise -= 0.1;
    break;
    case RIGHT:
      base_xnoise += 0.1;
    break;
    case ENTER:
      saveFrame("2DPrelin-####.gif");
      keyCode = 0;
    break;
  }
  int recFrameCnt = 900;
  fill(0);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("processing-####.jpg");
  count++;
  println(keyCode);
}