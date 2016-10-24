class RotateMover{
  float aAcceleration;
  float aVelocity;
  float angle;
  PVector location;
  float _length;
  RotateMover(PVector l , float _l){
    location = l;
    _length = _l;
  }
  void applyForce(float f){
    aAcceleration += f;
  }
  void update(){
    aVelocity += aAcceleration;
    aAcceleration = 0;
    angle += aVelocity;
  }
  void display(){
    fill(128);
    stroke(128);
    strokeWeight(3);
    float x = location.x + (cos(angle) * _length);
    float y = location.y + (sin(angle) * _length);
    line(location.x , location.y , x , y);
    ellipse(x , y , _length / 4 , _length / 4);
  }
}
RotateMover[] rm ={};
ArrayList<RotateMover> arm;
void setup(){
  size(854 , 480);
  smooth();
  rm = (RotateMover[])append(rm , new RotateMover(new PVector(width / 2 , height / 2) , 200));
  arm = new ArrayList<RotateMover>();
  arm.add(new RotateMover(new PVector(width / 2 , height / 2) , 200));
}
void mousePressed(){
  rm = (RotateMover[])append(rm , new RotateMover(new PVector(random(width) , random(height)) , random(200)));
  arm.add(new RotateMover(new PVector(random(width) , random(height)) , random(200)));
}
void draw(){
  background(255);
  for(int i = 0; i < rm.length; i++){
    rm[i].applyForce(0.001);
    rm[i].update();
    rm[i].display();
  }
  for(int i = 0; i < arm.size();i++){
    arm.get(i).applyForce(0.0009);
    arm.get(i).update();
    arm.get(i).display();
  }
}