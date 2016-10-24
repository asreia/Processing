void setup(){
  size(854 , 480 , P3D);
  sphereDetail(40);
  frameRate(60);
  //noStroke();
}
int pointZ = 0;
float rotateValue;
void draw(){
  background(255);
  translate(mouseX , mouseY , pointZ);
  rotate(rotateValue += 0.02);
  fill(#38B4BF);
  sphere(100);
  pushMatrix();
  translate(120 , 0 , 0);
  fill(255 , 0 , 0);
  sphere(50);
  popMatrix();
  pushMatrix();
  translate(0 , 120 , 0);
  fill(0 , 255 , 0);
  sphere(50);
  popMatrix();
  pushMatrix();
  translate(0 , 0 , 120);
  fill(0 , 0 , 255);
  sphere(50);
  popMatrix();
  int recFrameCnt = 600;
  fill(0);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("processing-####.jpg");
}

void mouseWheel(MouseEvent event){
  float mh = event.getAmount();
  
  if(mh == 1){
    pointZ += 8;
  }
  else{
    pointZ -= 8;
  }
}