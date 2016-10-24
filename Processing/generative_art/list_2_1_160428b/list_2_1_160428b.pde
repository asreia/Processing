int diam = 10;
boolean h = true;
float centX , centY;

void setup(){
 size(854, 480);
 frameRate(60);
 smooth();
 centX = width / 2;
 centY = height / 2;
 stroke(#49F04F);
 strokeWeight(50);
 background(180);
 line( 0 , centY , width , centY);
 stroke(0);
}

void draw(){
  if(h){ //<>//
    diam += 3.5;
    if(diam >= 400){
      h = false;
      //saveFrame("screen-####.jpg");
    }
  }
  else if(!h){
   diam -= 3.5;
   if(diam <= 10) h = true; 
  }
  println(diam);
  background(180);
  strokeWeight(5);
  fill(255,50);
  ellipse(centX , centY , diam , diam);
  for(int temp = diam; temp >= 0; temp -= 10){
    strokeWeight(0);
    noFill();
    ellipse(centX , centY, temp , temp);
  }
  int recFrameCnt = 300;
  fill(0);
  textSize(14);
  text("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("List_6_4_moveCircles_160508f-####.jpg");
}