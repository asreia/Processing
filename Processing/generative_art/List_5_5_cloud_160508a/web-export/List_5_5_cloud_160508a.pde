float xstart , xnoise , ystart , ynoise;

void setup(){
  size(854 , 480 , P3D);
  frameRate(60);
  background(0);
  sphereDetail(8);
  noStroke();
  
  xstart = random(10);
  ystart = random(10);
}

void draw(){
  background(0);
  
  xstart += 0.01;
  ystart += 0.01;
  
  xnoise = xstart;
  ynoise = ystart;
  
  for(int y = 0; y < height; y += 5){
    ynoise += 0.1;
    xnoise = xstart;
    for(int x = 0; x < width; x += 5){
       xnoise += 0.1;
       drawPoint(x , y , noise(xnoise , ynoise));
    }
  }
  int recFrameCnt = 300;
  fill(255);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("processing-####.jpg");
}

void drawPoint(float x , float y , float noiseFactor){
  pushMatrix();
  translate(x , (height - 80) - y , -y);
  float sphereSize = noiseFactor * 35;
  float grey = 150 + (noiseFactor * 120);
  float alph = 150 + (noiseFactor * 120);
  fill(grey , alph);
  sphere(sphereSize);
  popMatrix();
}