import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

import java.util.*;

Box2DProcessing box2d;

class Box{
  Body body;
  float w , h;
  Box(){
    w = 16; h = 16;
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(mouseX , mouseY));
    
    body = box2d.createBody(bd);
    
    PolygonShape ps = new PolygonShape();
    ps.setAsBox(box2d.scalarPixelsToWorld(w / 2) , box2d.scalarPixelsToWorld(h / 2));
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    
    body.createFixture(fd);
  }
  void display(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x , pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    rectMode(CENTER);
    rect(0 , 0 , w , h);
    popMatrix();
  }
  void killBody(){
    box2d.destroyBody(body);
  }
}
class Boundary{
  float x , y;
  float w , h;
  Body b;
  Boundary(float x_ , float y_ , float w_ , float h_){
    x = x_; y = y_; w = w_; h = h_;
    
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(x , y));
    bd.type = BodyType.STATIC;
    b = box2d.createBody(bd);
    PolygonShape ps = new PolygonShape();
    ps.setAsBox(box2d.scalarPixelsToWorld(w /2) , box2d.scalarPixelsToWorld(h / 2));
    b.createFixture(ps , 1);
  }
  void display(){
    pushStyle();
    stroke(0);
    strokeWeight(1);
    fill(0,255,255);
    rectMode(CENTER);
    rect(x , y , w , h);
    popStyle();
  }
}
ArrayList<Box> box_s;
Boundary boundary;
void setup(){
  size(854 , 480);
  smooth();
  box_s = new ArrayList<Box>();
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0 , -10);
  boundary = new Boundary(width / 2 , (height * 9) / 10 , (width * 4) / 5 , 10);
}
void draw(){
  background(255);
  
  boundary.display();
  
  box2d.step();
  
  if(mousePressed && frameCount % (int)(60 * 0.05) == 0) box_s.add(new Box());
  
  Iterator<Box> it = box_s.iterator();
  
  while(it.hasNext()){
    Box box = it.next();
    box.display();
    Vec2 pos = box2d.getBodyPixelCoord(box.body);
    if(pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > (height * 10) / 11){
      box.killBody();
      it.remove();
    }
  }
}