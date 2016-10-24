class PVector_{
  float x , y;
  
  PVector_(float x_ ,float y_){
    x = x_;
    y = y_;
  }
  void add(PVector_ v){
    x += v.x;
    y += v.y;
  }
}
class Mover{
  PVector_ location;
  PVector_ velocity;
  
  Mover(){
    location = new PVector_(random(width) , random(height));
    velocity = new PVector_(random(-10 , 10) , random(-10 , 10));
  }
  void update(){
    location.add(velocity);
    if(location.x < 0 || location.x > width){
      if(location.x < 0) location.x = 0;
      else location.x = width;
      velocity.x *= random(1) < 0.5 ? random(-2 , -1) : random(-1 , -0.5);
    }
    if(location.y < 0 || location.y > height){
      if(location.y < 0) location.y = 0;
      else location.y = height;
      velocity.y *= random(1) < 0.5 ? random(-2 , -1) : random(-1 , -0.5);
    }
    println(velocity.y);
  }
  void display(){
    fill(#614BAD);
    noStroke();
    ellipse(location.x , location.y , 100 , 100);
  }
  void disdate(){
    update();display();
  }
}
Mover mover;

void setup(){
  size(854 , 480);
  smooth();
  mover = new Mover();
}
void draw(){
  background(255);
  
  mover.disdate();
}