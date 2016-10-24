void setup(){
  size(854 , 480);
  frameRate(300);
  background(240);
  smooth();
  stroke(#569B49);
  strokeWeight(2);
  println(height / 2);
  y0 = (height / 2);
}

float rad;
float angle = 0;
float x0 = 0 , y0 , x1 , y1;
float step = 1;
float defWidth = 150;

int cnt = 1;
void draw(){
    if((x1 += step) > width){
      background(240);
      x0 = 0;
      x1 = step;
    }
    rad = radians(angle);
    angle++;
    y1 = (height / 2) + (pow(sin(rad) , 3) * noise(rad * 2) * defWidth);
    line(x0 , y0 , x1 , y1);
    x0 = x1;
    y0 = y1;
  if(frameCount % 5 == 1){
    int recFrameCnt = 300;
    fill(0);
    textSize(14);
    text("frameCountDown : " + (recFrameCnt - (cnt - 1) <= 0 ? 0 : recFrameCnt - (cnt - 1)) , 0 , 14);
    //if(cnt <= recFrameCnt)saveFrame("processing-" + cnt + ".jpg");
    cnt++;
  }
}