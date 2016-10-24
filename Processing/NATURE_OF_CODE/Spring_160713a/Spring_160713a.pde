class Mover{
  PVector acceleration;
  PVector Velocity;
  PVector location;
  float mass;
  float diameter(float mass){return mass * 10;}
  Mover(){
    this(new PVector(width / 2 , height / 2) , 10);  
  }
  Mover(PVector l , float m){
    location = l;
    mass = m;
    acceleration = new PVector(0 , 0);
    Velocity = new PVector(0 , 0);
  }
  Mover(PVector l){
    this(l , 10);
  }
  void applyForce(PVector f){
    Velocity.add(PVector.div(f , mass));
  }
  void update(){
    location.add(Velocity);
  }
  void display(){    
    pushStyle();
    fill(0 , 255 , 0);
    stroke(0);
    strokeWeight(2);
    ellipse(location.x , location.y , diameter(mass) , diameter(mass));
    popStyle();
  }
}
class Spring extends Mover{
  PVector anchor;
  float len;
  float k;
  Spring(PVector l , float m , PVector a , float le , float k_){
    super(l , m);
    anchor = a;
    len = le;
    k = k_;
  }
  Spring(PVector l){
    super(l);
    init();
  }
  Spring(){
    init();
  }
  void init(){
    anchor = new PVector(width / 2 , height / 10);
    len = (height * 4) / 10;
    k = 0.1;
  }
  void applySpringForce(){
    PVector force = PVector.sub(location , anchor);
    float d = force.mag();
    force.normalize();
    float stretch = d - len;
    force.mult((-k) * stretch);
    applyForce(force);
  }
  void display(){
    pushStyle();
    fill(255 , 0 , 0);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    rect(anchor.x , anchor.y , 10 , 10);
    line(anchor.x , anchor.y , location.x , location.y);
    
    super.display();
    
    popStyle();
  }
}

Mover m;
Spring s;
PVector w , g;
void setup(){
  size(854 , 480);
  smooth();
  m = new Mover(new PVector(width / 2 , height / 2));
  s = new Spring(new PVector(width / 4 , (height * 3) / 4));
  w = new PVector(2 , 0);
  g = new PVector(0 , 4);
}
void draw(){
  background(255);
  
  m.applyForce(w);
  s.applyForce(g);
  s.applySpringForce();
  
  m.update();
  s.update();
  
  m.display();
  s.display();
}