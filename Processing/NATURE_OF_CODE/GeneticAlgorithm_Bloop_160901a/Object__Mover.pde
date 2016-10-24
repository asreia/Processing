class Object_{
  World w;
  public PVector location;
  float shapeRadius;
  boolean calledDestructor = false;
  boolean delete;
  
  //Object_(){}
  Object_(World w_){
    w = w_;
  }
  
  void run(){}
  void display(){}
  void destructor(){}
}
class Mover extends Object_{
  PVector velocity;
  PVector acceleration;
  PVector force;
  
  Mover(World w_){
    super(w_);
  }

  void applyForce(PVector f){
    force.add(f);
  }
  void locationUpdate(){
    acceleration.add(force);
    acceleration.limit(0.1);
    force.mult(0);
    velocity.add(acceleration);
    velocity.limit(10);
    acceleration.mult(0);
    location.add(velocity);
  }
}