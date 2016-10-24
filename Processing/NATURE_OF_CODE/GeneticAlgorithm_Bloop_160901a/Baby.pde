class Baby extends Mover{
  DNA dna;
  Bloop parent0 , parent1;
  Baby(World w_){
    super(w_);
    shapeRadius = 0;
    delete = false;
  }
  void evolution(){
    Bloop b = (Bloop)w.createObject("Bloop");
    b.dna = dna;
    b.location = location;
    b.state0 = 0;
    b.state1 = true;
    if(random(1) < 0.5){
      parent0.eatCount--;
    }
    else{
      parent1.eatCount--;
    }
    parent0.baby = null;
    parent1.baby = null;
    w.deleteFlagSetObject(this);
  }
  void growUp(){
    shapeRadius += (float)5 / (1 * 60);
    //parentが死んだら?_
    if(shapeRadius > 5){
      evolution();
    }
  }
  void run(){
    growUp();
  }
  void locationUpdate(){
    location = PVector.add(parent0.location , PVector.sub(parent1.location , parent0.location).div(2));
  }
  void destructor(){
    parent0.baby = null;
    parent1.baby = null;
  }
  void display(){
    pushStyle();
    fill(#F05CD7 , 128);
    ellipse(location.x , location.y , shapeRadius * 2 , shapeRadius * 2);
    popStyle();
  }
}