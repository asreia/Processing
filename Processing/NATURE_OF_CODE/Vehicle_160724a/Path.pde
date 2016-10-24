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