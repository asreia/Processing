Pendulum p;

void setup(){
  frameRate(60);
  size(854 , 480);
  smooth();
  p = new Pendulum(new PVector(width / 2 , 10) , height - 30);
}
void draw(){
  background(255);
  p.go();
}
class Pendulum{
  PVector location;
  PVector origin;
  float r;
  float angle;
  float aVelocity;
  float aAcceleration;
  float damping;
  Pendulum(PVector origin_ , float r_){
    origin = origin_. get();
    location = new PVector();
    r = r_;
    angle = PI / 4;
    
    aVelocity = 0;
    aAcceleration = 0;
    damping = 0.995;
  }
  void go(){
    update();
    display();
  }
  void update(){
    float gravity = 0.4;
    aAcceleration = (-1 * gravity / r) * sin(angle);
    
    pushStyle();
    stroke(0 , 0 ,255);
    strokeWeight(5);
    line((width * 4) / 5 , height / 2 , (width * 4) / 5 , (height / 2) + -angle * 200);
    popStyle();
    
    aVelocity += aAcceleration;
    angle += aVelocity;
    
    aVelocity *= damping;
  }
  void display(){
    location.set(r * sin(angle) , r * cos(angle));
    //location.set(r * cos(angle) , r * sin(angle));
    location.add(origin);
    
    stroke(0);
    line(origin.x , origin.y , location.x , location.y);
    fill(175);
    ellipse(location.x , location.y , 16 , 16);
  }
}