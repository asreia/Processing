PVector vec0 , vec1;
void setup(){
  size(854 , 480);
  smooth();
  vec0 = new PVector(random(-(width / 2) , width / 2)  , random(-(height / 2) , height / 2));
  vec1 = new PVector(random(-(width / 2) , width / 2)  , random(-(height / 2) , height / 2));
}
void draw(){
  background(255);
  
  float centerX = width / 2;
  float centerY = height / 2;
  if(mousePressed && mouseButton == LEFT){
    vec0.x = mouseX - centerX;
    vec0.y = mouseY - centerY;
  }
  if(mousePressed && mouseButton == RIGHT){
    vec1.x = mouseX - centerX;
    vec1.y = mouseY - centerY;
  }
  
  translate(centerX , centerY);
  stroke(255 , 0 , 0);
  strokeWeight(3);
  line(0 , 0 , vec0.x , vec0.y);
  stroke(0 , 0 , 255);
  line(0 , 0 , vec1.x , vec1.y);
  float angle = PVector.angleBetween(vec0 , vec1);
  
  //translate(-centerX , -centerY);
  fill(0);
  textSize(20);
  text(angle , 0 , -20);
  text((angle / TWO_PI) * 360 , 0 , 0);
}