class Point{
  int x , y;
  Cell cell;
  
  Point(int x_ , int y_){
    x = x_;
    y = y_;
  }
  Point(){
    this(0 , 0);
  }
  
  boolean lessThan(Point p){
    if(y < p.y) return true;
    else if(y == p.y && x <= p.x) return true;
    else return false;
  }
  boolean equal(Point p){
    if(x == p.x && y == p.y){
      return true;
    }
    else{
      return false;
    }
  }
}
class Pattern{
  ArrayList<Point> point;
  color typeColor;
  
  void pointSort(){
    for(int i = 0; i < point.size() - 1; i++){
      for(int j = i + 1; j < point.size(); j++){
        if(!(point.get(i).lessThan(point.get(j)))){
          Point p = point.get(i);
          point.set(i , point.get(j));
          point.set(j , p);
        }
      }
    }
  }
  void pointShift(){
    int xP0 = point.get(0).x;
    int yP0 = point.get(0).y;
    xP0 *= -1;
    yP0 *= -1;
    for(Point p : point){
      p.x += xP0;
      p.y += yP0;
    }
  }
  boolean equal(Pattern pa){
    if(point.size() != pa.point.size()){
      return false;
    }
    boolean bool = true;
    for(int i = 0; i < point.size(); i++){
      if(!(point.get(i).equal(pa.point.get(i)))){
        bool = false;
        break;
      }
      //println("OK" , i + 1 , "/" , point.size());
    }
    return bool;
  }
  void setColor(){
    for(Point p : point){
      p.cell.col = typeColor;
    }
  }
}
class Cell{
  int state;
  int nextState;
  boolean checked , prevChecked , allChecked;
  color col;
  Cell right;
  Cell left;
  Cell up;
  Cell down;
  
  Cell(){
    checked = false;
    col = color(128);
    nextState = state = random(100) < 20? 1 : 0;
  }
  void rule(){
    int lc = liveCount();
    if(state == 1){
      if(lc >= 4 || lc <= 1) nextState = 0;
      else nextState = 1;
    }
    if(state == 0){
      if(lc == 3) nextState = 1;
      else nextState = 0;
    }
  }
  int liveCount(){
    return right.state + left.state + up.state + down.state +
           right.up.state + right.down.state +
           left.up.state + left.down.state;
  }
}

class CellAutomaton{
  final Cell headCell;
  Cell cellPointer;
  float cellWidth;
  int rows;
  int columns;
  ArrayList<Pattern> registerPattern_arr;
  
