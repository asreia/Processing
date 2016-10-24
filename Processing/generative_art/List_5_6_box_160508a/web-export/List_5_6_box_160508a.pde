float xstart , xnoise , ystart , ynoise , zstart , znoise;

int sideLength  = 200;
int spacing = 5;

void setup(){
  size(854 , 480 , P3D);
  frameRate(60);
  background(0);
  noStroke();
  
  xstart = random(10);
  ystart = random(10);
  zstart = random(10);
}

void draw(){
  background(0);
  
  xstart += 0.01;
  ystart += 0.01;
  zstart += 0.01;
  
  //xnoise = xstart;
  //ynoise = ystart;
  znoise = zstart;
  
  translate(width * 0.45 , height * 0.4 , -150);
  rotateZ(frameCount * 0.03);
  rotateY(frameCount * 0.03);
  
  for(int z = 0; z < sideLength; z += spacing){
    znoise += 0.1;
    ynoise = ystart;
    for(int y = 0; y < sideLength; y += spacing){
      ynoise += 0.1;
      xnoise = xstart;
      for(int x = 0; x < sideLength; x += spacing){
         xnoise += 0.1;
         drawPoint(x , y , z , noise(xnoise , ynoise , znoise));
      }
    }
  }
  int recFrameCnt = 600;
  fill(255);
  textSize(14);
  println("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("processing-####.jpg");
}

void drawPoint(float x , float y , float z , float noiseFactor){
  pushMatrix();
  translate(x , y , z);
  float grey = noiseFactor * 255;
  fill(grey , 10);
  box(spacing , spacing  , spacing);
  popMatrix();
}