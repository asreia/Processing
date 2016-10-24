Walker walker;

class Walker{
  float x , y;
  float noiseW;
  float noiseSum;
  Walker(){
    x = width / 2;
    y = height / 2;
    noiseW = random(10);
    noiseSum = 0;
  }
  float beginX , beginY;
  boolean ones = true;
  void display(){
    if(ones){ones = false; beginX = x; beginY = y;}
    colorMode(HSB);
    stroke(stepX * stepY * 3.6 , 200 , 200);
    colorMode(RGB);
    strokeWeight(2);
    line(beginX , beginY , x , y);
    beginX = x; beginY = y;
  }
  float montecarlo(){
    while(true){
      float r1 = random(1);
      float probability = pow(r1 , 2);
      float r2 = random(1);
      if(r2 > probability) return r1;
    }
  }
  float stepX , stepY;
  void step(){
    stepX = montecarlo() * 10;
    stepY = montecarlo() * 10;
    if(random(1) < 0.2){
      float dx = mouseX - x;
      float dy = mouseY - y;
      float angle = atan2(dy , dx);
      stroke(255 , 0 , 0);
      strokeWeight(1);
      //line(x , y , x + (cos(angle) * 100) , y + (sin(angle) * 100));
      x += cos(angle) * stepX;
      y += sin(angle) * stepY;
      //if(x < mouseX) x++;
      //else if(x > mouseX) x--;
      //if(y < mouseY) y++;
      //else if(y > mouseY) y--;
    }else{
      x += random(-stepX , stepX);
      y += random(-stepY , stepY);
    }
  }
}
void setup(){
  size(854 , 480);
  smooth();
  background(255);
  walker = new Walker();
}

void draw(){
  //background(#FFFFFF, 8);
  //noStroke();
  //fill(#FFFFFF, 2);
  //rect(0 , 0 , width , height);
  walker.display();
  walker.step();
}