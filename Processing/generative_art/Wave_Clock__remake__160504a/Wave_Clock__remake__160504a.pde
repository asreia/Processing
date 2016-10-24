float _angnoise , _radiusnoise;
float _xnoise , _ynoise;
float _angle = -PI / 2;
float _radius;
float _strokeCol;
float _strokeChange = 0.5;
int lastMouseX , lastMouseY;

void setup(){
  
  size(854 , 480);
  smooth();
  frameRate(60);
  background(255);
  noFill();
  
  _angnoise = random(10);
  _radiusnoise = random(10);
  _xnoise = random(10);
  _ynoise = random(10);
  _strokeCol = random(255);
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}
int frameCnt = 0;
void draw(){
  
  _radiusnoise += 0.005;
  _radius = (noise(_radiusnoise) * 550 ) + 1;
  
  _angnoise += 0.005;
  _angle += (noise(_angnoise) - 0.5) * 2 * 3;
  while(_angle > 360) _angle -= 360;
  while(_angle < 0)   _angle += 360;
  
  _xnoise += 0.01;
  _ynoise += 0.01;
  float centerx = /*width / 2*/ mouseX + (noise(_xnoise) * 100) - 50;
  float centery = /*height / 2*/ mouseY + (noise(_ynoise) * 100) - 50;
  
  float rad = radians(_angle);
  float x1 = centerx + (_radius * cos(rad));
  float y1 = centery + (_radius * sin(rad));
  
  float opprad = rad + PI;
  float x2 = centerx + (_radius * cos(opprad));
  float y2 = centery + (_radius * sin(opprad));
  
  _strokeCol += _strokeChange;
  if(_strokeCol > 256) _strokeCol -= 256;
  //if(_strokeCol > 256) _strokeChange = -1;
  //if(_strokeCol < 0)   _strokeChange = 1;
  colorMode(HSB);
  stroke(_strokeCol , 255 , 255 , 30);
  strokeWeight(5);
  if(!mousePressed &&(mouseX == lastMouseX && mouseY == lastMouseY)) {
    frameCnt++;
    if(frameCnt >= 30){
      frameCnt = 30;
      line(x1 , y1 , x2 , y2);
    }
  }else frameCnt = 0;
  lastMouseX = mouseX;
  lastMouseY = mouseY;
  int recFrameCnt = 1200;
  fill(0);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("processing-####.jpg");
}
void mousePressed(){
  colorMode(RGB);
  background(random(245 , 255) , random(245 , 255) , random(245 , 255));
}