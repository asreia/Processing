FlowField flowField = null;
int prevFrameCount = -1;
Path path;
class Vehicle{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  PVector[] trajectory;
  
  Vehicle(float x , float y){
    maxspeed = 4;
    maxforce = 0.04;
    acceleration = new PVector(0 , 0);
    float angle = random(PI * 2);
    velocity = new PVector(cos(angle) , sin(angle));
    velocity.mult(maxspeed);
    location = new PVector(x , y);
    r = 3.0;
    trajectory = new PVector[100];
    for(int i = 0; i < trajectory.length; i++) trajectory[i] = new PVector(location.x , location.y);
  }
  void update(){
    if(frameCount % 1 == 0){
      for(int i = trajectory.length - 2; i >= 0; i--){
        trajectory[i + 1] = trajectory[i];
      }
      trajectory[0] = location.get();
    }
    
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
    
    while(location.x < 0) location.x += width + 1;
    while(location.x > width) location.x -= width + 1;
    while(location.y < 0) location.y += height + 1;
    while(location.y > height) location.y -= height + 1;
  }
  void applyForce(PVector force){
    acceleration.add(force);
  }
  void seek(PVector target , final float m1){
    PVector desired = PVector.sub(target , location);
    //desired.mult(0.05);
    float distance = desired.mag();
    desired.normalize();
    if(distance < 100){
     float m = map(distance , 0 , 100 , 0 , maxspeed);
     desired.mult(m);
    }
    else{
    desired.mult(maxspeed);
    }
    PVector steer = PVector.sub(desired  , velocity);
    steer.limit(maxforce);
    //steer.mult(-1);
    applyForce(PVector.mult(steer , m1));
  }
  void loitering(){
    PVector circleCenter = PVector.add(velocity , new PVector(0 , 0));
    circleCenter.normalize();
    circleCenter.mult(150);
    circleCenter.add(location);
    float angle = random(PI * 2);
    PVector circlePoint = new PVector((cos(angle) * 50) + circleCenter.x , (sin(angle) * 50) + circleCenter.y);
    PVector force = PVector.sub(circlePoint , location);
    //float distance = force.mag();
    force.normalize();
    force.mult(maxspeed);
    force.sub(velocity);
    
    applyForce(force);
    
    pushStyle();
    stroke(0 , 255 , 0);
    strokeWeight(2);
    noFill();
    line(location.x , location.y , circleCenter.x , circleCenter.y);
    ellipse(circleCenter.x , circleCenter.y , 100 , 100);
    line(circleCenter.x , circleCenter.y , circlePoint.x , circlePoint.y);
    strokeWeight(4);
    stroke(0 , 0 , 255);
    point(circlePoint.x , circlePoint.y);
    popStyle();
  }
  void flow(){
    if(flowField == null) flowField = new FlowField(20);
    
    update();
    if(frameCount != prevFrameCount) flowField.update();
    
    PVector force = flowField.getDirection(location);
    force.mult(maxspeed);
    force.sub(velocity);
    force.limit(maxforce);
    applyForce(force);
    
    if(frameCount != prevFrameCount) flowField.display();
    prevFrameCount = frameCount;
    display();
  }
  PVector getNormalPoint(PVector location , PVector pointA  , PVector pointB){
    PVector AtoB = PVector.sub(pointB , pointA);
    AtoB.normalize();
    float distance = PVector.dot(PVector.sub(location , pointA) , AtoB);
    PVector normalPoint = PVector.mult(AtoB , distance + 20).add(pointA);
    
    return normalPoint;
  }
  void pathFollowing(){
    PVector target = new PVector();
    float minDist = 1000000;
    
    for(int i = 0; i < path.points.size() - 1; i++){
     PVector pointA = path.points.get(i);
     PVector pointB = path.points.get(i + 1);
     PVector normalPoint = getNormalPoint(location , pointA , pointB);
      
     if(normalPoint.x < min(pointA.x , pointB.x) || normalPoint.x > max(pointA.x , pointB.x)){
      normalPoint = pointB.get();
     }
     strokeWeight(8);
     stroke(0 , 0 , 255);
     point(normalPoint.x , normalPoint.y);
     float distance = PVector.dist(normalPoint , location);
     if(distance < minDist){
       minDist = distance;
       target = normalPoint;
     }
    }
    //PVector a = new PVector(100 , height/2);
    //PVector b = new PVector(width -100 , height/2);
    //stroke(0 , 255 , 0);
    //line(a.x , a.y , b.x , b.y);
    //target = getNormalPoint(location , a , b);
    fill(0 , 255 , 0 , 64);
    noStroke();
    ellipse(target.x , target.y , path.radius * 2 , path.radius * 2);
    strokeWeight(10);
    stroke(255 , 0 , 0);
    point(target.x , target.y);
    if(PVector.dist(target , location) > path.radius){
      seek(target , 1);
    }
    update();
    display();
  }
  void separate(ArrayList<Vehicle> vehicle_arr , final float m){
    PVector VecSum = new PVector(0 , 0);
    for(Vehicle v : vehicle_arr){
      if(v == this) continue;
      PVector VtoThis = PVector.sub(this.location , v.location);
      float distance;
      if((distance = VtoThis.mag()) > 100) continue;
      VecSum.add(VtoThis.normalize().div(distance));
    }
    if(VecSum.x == 0 && VecSum.y == 0) return;
    applyForce(PVector.mult(PVector.sub(VecSum.normalize().mult(maxspeed) , velocity).limit(maxforce) , m));
  }
  PVector addVector(float distance , ArrayList<Vehicle> vehicle_arr , final String mode){
    float velocityAngle = velocity.heading();
    float angleWidth = PI / 4;
    PVector addVec = new PVector(0 , 0);
    int count = 0;
    for(Vehicle v : vehicle_arr){
      if(v == this) continue;
      PVector ThisToV = PVector.sub(v.location , location);
      if(ThisToV.mag() > distance) continue;
      if(mode != "location"){
        if(ThisToV.heading() > velocityAngle + angleWidth || 
        ThisToV.heading() < velocityAngle - angleWidth) continue;
      }
      
      switch(mode){
        case "velocity" :
          addVec.add(v.velocity);
          break;
        case "location" :
          addVec.add(v.location);
          break;
      }
      count++;
    }
    switch(mode){
      case "location" :
        if(count != 0){
          addVec.div(count);
          addVec = PVector.sub(addVec , location);
        }
        println(count);
        break;
    }
    return addVec;
  }
  PVector seekForce(PVector sumVector){
    if(sumVector.x == 0 && sumVector.y == 0) return new PVector(0 , 0);
    sumVector.normalize();
    sumVector.mult(maxspeed);
    PVector force = (PVector.sub(sumVector , velocity)).limit(maxforce);
    return force;
  }
  PVector addVectorAndSeekForce(float distance , ArrayList<Vehicle> vehicle_arr , final String mode){
    return seekForce(addVector(distance , vehicle_arr , mode));
  }
  void alignment(ArrayList<Vehicle> vehicle_arr , final float m){
    PVector force = addVectorAndSeekForce(150 , vehicle_arr , "velocity");
    if(force.x == 0 && force.y == 0) return;
    applyForce(PVector.mult(force , m));
    
  }
  void cohesion(ArrayList<Vehicle> vehicle_arr , final float m){
    PVector force = addVectorAndSeekForce(150 , vehicle_arr , "location");
    if(force.x == 0 && force.y == 0) return;
    applyForce(PVector.mult(force , m));
  }
  void display(){
    float theta = velocity.heading() + PI / 2;
    
    pushStyle();
    stroke(#77DE9F , 64);
    strokeWeight(3);
    for(int i = 0; i < trajectory.length - 2; i++){
      if(PVector.sub(trajectory[i] , trajectory[i + 1]).mag() > 300) continue;
      line(trajectory[i].x , trajectory[i].y , trajectory[i + 1].x , trajectory[i + 1].y);
    }
    
    fill(#5FE8FF);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x , location.y);
    rotate(theta);
    beginShape();
    vertex(0 , -r * 2);
    vertex(-r , r * 2);
    vertex(r , r * 2);
    endShape();
    popMatrix();
    popStyle();
  }
}

ArrayList<Vehicle> vehicle_arr;
Vehicle vehicle;

void setup(){
  size(854 , 480);
  smooth();
  vehicle_arr = new ArrayList<Vehicle>();
  for(int i = 0; i < 100; i++){
  vehicle_arr.add(new Vehicle(random(width) , random(height)));
  }
  vehicle = new Vehicle(random(0 , width) , random(0 , height));
  path = new Path();
  for(int i = 0; i < 17; i++){
    path.addPoint(new PVector(random(0 , width) , random(0 , height)));
  }
  background(255);
}
void draw(){
  background(255);
  //fill(255, 255 , 255 , 4);
  //rect(0 , 0 , width , height);
  
  for(int i = 0; i < vehicle_arr.size(); i++){
    vehicle_arr.get(i).separate(vehicle_arr , 1.0);
    vehicle_arr.get(i).seek(new PVector(mouseX , mouseY) , 0.8);
    vehicle_arr.get(i).alignment(vehicle_arr , 1);
    vehicle_arr.get(i).cohesion(vehicle_arr , 1.2);
    vehicle_arr.get(i).update();
    vehicle_arr.get(i).display();
  }
  //vehicle.pathFollowing();
  //path.display();
  //vehicle.display();
  
  //PVector center = new PVector(width / 2 , height / 2);
  //ellipse(center.x , center.y , 10 , 10);
  //vehicle.seek(center);
  
  //vehicle.loitering();
  
  //vehicle.update();
  //saveFrame("frame_####.jpg");
}
void test(){
  pushStyle();
  fill(255 , 255 , 0);
  ellipse(width / 2 , height / 2 , 200 , 200);
  popStyle();
}
class Cell{
  PVector direction;
  PVector position;
}
class FlowField{
  int row , col;
  int resolution;
  float noiseOffsetRow , noiseOffsetCol , noiseTime;
  Cell[][] cell;
  
  FlowField(int r){
    resolution = r;
    row = width / resolution;
    col = height / resolution;
    noiseOffsetRow = random(10000);
    noiseOffsetCol = random(10000);
    noiseTime = random(10000);
    // 各インデックスは Cell cell; と同じ。まだ cell = new Cell(); していない_
    cell = new Cell[row][col];
    for(int i = 0; i < col; i++){
      for(int j = 0; j < row; j++){
        cell[j][i] = new Cell();
      }
    }
    
    float posX , posY;
    posY = 0;
    for(int i = 0; i < col; i++){
      posX = 0;
      for(int j = 0; j < row; j++){
        cell[j][i].position = new PVector(posX + (resolution / 2) , posY + (resolution / 2));
        posX += resolution;
      }
      posY += resolution;
    }
    
    update();
  }
  void update(){
    float noiseCol = noiseOffsetCol;
    for(int i = 0; i < col; i++){
      float noiseRow = noiseOffsetRow;
      for(int j = 0; j < row; j++){
        float noise = noise(noiseRow , noiseCol , noiseTime);
        float angle = noise * TWO_PI; //map(noise , 0 , 1 , 0 , TWO_PI);
        cell[j][i].direction = new PVector(cos(angle) , sin(angle)); //PVector.fromAngle(angle);
        noiseRow = noiseOffsetRow + ((j + 1) * 0.1);
      }
      noiseCol = noiseOffsetCol + ((i + 1) * 0.1);
    }
    noiseTime += 0.01;
  }
  PVector getDirection(PVector location){
    PVector location_copy = location.get();
    location_copy.div(resolution);
    int indexX = constrain((int)location_copy.x , 0 , row - 1);
    int indexY = constrain((int)location_copy.y , 0 , col - 1);
    return cell[indexX][indexY].direction.get();
  }
  void display(){
    pushStyle();
    stroke(128);
    strokeWeight(1);
    float posX , posY;
    posX = 0;
    for(int j = 0; j < row + 1; j++){
      line(posX , 0 , posX , col * resolution);
      posX += resolution;
    }
    posY = 0;
    for(int i = 0; i < col + 1; i++){
      line(0 , posY , row * resolution , posY);
      posY += resolution;
    }
    
    for(int i = 0; i < col; i++){
      for(int j = 0; j < row; j++){
        Cell c = cell[j][i];
        float angle = atan2(c.direction.y , c.direction.x);
        
        stroke(#7060B9);
        pushMatrix();
        translate(c.position.x , c.position.y);
        rotate(angle);
        float base = resolution / 4;
        strokeWeight(2);
        line(-2 * base , 0 , 2 * base , 0);
        line(base , -base , 2 * base , 0);
        line(base , base , 2 * base , 0);
        popMatrix();
      }
    }
    popStyle();
  }
}
class Path{
  ArrayList<PVector> points;
  float radius;
  
  Path(){
    radius = 40;
    points = new ArrayList<PVector>();
  }
  void addPoint(PVector p){
    points.add(p);
  }
  void display(){
    pushStyle();
    stroke(0);
    noFill();
    strokeWeight(2);
    beginShape();
    for(PVector v : points){
      vertex(v.x , v.y);
    }
    endShape();
  }
}