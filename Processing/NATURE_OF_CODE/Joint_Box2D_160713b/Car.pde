class Box{
 Body box$Body;
 float width_ , height_;
 
 Box(Vec2 location , float boxLength){
   width_ = boxLength;
   height_ = boxLength / 4;
   
   BodyDef bd = new BodyDef();
   bd.position.set(box2d.coordPixelsToWorld(location));
   bd.type = BodyType.DYNAMIC;
   box$Body = box2d.createBody(bd);
   PolygonShape ps = new PolygonShape();
   ps.setAsBox(box2d.scalarPixelsToWorld(width_ / 2) , box2d.scalarPixelsToWorld(height_ / 2));
   FixtureDef fd = new FixtureDef();
   fd.shape = ps;
   fd.density = 1;
   fd.friction = 0.3;
   fd.restitution = 0.5;
   box$Body.createFixture(fd);
 }
 void display(){
   Vec2 location = box2d.coordWorldToPixels(box$Body.getPosition());
   float angle = -(box$Body.getAngle());
   pushMatrix();
   translate(location.x , location.y);
   rotate(angle);
   pushStyle();
   stroke(#362417);
   strokeWeight(2);
   fill(#FAB800);
   rectMode(CENTER);
   rect(0 , 0 , width_ , height_);
   popStyle();
   popMatrix();
 }
}
enum Con{
  LEFT_,
  RIGHT_,
  STOP;
}
class Car{
  Box box;
  Circle circle0 , circle1;
  RevoluteJoint rj0 , rj1;
  Car(float boxLength , float circleRadius){
    box = new Box(new Vec2(mouseX , mouseY) , boxLength);
    Circle_set_radius(circleRadius);
    circle0 = new Circle(BodyType.DYNAMIC , new Vec2(mouseX - ((boxLength / 2) - 5) , mouseY));
    circle1 = new Circle(BodyType.DYNAMIC , new Vec2(mouseX + ((boxLength / 2) - 5) , mouseY));
    
    RevoluteJointDef rjd0 = new RevoluteJointDef();
    rjd0.initialize(box.box$Body , circle0.circle$Body , circle0.circle$Body.getWorldCenter());
    rjd0.enableMotor = true;
    rjd0.motorSpeed = PI * 2;
    rjd0.maxMotorTorque = 10000.0;
    rj0 = (RevoluteJoint)box2d.createJoint(rjd0);
    
    RevoluteJointDef rjd1 = new RevoluteJointDef();
    rjd1.initialize(box.box$Body , circle1.circle$Body , circle1.circle$Body.getWorldCenter());
    rjd1.enableMotor = true;
    rjd1.motorSpeed = PI * 2;
    rjd1.maxMotorTorque = 10000.0;
    rj1 = (RevoluteJoint)box2d.createJoint(rjd1);
  }
  void revoluteJointControl(Con c){
    switch(c){
      case LEFT_:
        rj0.enableMotor(true);
        rj1.enableMotor(true);
        rj0.setMotorSpeed(PI * 2);
        rj1.setMotorSpeed(PI * 2);
        break;
      case RIGHT_:
        rj0.enableMotor(true);
        rj1.enableMotor(true);
        rj0.setMotorSpeed(-(PI * 2));
        rj1.setMotorSpeed(-(PI * 2));
        break;
      case STOP:
        rj0.enableMotor(false);
        rj1.enableMotor(false);
      
    }
  }
  void display(){
    box.display();
    circle0.display();
    circle1.display();
  }
}