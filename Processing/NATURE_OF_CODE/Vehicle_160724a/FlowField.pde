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