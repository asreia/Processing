import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

import java.util.*;

Box2DProcessing box2d;

class Box{
  Body body;
  float r;
  float diameter(float r){return r * 2;}
  float wid = 10;
  float hei = 30;
  Vec2 offset;
  Box(){
   r = 8;
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(mouseX , mouseY));
    
    body = box2d.createBody(bd);
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    PolygonShape ps = new PolygonShape();
    offset = new Vec2(wid / 2 , hei / 2);
    ps.setAsBox(box2d.scalarPixelsToWorld(offset.x) , box2d.scalarPixelsToWorld(offset.y));
    
    //cs.setRadius(2);
    Vec2 Woffset = box2d.vectorPixelsToWorld(offset);
    cs.m_p.set(0 , -Woffset.y);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    
    FixtureDef fd2 = new FixtureDef();
    fd2.shape = ps;
    fd2.density = 1;
    fd2.friction = 0.3;
    fd2.restitution = 0.5;
    
    body.createFixture(fd);
    body.createFixture(fd2);
  }
  void display(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x , pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    rect(0 , 0 , wid , hei);
    translate(0 , -offset.y);
    ellipse(0 , 0 , diameter(r) , diameter(r));
    line(0 , 0 , r , 0);
    popMatrix();
  }
  void killBody(){
    box2d.destroyBody(body);
  }
}
class mouseLine{
  Body b;
  Vec2[] mousePoint_s = {};
  Vec2[] worldMousePoint_s = {};
  mouseLine(Vec2[] mp_s){
    for(int i = 0; i < mp_s.length; i++){
      mousePoint_s = (Vec2[])append(mousePoint_s , mp_s[i]);
      worldMousePoint_s = (Vec2[])append(worldMousePoint_s , box2d.coordPixelsToWorld(mp_s[i]));
    }
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    b = box2d.createBody(bd);
    ChainShape cs = new ChainShape();
    cs.createChain(worldMousePoint_s , worldMousePoint_s.length);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    b.createFixture(fd);
  }
  void display(){
    pushStyle();
    stroke(#ABD167);
    strokeWeight(4);
    for(int i = 0; i < mousePoint_s.length; i++) point(mousePoint_s[i].x , mousePoint_s[i].y);
    popStyle();
  }
}
ArrayList<Box> box_s;
int prev_mouseButton;
Vec2[] _mousePoint_s = {};
ArrayList<mouseLine> mouseLine_arr;
void setup(){
  size(854 , 480);
  smooth();
  box_s = new ArrayList<Box>();
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0 , -10);
  prev_mouseButton = -1;
  mouseLine_arr = new ArrayList<mouseLine>();
}
void draw(){
  background(255);
  
  Iterator mouseLine_it = mouseLine_arr.iterator();
  while(mouseLine_it.hasNext()){
    ((mouseLine)mouseLine_it.next()).display();
  }
  for(int i = 0; i < _mousePoint_s.length; i++){
    pushStyle();
    stroke(#19206F);
    strokeWeight(2);
    point(_mousePoint_s[i].x , _mousePoint_s[i].y);
    popStyle();
  }
  
  box2d.step();
  
  if(mousePressed && mouseButton == LEFT && frameCount % (int)(60 * 0.05) == 0) box_s.add(new Box());
  
  Vec2 mousePoint = new Vec2(mouseX , mouseY);
  if(mousePressed && mouseButton == RIGHT && (_mousePoint_s.length == 0 || mousePoint.sub(_mousePoint_s[_mousePoint_s.length - 1]).length() > 5)){
    _mousePoint_s = (Vec2[])append(_mousePoint_s , mousePoint);
  }
  else if(prev_mouseButton == RIGHT && !(mousePressed && mouseButton == RIGHT)){
    if(_mousePoint_s.length >= 2){
      mouseLine_arr.add(new mouseLine(_mousePoint_s));
    }
    Vec2[] dummy = {};
    _mousePoint_s = dummy;
  }
  prev_mouseButton = mouseButton;
  
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