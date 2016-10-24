class Bullet extends Mover{
  int lifeTime;
  Bloop target;
  float homingForce;
  
  Bullet(World w_){
    super(w_);
    delete = false;
    shapeRadius = 5;
    lifeTime = (int)(60 * 1.2);
  }
  void init(PVector v , PVector l , Bloop t , float f){
    force = new PVector();
    acceleration = new PVector();
    velocity = v;
    location = l;
    target = t;
    homingForce = f;
    locationUpdate();
  }
  PVector seek(PVector tar , float Force){
    if(target.delete == false){
      return PVector.sub(locSub(tar , location) , velocity).normalize().mult(Force * 3);//3
    }
    return new PVector();
  }
  void lifeTimeDecrement(){
    lifeTime--;
    if(lifeTime <= 0){
      w.deleteFlagSetObject(this);
    }
  }
  void homingBullet(){
    applyForce(seek(target.location , homingForce));
  }
  void locationUpdate(){
    acceleration.add(force);
   // acceleration.limit(0.1);
    force.mult(0);
    velocity.add(acceleration);
    //velocity.limit(10);
    acceleration.mult(0);
    location.add(velocity);
  }
  void run(){
    bulletcollision();
    homingBullet();
    lifeTimeDecrement();
    //edgeOutDelete();
  }
  void edgeOutDelete(){
    if(location.x < 0 + 50 || location.x > width - 50 || location.y < 0 + 50 || location.y > height - 50){
      w.deleteFlagSetObject(this);
    }
  }
  void bulletcollision(){
    ArrayList<Bloop> cb_arr = w.collisionObject(shapeRadius , location , w.bloop_arr);
    
    for(Bloop b : cb_arr){
      b.HitPoint -= (float)1 / 2;
      w.deleteFlagSetObject(this);
      if(b.HitPoint <= 0){
        w.deleteFlagSetObject(b);
      }
    }
  }
  void display(){
    pushStyle();
    stroke(64 , 64 , 0 , 255);
    fill(255 , 212 , 0 , 127);
    ellipse(location.x , location.y , shapeRadius * 2 , shapeRadius * 2);
    popStyle();
  }
}