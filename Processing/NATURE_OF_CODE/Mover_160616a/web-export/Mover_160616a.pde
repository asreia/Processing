class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector resultantForce;
  float mass;
  float topspeed = 1000;
  float clr;
  float diameter(float mass){return mass * 10;}
  float G = 0.4;
  Mover(PVector l , float m){
    location = l;
    velocity = new PVector(0 , 0);
    resultantForce = new PVector(0 , 0);
    mass = m;
    clr = random(300);
  }
  Mover(PVector l){this(l , float(10));}
  void addForce(PVector f){
    resultantForce.add(f);
  }
  void update(){
    acceleration = PVector.div(resultantForce , mass); // A = F / M
    resultantForce.mult(0);
    velocity.add(acceleration);
    location.add(velocity);
  }
  void addGravityForce(Mover m){
    PVector force = PVector.sub(location , m.location);
    float distance = force.mag();
    distance = constrain(distance , 5 , 25);
    force.normalize();
    float str = G * mass * m.mass / pow(distance , 2);
    force.mult(-str);
    m.addForce(force);
  }
  void checkEdges(){
    if(location.x < 0) location.x = width;
    else if(location.x > width) location.x = 0;
    if(location.y < 0) location.y = height;
    else if(location.y > height) location.y =0;
  }
  void display(){
    stroke(0);
    colorMode(HSB);
    fill(clr , 128 , 128 , 128);
    ellipse(location.x , location.y , diameter(mass) , diameter(mass));
    PVector v = PVector.mult(velocity , 10);
    colorMode(RGB);
    stroke(0 , 0 , 255);
    line(location.x , location.y , location.x + v.x , location.y + v.y);
    strokeWeight(5);
    point(location.x + v.x , location.y + v.y);
    PVector a = PVector.mult(acceleration , 100);
    stroke(255 , 0 , 0);
    strokeWeight(1);
    line(location.x , location.y , location.x + a.x , location.y + a.y);
    strokeWeight(5);
    point(location.x + a.x , location.y + a.y);
    strokeWeight(1);
  }
  void process(){
    update();
    //checkEdges();
    display();
  }
}
class Gravity{
  PVector location;
  float mass;
  float G;
  float diameter(float mass){return mass * 0.1;}
  Gravity(float m){
    location = new PVector(mouseX , mouseY);
    mass = m;
    G = 0.4;
  }
  void addGravityForce(Mover m){
    location = new PVector(mouseX , mouseY);
    PVector force = PVector.sub(location , m.location);
    float distance = force.mag();
    distance = constrain(distance , 5 , 25);
    force.normalize();
    float str = G * mass * m.mass / pow(distance , 2);
    force.mult(str);
    m.addForce(force);
  }
  void display(){
    stroke(0);
    colorMode(RGB);
    fill(255 , 0 , 0 , 128);
    ellipse(location.x , location.y , diameter(mass) , diameter(mass));
  }
}
class Drag{
  float x , y , w , h;
  float c;
  Drag(float x_ , float y_ , float w_ , float h_ , float c_){
    x = x_; y = y_; w = w_; h = h_;
    c = c_;
  }
  void display(){
    noStroke();
    colorMode(RGB);
    fill(0 , 0 , 255 , 128);
    rect(x , y , w , h);
  }
  void addDragForce(Mover m){
    if(m.location.x > x && m.location.y > y && m.location.x < x + w && m.location.y < y + h){
      PVector v1 = m.velocity.get();
      PVector v2 = m.velocity.get();
      v1.normalize();
      v1.mult(-1);
      v2.mag();
      PVector force = PVector.mult(v1 , pow(v2.mag() , 2) * c);
      m.addForce(force);
    }
  }
}
class Friction{
  float x , y , w , h;
  float c;
  Friction(float x_ , float y_ , float w_ , float h_ , float c_){
    x = x_; y = y_; w = w_; h = h_;
    c = c_;
  }
  void display(){
    noStroke();
    colorMode(RGB);
    fill(0 ,255 , 0 ,128);
    rect(x , y , w , h);
  }
  void addFrictionForce(Mover m){
    if(m.location.x > x && m.location.y > y && m.location.x < x + w && m.location.y < y + h){
      PVector v = m.velocity.get();
      v.normalize();
      v.mult(-1);
      v.mult(c);
      m.addForce(v);
    }
  }
}
class Wind{
  float x , y , w , h;
  float c;
  Wind(float x_ , float y_ , float w_ , float h_ , float c_){
    x = x_; y = y_; w = w_; h = h_;
    c = c_;
  }
  void display(){
    noStroke();
    colorMode(RGB);
    fill(0 ,255 , 255 ,128);
    rect(x , y , w , h);
  }
  void addWindForce(Mover m){
    if(m.location.x > x && m.location.y > y && m.location.x < x + w && m.location.y < y + h){
      m.addForce(new PVector(c , 0));
    }
  }
}
Mover[] _mover_arr = {};
Gravity gravity;
Drag drag;
Friction friction;
Wind wind;
void setup(){
  size(854 , 480);
  smooth();
  gravity = new Gravity(1000);
  drag = new Drag(0 , height - (height / 3) , width  , (height / 3) , 0.4);
  friction = new Friction(0 , (height / 3) , width  , (height / 3) , 2);
  wind = new Wind(0 , 0 , width / 2  , (height / 3) , 10);
}
void draw(){
  background(255);
  wind.display();
  friction.display();
  drag.display();
  gravity.display();
  if(mousePressed && frameCount % 6 == 0) _mover_arr = (Mover[])append(_mover_arr , new Mover(new PVector(mouseX , mouseY) , random(1 , 20)));
  for(int i = 0; i < _mover_arr.length; i++){
    for(int j = 0; j < _mover_arr.length; j++){
      if(i != j){
        _mover_arr[i].addGravityForce(_mover_arr[j]);
      }
    }
    gravity.addGravityForce(_mover_arr[i]);
    drag.addDragForce(_mover_arr[i]);
    friction.addFrictionForce(_mover_arr[i]);
    wind.addWindForce(_mover_arr[i]);
    _mover_arr[i].process();
  }
}