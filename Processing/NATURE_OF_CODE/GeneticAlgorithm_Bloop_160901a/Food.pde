class Food extends Object_{
  float recoveryAmount;
  Food(PVector l , World w_){
    super(w_);
    location = l;
    shapeRadius = 10;
    delete = false;
    recoveryAmount = 1;
  }
  Food(World w_){
    this(new PVector(random(width) , random(height)) , w_);
  }
  void recovery(Bloop b){
    b.HitPoint += recoveryAmount;
    b.eatCount += recoveryAmount;
    b.lifeSpan += recoveryAmount * 10 * 60;
    
    w.deleteFlagSetObject(this);
  }
  void display(){
    pushStyle();
    fill(#FF8F05 , 64);
    ellipse(location.x , location.y , shapeRadius * 2 , shapeRadius * 2);
    fill(#C95410 , 64);
    ellipse(location.x , location.y , shapeRadius , shapeRadius);
    popStyle();
  }
}