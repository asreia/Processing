class Bloop extends Mover{
  DNA dna;
  float HitPoint;
  int lifeSpan = 10 * 60;
  int lifeCount = 0;
  int eatCount;
  int stateDelay = 0;
  //state0 0:nothing 1:coupling 2:attack
  int state0;
  //state1 true:eating false:do not eating
  boolean state1;
  Bloop spb;
  Bloop partner;
  Bloop target;
  Baby baby;
  
  Bloop(World w_ , DNA d){
    super(w_);
    shapeRadius = 5;
    delete = false;
    dna = d;
    eatCount = 1;
    HitPoint = 1;
    state0 = 1;
    state1 = true;
    
    location = new PVector(random(width) , random(height));
    float r = random(TWO_PI);
    velocity = new PVector(cos(r) , sin(r));
    velocity.mult(random(3));
    acceleration = new PVector();
    force = new PVector();
  }
  Bloop(World w_){
    this(w_ , new DNA());
  }
  PVector seek(PVector target , float dnaForce){
    return PVector.sub(locSub(target , location) , velocity).normalize().mult(dnaForce);
  }
  PVector seekStop(Mover mover){
    return seek(mover.location , dna.couplingForce).
           add(PVector.sub(mover.velocity , velocity).
               limit(dna.couplingForce * 0.05));              
  }
  PVector seekKeepDist(Mover m){
    float dist = locDist(location , m.location);
    if(dist > 200){
      return seek(m.location , dna.attackingForce);
    }
    
    else{
      return PVector.sub(m.velocity , velocity).limit(dna.attackingForce);
    }
  }
  boolean bool = false;
  void stateUpdate(){
    int prevState0 = state0;
    if(bool){
      if(HitPoint < dna.grownUp) bool = false;
      int coupCnt = 0 , attCnt = 0;
      for(Bloop b : w.bloop_arr){
        coupCnt += b.state0 == 1 ? 1 : 0;
        attCnt += b.state0 == 2 ? 1 : 0;
        if(stateDelay == 0){
          if(coupCnt > attCnt){
            if(partner == null && spb == null){
              state0 = 2;
              state1 = false;
            }
          }
          else{
            state0 = 1;
            state1 = false;
          }
        }
      }
    }
    else{
      if(HitPoint >= dna.grownUp * 1.5) bool = true;
      state0 = 0;
      state1 = true;
    }
    Boolean cntbool = false;
    if(prevState0 == 1 && prevState0 != state0){
      divorce();
      spb = null;
      cntbool = true;
    }
    if(prevState0 == 2 && prevState0 != state0){
      target = null;
      cntbool = true;
    }
    if(stateDelay != 0 || cntbool){
      if(stateDelay >= 60){
        stateDelay = 0;
      }
      else{
        stateDelay++;
      }
    }
    //state変わり目でeatingInit();など_
  }
  void nothing(){
    
  }
  void SRUpdate(){
    shapeRadius = sqrt((HitPoint * (pow(5 , 2) * PI))/ PI);
  }
  void eating(){
    ArrayList<Food> cOb_arr = w.collisionObject(shapeRadius , location , w.food_arr);
    for(Food f : cOb_arr){
      if((!f.delete) && HitPoint <= dna.grownUp * 2){
        f.recovery(this);
      }
    }
    //foodSeek?
    ArrayList<Food> ob_arr = w.nearObject(w.food_arr , location , 300);
    if(ob_arr.size() >= 1){
      //line(ob_arr.get(0).location.x , ob_arr.get(0).location.y , location.x , location.y);
      applyForce(seek(ob_arr.get(0).location , dna.eatForce));
      if(locDist(ob_arr.get(0).location , location) < 150){
        applyForce(PVector.mult(velocity , -0.01));
      }
    }
  }
  void death(){
    if(partner != null){
      partner.partner = null;
    }
    w.deleteFlagSetObject(this);
  }
  boolean confess(Bloop b){
    partner = b;
    return true;
  }
  void seekPartner(){
    ArrayList<Bloop> bloop_arr = w.nearObject(w.bloop_arr , location , 300);
    spb = null;
    for(int i = 1; i < bloop_arr.size(); i++){
      if(bloop_arr.get(i).state0 == 1 && bloop_arr.get(i).partner == null){
        applyForce(seekStop(spb = bloop_arr.get(i)));
        break;
      }
    }
    if(spb != null && PVector.dist(spb.location , location) < spb.shapeRadius + shapeRadius){
      if(spb.confess(this)) partner = spb;
    }
  }
  void divorce(){
    //spb = null;
    //partner.spb = null;
    if(partner != null){
     partner.partner = null;
     partner.baby = null;
     partner = null;
    }
    //partner.partner = null;
    w.deleteFlagSetObject(baby);
    baby = null;
    //partner.baby = null;
  }
  void giveBirth(){
    partner.baby = baby = (Baby)w.createObject("Baby");
    baby.dna = dna.generateDna(dna , partner.dna);
    baby.parent0 = this;
    baby.parent1 = partner;
    baby.location = PVector.add(location ,locSub(partner.location , location).div(2));
  }
  void rearing(){
    //pushStyle();
    //fill(#984040);
    //textSize(20);
    //text("REA",location.x , location.y - (shapeRadius + 20));
    //popStyle();
    applyForce(seekStop(partner));
    
    /*
    pushStyle();
    strokeWeight(5);
    line(partner.location.x , partner.location.y , location.x , location.y);
    popStyle();
    */
    if(locDist(partner.location , location) < partner.shapeRadius + shapeRadius){
    //pushStyle();
    //fill(#984040);
    //textSize(20);
    //text(baby == null ? "no" : "yes",location.x , location.y - (shapeRadius + 40));
    //popStyle();
      if(baby == null){
        giveBirth();
      }
    }
    else{
      divorce();
      //seekPartner();
    }
  }
  void coupling(){
    if(eatCount < 1){
      w.deleteFlagSetObject(this);
      return;
    }
    if(partner == null || partner.eatCount < 1){
      seekPartner();
    }
    else{
      rearing();
    }
  }
  void shot(){
    PVector LocSubNl = locSub(target.location , location).normalize();
    PVector bulletVelocity = velocity.get();
    PVector shotLoc = PVector.mult(LocSubNl , (shapeRadius + 10)).add(location);
    ((Bullet)w.createObject("Bullet")).init(bulletVelocity , shotLoc , target , dna.attackingForce);
  }
  void searchTarget(){
    ArrayList<Bloop> b_arr = w.nearObject(w.bloop_arr , location , 300);
    //ArrayList<Bloop> b1_arr = new ArrayList<Bloop>();
    for(Bloop b : b_arr){
      if(b.state0 == 1){
        target = b;
        break;
        //b1_arr.add(b);
      }
    }
    if(target == null){
      for(Bloop b : b_arr){
        if(b.state0 == 0){
          target = b;
          break;
        }
      }
    }
    //if(b1_arr.size() >= 1){
    //  target = b1_arr.get(0);
    //}
  }
  boolean isAlive(Bloop b){
    return !b.delete;
  }
  int targetTimer = 0;
  Bloop prevTarget = null;
  void attack(){
    if(target != null && (!isAlive(target) || locDist(target.location , location) > 310)) target = null;
    
    if(target == null){
      searchTarget();
    }
    else{
      //line(target.location.x , target.location.y , location.x , location.y);
      applyForce(seekKeepDist(target));
      if(frameCount % ((int)60 * 0.5) == 0){//0.5
        shot();
      }
      
      if(target != prevTarget){
        targetTimer = 1;
      }
      else{
        if(targetTimer == 0 || targetTimer > 15 * 60){
          targetTimer = 0;
        }
        else{
          targetTimer++;
        }
      }
      
      if(targetTimer == 0){
        target = null;
      }
      
      prevTarget = target;
    }
  }
  PVector avoidanceForceCalc(Mover b ,float d , float ar){
    //float s = pow(map(d , 0 , ar , 0 , sqrt(dna.avoidanceForce)) , 2);
    PVector bLoc = b.location.get() , loc = location.get();
    float dist  = PVector.dist(bLoc , loc) , prevDist = 100000;
    PVector collisionPoint = null;
    while(dist <= prevDist){
      prevDist = dist;
      if(dist < (shapeRadius + b.shapeRadius) * 1.5){
        collisionPoint = bLoc;
      }
      bLoc.add(b.velocity);
      loc.add(velocity);
      dist = PVector.dist(bLoc , loc);
    }
    if(collisionPoint != null){
      //pushStyle();
      //stroke(255 , 0 , 0);
      //strokeWeight(10);
      //point(collisionPoint.x , collisionPoint.y);
      //popStyle();
      return seek(collisionPoint , dna.avoidanceForce).mult(-1);
    }
    else{
      return new PVector(0 , 0);
    }
  }
  void avoidance(){
    float addRadius = 150;
    ArrayList<Bullet> bullet_arr = w.nearObject(w.bullet_arr , location , shapeRadius + addRadius);
    for(Bullet b : bullet_arr){
      float dist_;
      if((dist_ = locDist(b.location , location) - shapeRadius) > 0){
        applyForce(avoidanceForceCalc(b , dist_ , addRadius));
      }
    }
  }
  void toGrowOld(){
    if(--lifeSpan <= 0){
      w.deleteFlagSetObject(this);
    }
  }
  void run(){
    toGrowOld();
    SRUpdate();
    stateUpdate();
    if(state0 != 2)avoidance();
    if(state1) eating();
    if(state0 == 0) nothing();
    if(state0 == 1) coupling();
    if(state0 == 2) attack();
    lifeCount++;
  }
  void burstFood(){
    for(int i = 0; i < eatCount; i++){
      Food food = (Food)w.createObject("Food");
      float angle = random(TWO_PI);
      food.location = PVector.add(location , (new PVector(cos(random(angle)) , sin(random(angle)))).mult(random(150)));  
    }
  }
  void destructor(){
    burstFood();
    divorce();
  }
  float heartBeat = 64;
  boolean direction = true;
  void display(){
    pushStyle();
    //testcode
    /*
    ArrayList<Food> ob_arr = w.nearObject(w.food_arr , location , 300);
    for(int i = 0; i < ob_arr.size(); i++){
      float sw = map(i , 0 , ob_arr.size() - 1 , 10 , 1);
      float c = map(i , 0 , ob_arr.size() - 1 , 127 , 255);
      strokeWeight(sw);
      colorMode(HSB);
      stroke(c , 255 , 255 , 64);
      line(location.x , location.y , ob_arr.get(i).location.x , ob_arr.get(i).location.y);
    }
    */
    //end
    if(lifeSpan < 10 * 60){
      if(direction){
        if((heartBeat -= (float)64 / 30) < 0){
          direction = false;
        }
      }
      else{
        if((heartBeat += (float)64 / 30) > 64){
          direction = true;
        }
      }
    }
    else{
      heartBeat = 64;
    }
    colorMode(RGB);
    strokeWeight((float)eatCount * 0.3);
    switch(state0){
      case 0:
        stroke(0 , 0 , 191 , heartBeat + 191);
        fill(0 , 0 , 255 , heartBeat);
        break;
      case 1:
        stroke(0 , 191 , 0 , heartBeat + 191);
        fill(0 , 255 , 0 , heartBeat);
        break;
      case 2:
        stroke(191 , 0 , 0 , heartBeat + 191);
        fill(255 , 0 , 0 , heartBeat);
        break;
    }
    ellipse(location.x , location.y , shapeRadius * 2 , shapeRadius * 2);
    //textSize(20);
    //text(eatCount,location.x , location.y - shapeRadius);
    popStyle();
  }
}