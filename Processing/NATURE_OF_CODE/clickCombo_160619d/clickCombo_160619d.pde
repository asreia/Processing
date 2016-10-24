int timer = 0;
int clickCounter = 0;
boolean prevMousePressed = false;
int clickCombo(){
  int combo = 0;
  if(!mousePressed && prevMousePressed){
    clickCounter++;
    timer = 0;
  }
  //text(clickCounter , width / 2 + 150 , height / 2 + 64);
  prevMousePressed = mousePressed;
  if(clickCounter >= 1) timer++;
  if(timer > frameRate * 0.5){
    combo = clickCounter;
    clickCounter = 0;
    timer = 0;
  }
  return combo;
}
class TextDelay extends Thread{
  int number;
  int time = (int)frameRate * 3;
  int countDown = time;
  boolean prevDrawClock;
  TextDelay(int n){
    number = n;
    prevDrawClock = !drawClock;
  }
  public void run(){
    while(true){
      //println(drawClock);
      if(drawClock !=prevDrawClock){
        prevDrawClock = drawClock;
        println("call");
        if(countDown >= 0){
          fill(0 , 255 , 0 , ((float)countDown / time) * 255);
          text(number , (width / 2) + 150 , (height / 2) + (((float)countDown / time) * 64));
          countDown--;
        }
      }
    }
  }
}
boolean drawClock = false;
void setup(){
  size(854 , 480);
  frameRate(4);
  smooth();
  textSize(128);
}
int timer2 = 0;
void draw(){
  drawClock = !drawClock;
  println(drawClock);
  background(255);
  int combo = clickCombo();
  fill(0);
  text(combo , width / 2 - 150 , height / 2 + 64);
  if(combo >= 1){
    Thread td = new TextDelay(combo);
    td.start();
    println(combo);
  }
}