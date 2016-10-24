int _num = 10;

void setup(){
  size(500 , 300);
  background(255);
  smooth();
  strokeWeight(1);
  fill(150 , 50);
  drawCircles();
}

void draw(){
  
}

void mouseReleased(){
  drawCircles();
}

void drawCircles(){
  for(int i = 0; i < _num; i++){
    new Circle().drawMe();
  }
}

class Circle{
  float x , y;
  float radius;
  color lineColor , fillColor;
  float alph;
  
  Circle(){
    x = random(width);
    y = random(height);
    radius = random(100) + 10;
    lineColor = color(random(255) , random(255) , random(255));
    fillColor = color(random(255) , random(255) , random(255));
    alph = random(255);
  }
  void drawMe(){
    noStroke();
    fill(fillColor , alph);
    ellipse(x , y , radius * 2 , radius * 2);
    stroke(lineColor , 150);
    noFill();
    ellipse(x , y , 10 , 10);
  }
}