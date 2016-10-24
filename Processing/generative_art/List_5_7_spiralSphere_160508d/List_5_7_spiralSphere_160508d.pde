int radius = 200;

void setup(){
  size(854 , 480 , P3D);
  frameRate(60);
  background(255);
  stroke(0);
}

void draw(){
  background(255);
  
  translate(width / 2 , height / 2 , 0);
  rotateY(frameCount * 0.03);
  rotateX(frameCount * 0.04);
  
  float s = 0  , t = 0;
  float lastx = 0 , lasty = 0 , lastz = 0;
  
  while(t < 180){
    s += 18;
    t += 1;
    float radianS = radians(s);
    float radianT = radians(t);
    
    float thisx = 0 + (radius * cos(radianS) * sin(radianT));
    float thisy = 0 + (radius * sin(radianS) * sin(radianT));
    float thisz = 0 + (radius * cos(radianT));
    
    if(lastx != 0){
      line(thisx , thisy , thisz , lastx , lasty , lastz);
    }
    lastx = thisx;
    lasty = thisy;
    lastz = thisz;
  }
  int recFrameCnt = 300;
  fill(0);
  textSize(14);
  println("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("processing-####.jpg");
}