int _num = 10;
Circle[] _circleArray = {};
AverageFrameRate afr;

void setup(){
  size(854 , 480);
  frameRate(60);
  //fullScreen();
  background(255);
  smooth();
  strokeWeight(1);
  fill(150 , 50);
  drawCircles();
  afr = new AverageFrameRate();
}

void draw(){
  //fill(255 , 5);
  //rect(0 , 0 , width , height);
  background(255);
  for(int i = 0; i < _circleArray.length; i++){
    Circle thisCircle = _circleArray[i];
    thisCircle.updateMe();
  }
  fill(0);
  textSize(14);
  text("frameRate : " + afr.averageFrameRateFunction() , 0 ,14);
  text("circleArray.length : " + _circleArray.length , 0 , 28);
  text("point : " + mouseX + " , " + mouseY , mouseX + 16 , mouseY + 8);
  int recFrameCnt = 1800;
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 42);
  //if(frameCount <= recFrameCnt)saveFrame("List_6_4_moveCircles_160508f-####.jpg");
}

void mouseReleased(){
  drawCircles();
}

void drawCircles(){
  for(int i = 0; i < _num; i++){
    Circle thisCircle = new Circle();
    thisCircle.drawMe();
    _circleArray = (Circle[])append_(_circleArray , thisCircle);
  }
}

class Circle{
  float x , y;
  float radius;
  color lineColor , fillColor;
  float alph;
  float move;
  
  Circle(){ //<>//
    x = random(width);
    y = random(height);
    radius = random(100) + 10; //<>// //<>// //<>//
    lineColor = color(random(255) , random(255) , random(255));
    fillColor = color(random(255) , random(255) , random(255));
    alph = random(255); //<>// //<>//
    move = random(10);
    noiseVar = random(10);
    prev_noise = random(1);
  }
  void drawMe(){
    noStroke(); //<>//
    fill(fillColor , alph);
    ellipse(x , y , radius * 2 , radius * 2);
    stroke(lineColor , 150); //<>//
    noFill();
    ellipse(x , y , 10 , 10);
    stroke(#2E32F0 , 200);
    line(x , y , x + (cos(noiseAngle) * radius) , y +(sin(noiseAngle) * radius));
  }
  float noiseVar;
  float prev_noise;
  float noiseAngle;
  
  void updateMe(){
    noiseVar += 0.01;  
    float t = (prev_noise  + (noise(noiseVar) - 0.5) * 0.02);
    while(t < 0) t += 1;
    while(t > 1) t -= 1;
    float now_noise = t;
    noiseAngle = (now_noise * (2 * PI));
    move = noise(noiseVar) * 10;
    x += move * cos(noiseAngle);
    y += move * sin(noiseAngle);
    prev_noise = now_noise;
    if(x > (width + radius)) x = 0 - radius;
    if(x < (0 - radius)) x = width + radius;
    if(y > (height + radius)) y = 0 - radius;
    if(y < (0 - radius)) y = height + radius;
    
    boolean touching = false;
    for(int i = 0; i < _circleArray.length; i++){
      float overlap;
      if(_circleArray[i] != this && 
      (overlap = dist(x , y , _circleArray[i].x , _circleArray[i].y) - 
      (radius + _circleArray[i].radius)) < 0){
        touching =true;
        float midx = (x + _circleArray[i].x) / 2;
        float midy = (y + _circleArray[i].y) / 2;
        stroke(0 , 100);
        noFill();
        overlap *= -1;
        ellipse(midx , midy , overlap , overlap);
        stroke(#5ece78 , 200);
        line(x , y , _circleArray[i].x , _circleArray[i].y);
      }
    }
    if(touching){if(alph > 0)alph--;}
    else if(alph < 255)alph += 2;
    
    drawMe();
  }
}

Object[] append_(Object[] obArr , Object ob){
                          /*(Circle -> Object) #=> error*/
  Object[] newObArr = new Circle[obArr.length + 1];
  for(int i = 0; i < obArr.length; i++){
    newObArr[i] = obArr[i];
  }
  newObArr[newObArr.length - 1] = ob;
  
  return newObArr;
}

class AverageFrameRate{
  float averageFrameRate = 0;
  float sumFrame = 0;
  
  float averageFrameRateFunction(){
    sumFrame += frameRate;
    
    if(frameCount % 30 == 0){
      averageFrameRate = ((float)((int)((sumFrame / 30) * 10))) / 10;
      sumFrame = 0;
    }
    return averageFrameRate;
  }
}