  CellAutomaton(int cw){
    registerPattern_arr = new ArrayList<Pattern>();
    
    cellWidth = cw;
    headCell = new Cell();
    rows = (int)(width / cellWidth);
    columns = (int)(height / cellWidth);
    
    Cell c0 , c2 , c3 , c5; 
    c0 = c3 = c5 = headCell;
    c2 = null;
    
    for(int i = 0; i < columns; i++){
      Cell c4 = c3;
      if(i >= 1) c3 = c0 = new Cell();
      
      for(int j = 0; j < rows -1; j++){
        if(j == 0) c2 = c0;
        Cell c1 = new Cell();
        //右と左をつなげる_
        c0.right = c1;
        c1.left = c0;
        //上と下をつなげる_
        if(i >= 1){
          c4.down = c0;
          c0.up = c4;
          c4 = c4.right;
          if(j == rows - 2){
            c4.down = c1;
            c1.up = c4;
          }
        }
        //一番上と一番下をつなげる_
        if(i == columns - 1){
          c0.down = c5;
          c5.up = c0;
          c5 = c5.right;
          if(j == rows - 2){
            c1.down = c5;
            c5.up = c1;
          }
        }
        //一番右と一番左をつなげる_
        if(j == rows - 2){
          c1.right = c2;
          c2.left = c1;
        }
        c0 = c1;
      }
    }
  }
  void patternSearch(Cell c , Point point , Pattern pattern){
    if(c.checked ||c.state == 0) return;
    c.checked = true;
    
    Cell[][] cell_arr = new Cell[3][3];
    Cell c1 = c.left.up;
    Point[][] point_arr = new Point[3][3];
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < 3; j++){
        point_arr[i][j] = new Point(point.x + (j - 1) , point.y + (i - 1));
        
        cell_arr[i][j] = c1;
        c1 = c1.right;
        if(i == 1 && j == 1){
           point_arr[i][j].cell = cell_arr[i][j];
           pattern.point.add(point_arr[i][j]);
           continue;
         }
         patternSearch(cell_arr[i][j] , point_arr[i][j] , pattern);   
      }
      c1 = c1.left.left.left;
      c1 = c1.down;
    }
  }
  void patternRecognition(){
    Cell c2 = headCell;
    for(int i = 0; i < columns; i++){
     for(int j = 0; j < rows; j++){
       c2.allChecked = false;
       c2 = c2.right;
     }
     c2 = c2.down;
    }
    
    Cell c = headCell;
    for(int i = 0; i < columns; i++){
      for(int j = 0; j < rows; j++){
        c.allChecked = true;
        Cell c1 = c;
        c = c.right;
        if(c1.checked || c1.state == 0) continue;
        
        Pattern pattern = new Pattern();
        pattern.point = new ArrayList<Point>();
        Point point = new Point(j , i);
        
        patternSearch(c1 , point , pattern);
        
        pattern.pointSort();
        pattern.pointShift();
        boolean found = false;
        for(Pattern pa : registerPattern_arr){
          if(pattern.equal(pa)){
            found = true;
            //println(found);
            pattern.typeColor = pa.typeColor;
            break;
          }
        }
        if(!found){
          pattern.typeColor = color((int)random(255) , (int)random(255) , (int)random(255));
          registerPattern_arr.add(pattern);
          //println(registerPattern_arr.size());
        }
        pattern.setColor();
      }
      c = c.down;
    }
    
    //アンチェック_
    c = headCell;
    for(int i = 0; i < columns; i++){
      for(int j = 0; j < rows; j++){
        c.prevChecked = c.checked;
        c.checked = false;
        c = c.right;
      }
      c = c.down;
    }
  }
  void generation(){
    cellPointer = headCell;
    int x = (int)(mouseX / cellWidth);
    int y = (int)(mouseY / cellWidth);
    
    for(int i = 0; i < x; i++) cellPointer = cellPointer.right;
    for(int i = 0; i < y; i++) cellPointer = cellPointer.down;
    
    Cell c1 = cellPointer;
    c1 = c1.left.left.up.up;
    Cell c2 = headCell;
    if(doubleClick.doubleClick){
      for(int i = 0; i < columns; i++){
        for(int j = 0; j < rows; j++){
          c2.state = 0;
          c2 = c2.right;
        }
        c2 = c2.down;
      }
    }
    else{
      if(mousePressed && mouseButton == RIGHT){
        for(int i = 0; i < 5; i++){
          for(int j = 0; j < 5; j++){
            c1.state = 0;
            c1 = c1.right;
          }
          c1 = c1.left.left.left.left.left;
          c1 = c1.down;
        }
      }
      if(mousePressed && mouseButton == LEFT){
        for(int i = 0; i < 5; i++){
          for(int j = 0; j < 5; j++){
            c1.state = (int)random(0 , 2);
            c1 = c1.right;
          }
          c1 = c1.left.left.left.left.left;
          c1 = c1.down;
        }
      }
    }
    
    Cell c = headCell;
    for(int i = 0; i < columns; i++){
      for(int j = 0; j < rows; j++){
        c.rule();
        c = c.right;
      }
      c = c.down;
    }
    for(int i = 0; i < columns; i++){
      for(int j = 0; j < rows; j++){
        c.state = c.nextState;
        c = c.right;
      }
      c = c.down;
    }
    patternRecognition();
  }
  void display(){
    Cell c = headCell;
    int memoI = 0;
    int memoJ = 0;
    pushStyle();
    noStroke();
    for(int i = 0; i < columns; i++){
      for(int j = 0; j < rows; j++){
        if(c.state == 1){
          //fill(0);
          fill(c.col);
          rect(cellWidth * j , cellWidth * i , cellWidth , cellWidth);
        }
        else{
          fill(255);
          rect(cellWidth * j , cellWidth * i , cellWidth , cellWidth);
        }
        //testcode
        stroke(255 , 0 , 0);
        strokeWeight(cellWidth * 0.2);
        //if(c.prevChecked) line(cellWidth * j , cellWidth * i , (cellWidth * j) + cellWidth , (cellWidth * i) + cellWidth);
        stroke(0 , 255 , 0);
        //if(c.allChecked) line(cellWidth * j , (cellWidth * i) + cellWidth , (cellWidth * j) + cellWidth , cellWidth * i);
        noStroke();
        if(c == cellPointer){
          memoI = i;
          memoJ = j;
        }
        c = c.right;
      }
      c = c.down;
    }
    noFill();
    stroke(#56287C);
    strokeWeight(cellWidth * 0.3);
    rect(cellWidth * memoJ , cellWidth * memoI , cellWidth , cellWidth);
    noStroke();
    popStyle();
    
    pushStyle();
    textSize(32);
    fill(0);
    text("Patterns : " +  registerPattern_arr.size()  , 0 , 32);
    text("frameRate : " + (int)frameRate , 0 , 64);
    popStyle();
  }
}

void mouseWheel(MouseEvent event){
  int i = (int)(event.getAmount() * -1);
  if(i == -1 && fr >= 2) fr += i;
  if(i == 1  && fr <= 59) fr += i;
}

CellAutomaton cellAutomaton;
DoubleClick doubleClick;
int fr = 4;
void setup(){
  size(854 , 480);
  //fullScreen();
  frameRate(fr);
  smooth();
  
  cellAutomaton = new CellAutomaton(10);
  
  doubleClick = new DoubleClick();
}

void draw(){
  
  frameRate(fr);
  background(255);
  
  cellAutomaton.generation();
  cellAutomaton.display();
  
  doubleClick.clickMonitoring();
}