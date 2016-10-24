import java.util.*;

class World{
  ArrayList<Food> food_arr;
  ArrayList<Baby> baby_arr;
  ArrayList<Bloop> bloop_arr;
  ArrayList<Bullet> bullet_arr;
  ArrayList<Mover> mover_arr;
  ArrayList<Object_> object__arr;
  ArrayList<Object_> bufferObject;
  
  World(){
    bufferObject = new ArrayList<Object_>();
    food_arr = new ArrayList<Food>();
    bloop_arr = new ArrayList<Bloop>();
    //Food , Bloop作成_
    //testcode
    for(int i = 0; i < 100; i++){
      if(random(1) < 0.5){
        food_arr.add(new Food(this));
      }
      else{
        bloop_arr.add(new Bloop(this));
      }
    }
    //end
    bullet_arr = new ArrayList<Bullet>();
    baby_arr = new ArrayList<Baby>();
    object__arr = new ArrayList<Object_>();
    for(Food f : food_arr){
      object__arr.add(f);
    }
    for(Bloop b : bloop_arr){
      object__arr.add(b);
    }
    mover_arr = new ArrayList<Mover>();
    for(Bloop b : bloop_arr){
      mover_arr.add(b);
    }
  }
  void dnaDisplay(float dr , color col , float d , String ds){
    pushStyle();
    textSize(20);
    noStroke();
    fill(col , 128);
    if(ds == "growing"){
      rect(dr , height - 20 , 50 , -(d * 30));
    }
    else{
      rect(dr , height - 20 , 50 , -(d * 3000));
    }
    fill(0);
    pushMatrix();
    rotate(PI / 2);
    float sh = ds.length() * 11;
    float sw = 28;
    if(ds == "growing") sw = 8;
    text(ds , height - (100 + 20) , -(dr + sw));
    if(ds != "growing"){
      text("force" , height - (100 + 20) , -(dr + 8));
    }
    popMatrix();
    popStyle();
  }
  void bloopCountDisplay(float dr , color col , int n , String s){
    pushStyle();
    textSize(20);
    noStroke();
    fill(col , 128);
    rect(0 , dr , n * 10 , 40);
    fill(0);
    text(s , 0 , dr + 35);
    popStyle();
  }
  void monitor(){
    int N , C , A;
    N = C = A = 0;
    float ea , co , av , at , gr;
    ea = co = av = at = gr = 0;
    for(Bloop b : bloop_arr){
      N += b.state0 == 0 ? 1 : 0;
      C += b.state0 == 1 ? 1 : 0;
      A += b.state0 == 2 ? 1 : 0;
      ea += b.dna.eatForce;
      co += b.dna.couplingForce;
      av += b.dna.avoidanceForce;
      at += b.dna.attackingForce;
      gr += (float)b.dna.grownUp;
    }
    ea /= bloop_arr.size();
    co /= bloop_arr.size();
    av /= bloop_arr.size();
    at /= bloop_arr.size();
    gr /= bloop_arr.size();
    
    pushStyle();
    textSize(20);
    strokeWeight(2);
    fill(0);
    //text("Food" + food_arr.size() , 0 , 20);
    //text("ALL" + (N + C + A) + " N / (A + C)" + (float)((int)(10 * ((float)N / (A + C)))) / 10 /* + "N" + N + "C" + C + "A" + A*/ , 0 , 40);
    //textSize(20);
    //noStroke();
    //fill(#FF8F05 , 128);
    //rect(0 , height , 50 , -(ea * 3000));
    //fill(0);
    //text("ea" , 10 , height);
    bloopCountDisplay(0 , #FF8F05 , food_arr.size() , "food");
    bloopCountDisplay(40 , color(0 , 0 , 255) , N * 3 , "eater * 3");
    bloopCountDisplay(80 , color(0 , 255 , 0) , C * 3 , "coupler * 3");
    bloopCountDisplay(120 , color(255 , 0 , 0) , A  * 3, "attacker * 3");
    dnaDisplay(0 , color(0 , 0 , 255) , ea , "eating");
    dnaDisplay(50 , color(0 , 255 , 0) , co , "coupling");
    dnaDisplay(100 , color(255 , 0 , 0) , at , "attacking");
    dnaDisplay(150 , color(255, 0 , 255) , av , "avoidance");
    dnaDisplay(200 , color(0 , 255 , 255) , gr , "growing");
    fill(#3C0071 , 128);
    noStroke();
    rect(0 , height - 20 , 250 , 20);
    fill(0 , 255);
    text("D          N          A" , 40 , height - 2);
    strokeWeight(2);
    stroke(#593076 , 32);
    line(0 , height - (150 + 20) , 250 , height - (150 + 20));
    line(0 , height - (300 + 20) , 250 , height - (300 + 20));
    //text("gr: " + (int)gr , 210 , height - 5);
    popStyle();
  }
  void burstBloop(){
    int attCnt = 0;
    for(Bloop b : bloop_arr){
      if(b.state0 == 2) attCnt++;
    }
    if(food_arr.size() == 0){
      Bloop minLife = bloop_arr.get(0);
      for(Bloop b : bloop_arr){
        if(minLife.lifeCount < b.lifeCount){
          minLife = b;
        }
      }
      deleteFlagSetObject(minLife);
    }
  }
  void run(){
    background(255);
    deleteObject();
    addBuffer();
    Object_Run();
    burstBloop();
    locationUpdate();
    edge();
    
    monitor();
    display();
  }
  <T extends Object_> void delete(ArrayList<T> ob_arr){
    for(int i = ob_arr.size() - 1; i >= 0; i--){
      if(ob_arr.get(i).delete) ob_arr.remove(ob_arr.get(i));
    }
  }
  void addBuffer(){
    for(Object_ ob  : bufferObject){
      if(ob.getClass() == Food.class){
        food_arr.add((Food)ob);
      }
      else if(ob.getClass() == Baby.class){
        baby_arr.add((Baby)ob);
      }
      else if(ob.getClass() == Bloop.class){
        bloop_arr.add((Bloop)ob);
      }
      else if(ob.getClass() == Bullet.class){
        bullet_arr.add((Bullet)ob);
      }
      if(ob.getClass() != Object_.class && ob.getClass() != Food.class){
        mover_arr.add((Mover)ob);
      }
      object__arr.add((Object_)ob);
    }
    bufferObject.clear();
  }
  Object_ createObject(String s){
    Object_ ro = null;
    switch(s){
      case "Food":
        ro = new Food(this);
        break;
      case "Baby":
        ro = new Baby(this);
        break;
      case "Bloop":
        ro = new Bloop(this);
        break;
      case "Bullet":
        ro = new Bullet(this);
        break;
      case "Mover":
        ro = new Mover(this);
        break;
      case "Object_":
        ro = new Object_(this);
        break;
    }
    bufferObject.add(ro);
    return ro;
  }
  void deleteObject(){
    delete(food_arr);
    delete(bloop_arr);
    delete(bullet_arr);
    delete(mover_arr);
    delete(object__arr);
    delete(baby_arr);
  }
  void Object_Run(){
    for(Object_ o : object__arr){
      o.run();
    }
  }
  void locationUpdate(){
    for(Mover m : mover_arr){
      m.locationUpdate();
    }
  }
  void display(){
    for(Object_ o : object__arr){
      o.display();
    }
  }
  void edge(){
    for(Object_ o : object__arr){
      PVector l = o.location;
      
      while(l.x < 0) l.x += width;
      while(l.x > width) l.x -= width;
      while(l.y < 0) l.y += height;
      while(l.y > height) l.y -= height;
    }
  }
  <T extends Object_> ArrayList<T> sortObject(ArrayList<T> alOb , PVector l){
    ArrayList<T> CAlOb = (ArrayList<T>)alOb.clone();
    
    for(int i = 0; i < CAlOb.size() - 1; i++){
      for(int j = i + 1; j < CAlOb.size(); j++){
        if(locDist(l , CAlOb.get(i).location) > locDist(l , CAlOb.get(j).location)){
          T temp = CAlOb.get(i);
          CAlOb.set(i , CAlOb.get(j));
          CAlOb.set(j , temp);
        }
      }
    }
    return CAlOb;
  }
  <T extends Object_> ArrayList<T> nearObject(ArrayList<T> alOb , PVector l , float r){
    ArrayList<T> RAlOb = new ArrayList<T>();
    for(T ob : alOb){
      if(locDist(l , ob.location) < r && !ob.delete){
        RAlOb.add(ob);
      }
    }
    RAlOb = sortObject(RAlOb , l);
    return RAlOb;
  }
  <T0 , T1 extends Object_> void deleteFlagSet(Class c , ArrayList<T1> ob_arr , T0 ob){
    //if(ob.getClass() == c){
    for(T1 ob1 : ob_arr){
      if(ob1.equals(ob)){
        if(!ob1.calledDestructor){
          ob1.calledDestructor = true;
          ob1.destructor();
        }
        ob1.delete = true;
      }
    }
    //}
  }
  <T> void deleteFlagSetObject(T ob){
    deleteFlagSet(Food.class , food_arr , ob);
    deleteFlagSet(Bloop.class , bloop_arr , ob);
    deleteFlagSet(Bullet.class , bullet_arr , ob);
    deleteFlagSet(Mover.class , mover_arr , ob);
    deleteFlagSet(Object_.class , object__arr , ob);
    deleteFlagSet(Baby.class , baby_arr , ob);
  }
  <T extends Object_> ArrayList<T> collisionObject(float r , PVector l , ArrayList<T> ob_arr){
    ArrayList<T> rOb = new ArrayList<T>();
    for(T ob : ob_arr){
      if(PVector.dist(ob.location , l) < r + ob.shapeRadius){
        rOb.add(ob);
      }
    }
    return rOb;
  }
}