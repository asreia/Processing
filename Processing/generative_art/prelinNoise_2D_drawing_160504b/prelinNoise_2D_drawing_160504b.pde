void setup(){
  size(300 , 300);
  smooth();
  background(255);
  frameRate(60000);
}
float xstart = random(10);
float xnoise = xstart;
float ynoise = random(10);
int y = 0;
int x = 0;
boolean doneFlag = false;
void draw(){
  if(y <= height){
    if(x > width){
      x = 0;
      y++;
      ynoise += 0.01;
      xnoise = xstart;
    }
    x++;
    xnoise += 0.01;
    int alph = int(noise(xnoise , ynoise) * 255);
    stroke(0 , alph);
    line(x , y , x + 1 , y + 1);
    //point(x , y);
  }
  else if(!doneFlag){
    println("done");
    doneFlag = true;    
  }
}