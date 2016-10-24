//クラスとメンバは意味が分かる名前を付ける_
//型の定義は最初の1文字は大文字で_
float Circle_radius;
void Circle_set_radius(float r){
    Circle_radius = r;
  }
class Circle{
  //型を明記したい場合は"名前$型"と書く_
  Body circle$Body;
  float radius;
  Circle(BodyType bt , Vec2 location){
    //関数内でしか使わず型で意味が分かる変数は略す_
    //BodyDef => bd
    //基本型やVec2などは意味が分かる名前を付ける_
    //float => Circle_radius , length
    //アキュームレータ的に使う変数は簡単に_
    //float = f , f1 , f2
    radius = Circle_radius;
    Vec2 worldLocation = box2d.coordPixelsToWorld(location);
    
    BodyDef bd = new BodyDef();
    bd.type = bt;
    bd.position.set(worldLocation);
    circle$Body = box2d.createBody(bd);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(radius);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    //density(デンシティ) : 密度_
    fd.density = 1;
    fd.friction = 1;
    //restitution(レスティテューション) : 弾性性
    fd.restitution = 0.5;
    circle$Body.createFixture(fd);
  }
  void display(){
    Vec2 location = box2d.coordWorldToPixels(circle$Body.getPosition());
    float angle = -(circle$Body.getAngle());
    
    pushMatrix();
    translate(location.x , location.y);
    rotate(angle);
    pushStyle();
    fill(128 , 255 , 0);
    stroke(255, 0 , 128);
    strokeWeight(4);
    ellipse(0 , 0 , radius * 2 , radius * 2);
    stroke(#FF7158);
    line(0 , 0 , radius , 0);
    popMatrix();
    popStyle();
  }
}
//Composition(コンポジション)  : 組成_
//Aggregation(アグリゲーション) : 集約_
class Circle_compo{
  //特定のアビリティーがある物は
  //"...アビリティー_名前_アビリティー_..._アビリティー_名前_..."と書く_
  //配列 => _arr , 取得 => get_ , 設定 => set_ , インターフェース => _inter
  //組成 => _compo , 集約 => _aggre , 定数 => _cons
  //デザインパターン => _facade , _bridge , _adapter , _factory
  ArrayList<Circle> Circle_arr;
  BodyType bt;
  Circle_compo(float radius , float height_){
    Circle_arr = new ArrayList<Circle>();
    int num = (int)(width / (radius * 2));
    float pos = radius;
    for(int i = 0; i < num; i++){
      if(i == 0 || i == num -1) bt = BodyType.STATIC; else bt = BodyType.DYNAMIC;
      Circle_arr.add(new Circle(bt , new Vec2(pos , height_)));
      pos += radius * 2;
    }
  }
  void display(){
    Iterator<Circle> ci =  Circle_arr.iterator();
    while(ci.hasNext()){
      ((Circle)ci.next()).display();
    }
  }
}
class Bridge_facade{
  Circle_compo cc;
  Bridge_facade(){
    cc = new Circle_compo(8 , 5);
    for(int i = 0; i < cc.Circle_arr.size() - 1; i++){
      DistanceJointDef djd = new DistanceJointDef();
      djd.bodyA = ((Circle)cc.Circle_arr.get(i)).circle$Body;
      djd.bodyB = ((Circle)cc.Circle_arr.get(i + 1)).circle$Body;
      djd.length = djd.bodyB.getPosition().sub(djd.bodyA.getPosition()).length();
      djd.frequencyHz = 10;
      djd.dampingRatio = 100;
      box2d.world.createJoint(djd);
    }
  }
  void display(){
    cc.display();
    
    pushStyle();
    stroke(#834210);
    strokeWeight(4);
    for(int i = 0; i < cc.Circle_arr.size() - 1; i++){
      Vec2 bodyAPos = box2d.coordWorldToPixels(((Circle)cc.Circle_arr.get(i)).circle$Body.getPosition());
      Vec2 bodyBPos = box2d.coordWorldToPixels(((Circle)cc.Circle_arr.get(i + 1)).circle$Body.getPosition());
      line(bodyAPos.x , bodyAPos.y , bodyBPos.x , bodyBPos.y);
    }
    popStyle();
  }
}