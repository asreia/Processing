import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;

VerletPhysics2D physics;

class Particle extends VerletParticle2D{
  Particle(Vec2D location){
    super(location);
    physics.addParticle(this);
  }
  void display(){
    fill(175);
    stroke(0);
    ellipse(x , y , 16 , 16);
  }
}
Particle particle0;
Particle particle1;
void setup(){
  size(854 , 480);
  smooth();
  physics = new VerletPhysics2D();
  physics.setWorldBounds(new Rect(0 ,0 , width , height));
  physics.addBehavior(new GravityBehavior(new Vec2D(0 , 0.5)));
  particle0 = new Particle(new Vec2D(width / 2 , height / 3));
  particle1 = new Particle(new Vec2D((width / 2) + 150 , (height / 3) + 150));
  particle0.lock();
  VerletSpring2D spring = new VerletSpring2D(particle0 , particle1 , 150 , 0.01);
  //physics.addParticle(particle0);
  //physics.addParticle(particle1);
  physics.addSpring(spring);
}
void draw(){
  background(255);
  
  physics.update();
  
  particle0.display();
  particle1.display();
}