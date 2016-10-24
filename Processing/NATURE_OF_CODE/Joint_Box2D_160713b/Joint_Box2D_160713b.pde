import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

import java.util.*;

Box2DProcessing box2d;

//mouseLine=================================================================================================
//マウスでチェインシェイプを描くクラス_
class mouseLine{
  Body b;
  Vec2[] mousePoint_s = {};
  Vec2[] worldMousePoint_s = {};
  //mouseLineの初期化_
  mouseLine(Vec2[] mp_s){
    //マウスポイント配列を二つの配列にコピー_
    for(int i = 0; i < mp_s.length; i++){
      mousePoint_s = (Vec2[])append(mousePoint_s , mp_s[i]);
      worldMousePoint_s = (Vec2[])append(worldMousePoint_s , box2d.coordPixelsToWorld(mp_s[i]));
    }
    //mouseLineボディー定義_
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
  //mouseLine表示関数_
  void display(){
    pushStyle();
    stroke(#ABD167);
    strokeWeight(4);
    for(int i = 0; i < mousePoint_s.length; i++) point(mousePoint_s[i].x , mousePoint_s[i].y);
    popStyle();
  }
}
//mouseLine制御関数_
void mouseLine_control(){
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
}
//mouseLineと_mousePoint_sの表示関数_
void mouseLine_and__mousePoint_sDisplay(){
  //mouseLineオブジェクトを表示_
  Iterator mouseLine_it = mouseLine_arr.iterator();
  while(mouseLine_it.hasNext()){
    ((mouseLine)mouseLine_it.next()).display();
  }
  //_mousePoint_s配列を表示_
  for(int i = 0; i < _mousePoint_s.length; i++){
    pushStyle();
    stroke(#19206F);
    strokeWeight(2);
    point(_mousePoint_s[i].x , _mousePoint_s[i].y);
    popStyle();
  }  
}

int prev_mouseButton;
Vec2[] _mousePoint_s = {};
ArrayList<mouseLine> mouseLine_arr;
//mouseLine終わり=================================================================================================
//test
Circle c;
Circle_compo cc;
Bridge_facade bf;
Box b;
Car car;
void setup(){
  size(854 , 480);
  smooth();
  //box2dオブジェクトを作成_
  box2d = new Box2DProcessing(this);
  //Box2Dの世界を構築_
  box2d.createWorld();
  //下向き10の重力?を設定_
  box2d.setGravity(0 , -10);
  
  prev_mouseButton = -1;
  mouseLine_arr = new ArrayList<mouseLine>();
  //test
  Circle_set_radius(8);
  c = new Circle(BodyType.DYNAMIC , new Vec2(width / 3 , 50));
  cc = new Circle_compo(8 , 0);
  bf = new Bridge_facade();
  //b = new Box(new Vec2(width / 2 , 0) , 200);
}
boolean noes = true;
void draw(){
  background(255);
  //test
  c.display();
  cc.display();
  bf.display();
  //b.display();
  if(car != null) car.display();
  if(mousePressed && mouseButton == LEFT && noes){
    noes = false;
    car = new Car(150 , 50);
  }
if(car != null){
    if(keyPressed){
      switch(keyCode){
        case LEFT:
          car.revoluteJointControl(Con.LEFT_);
          break;
        case RIGHT:
          car.revoluteJointControl(Con.RIGHT_);
          break;
        default:
          car.revoluteJointControl(Con.STOP);
        
      }
    }
}
  
  //mouseLineと_mousePoint_sの表示関数_
  mouseLine_and__mousePoint_sDisplay();
  
  if(mousePressed && mouseButton == LEFT && frameCount % (int)(60 * 0.05) == 0);
  
  //box2dの物理演算を実行して各box2dのBodyオブジェクトの状態を更新_
  box2d.step();
  
  //mouseLine制御関数_
  mouseLine_control();
}