class DropCircle{
  float x , y;
  float speed;
  int beginTime;
  float radius;
  int clr;
  DropCircle(){
    speed = 0;
    beginTime = frameCount;
    x = mouseX; y = mouseY;
    radius = random(100 , 200);
    clr = (int)random(360);
  }
  void update_and_drawMe(){
   speed = pow((frameCount - beginTime) , 2) * 0.001;
   y += speed;
   if(y - radius > height)y = -radius;
   drawMe();
  }
  void drawMe(){
    fill(clr , 60 , 150 , 128);
    ellipse(x , y , radius , radius);
  }
}

DropCircle[] dc = {};

void setup(){
 colorMode(HSB);
 size(854 , 480);
 frameRate(60);
}

void draw(){
  if(mousePressed == true && frameCount % 6 == 0)dc = (DropCircle[])append(dc , (new DropCircle()));
  background(255);
  for(int i = 0; i < dc.length; i++) dc[i].update_and_drawMe();
}