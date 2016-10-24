import java.util.Random;
Random r;
class DNA{
  float eatForce;
  float couplingForce;
  float avoidanceForce;
  float attackingForce;
  int grownUp;
  
  DNA(){
    eatForce = random(0 , 0.1);
    couplingForce = random(0 , 0.1);
    avoidanceForce = random(0 , 0.1);
    attackingForce = random(0 , 0.1);
    grownUp = (int)random(0 , 10);
  }
  float gd(float d0 , float d1){
    return ((float)r.nextGaussian() * (abs((float)d0 - (float)d1) / 2)) + (((float)d0 + (float)d1) / 2);
  }
  DNA generateDna(DNA d0 , DNA d1){
    DNA rd = new DNA();
    final float P = 0.95;
    if(random(1) < P) rd.eatForce = gd(d0.eatForce , d1.eatForce);
    else                 rd.eatForce = random(0 , 0.1);
    if(random(1) < P) rd.couplingForce = gd(d0.couplingForce , d1.couplingForce);
    else                 rd.couplingForce = random(0 , 0.1);
    if(random(1) < P) rd.avoidanceForce = gd(d0.avoidanceForce , d1.avoidanceForce);
    else                 rd.avoidanceForce = random(0 , 0.1);
    if(random(1) < P) rd.attackingForce = gd(d0.attackingForce , d1.attackingForce);
    else                 rd.attackingForce = random(0 , 0.1);
    if(random(1) < P) rd.grownUp = (int)gd(d0.grownUp , d1.grownUp);
    else                 rd.grownUp = (int)random(0 , 10);
      
    return rd;
  }
}