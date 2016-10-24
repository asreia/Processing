void setup(){
 size(854 , 480);
 frameRate(60);
 background(240);
 stroke(#5D91FF);
 strokeWeight(4);
 smooth();
}  

int posX1 = width / 2 , posY1 = height / 2 , posX2 , posY2;

void draw(){
  line(posX1 , posY1 , (posX2 = (int)random(0 , width)) , (posY2 = (int)random(0 , height)));
  posX1 = posX2;
  posY1 = posY2;
  int recFrameCnt = 300;
  fill(0);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("List_6_4_moveCircles_160508f-####.jpg");
}