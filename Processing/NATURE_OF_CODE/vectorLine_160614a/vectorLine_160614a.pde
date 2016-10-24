void setup(){
  size(854 , 480);
  smooth();
}

void draw(){
  background(255);
  
  PVector mouse = new PVector(mouseX , mouseY);
  PVector center = new PVector(width / 2 , height / 2);
  
  mouse.sub(center);
  //mouse.normalize();
  //mouse.mult(150);
  
  fill(0);
  rect(0 , 0 , mouse.mag() , 10);
  
  //translate(center.x , center.y);
  
  line(width / 2 , height / 2 , width / 2 + mouse.x , height / 2 + mouse.y);
}