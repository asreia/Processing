void setup(){
  size(854 , 480);
  frameRate(60);
  smooth();
}
boolean s = true;
void draw(){
 if(frameCount % 12 == 0){
 if(s) background(#FF0000);
 else background(#0000FF);
 s = !s;}
 int recFrameCnt = 300;
  fill(0);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("List_6_4_moveCircles_160508f-####.jpg");
}