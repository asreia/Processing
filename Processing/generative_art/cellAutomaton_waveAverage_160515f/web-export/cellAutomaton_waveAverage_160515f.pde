float cellSize;
int cellCount = 0;
float probability = 2;
AverageFrameRate afr;
class Cell{
  float n;
  float cellState; 
  float next_cellState;
  float last_cellState = 0;
  int interval;
  Cell[] cellArray;
  int[][] array = null;
  int cellNumber;
  int cx , cy;
  int cellHeight;
  //static int cellCount = 0;
  
  Cell(int itv , Cell[] ca , int ch){
   interval = itv;
   cellArray = ca;
   cellNumber = cellCount;
   set_cellState(this);
   //cellState = next_cellState = (cellNumber / (float)cellLength) * 255;
   println(cellNumber);
   cellHeight = ch;
   cellCount++;
  }
  void makeArray(){
    if(array != null) return;
    int cnt = 0;
    array = new int[cellHeight][interval];
    for(int i = 0; i < cellHeight; i++){
      for(int j = 0; j < interval; j++){
        array[i][j] = cnt;
        if(cnt == cellNumber){
          cy = i;
          cx = j;
        }
        cnt++;
      }
    }
  }
  int cyc(int ncy){
    if(ncy < 0) ncy = cellHeight - 1;
    else if(ncy > cellHeight - 1) ncy = 0;
    return ncy;
  }
  int cxc(int ncx){
    if(ncx < 0) ncx = interval - 1;
    else if(ncx > interval - 1) ncx = 0;
    return ncx;
  }
  Cell cellSurrounding(int num){
   makeArray();
   switch(num){
    case 1:
      return cellArray[array[cyc(cy - 1)][cxc(cx - 1)]];
    case 2:
      return cellArray[array[cyc(cy - 1)][cxc(cx)]];
    case 3:
      return cellArray[array[cyc(cy - 1)][cxc(cx + 1)]];
    case 4:
      return cellArray[array[cyc(cy)][cxc(cx - 1)]];
    case 5:
      return cellArray[array[cyc(cy)][cxc(cx + 1)]];
    case 6:
      return cellArray[array[cyc(cy + 1)][cxc(cx - 1)]];
    case 7:
      return cellArray[array[cyc(cy + 1)][cxc(cx)]];
    case 8:
      return cellArray[array[cyc(cy + 1)][cxc(cx + 1)]];
    default:
    return null;
   }
  }
  void calcNextState(){
    float total = 0;
    for(int i = 1; i <= 8; i++) total += cellSurrounding(i).cellState;
    total = total / 8;
    //total = (int)total;
    if(total == 255) next_cellState = 0;
    else {if(total < 1)next_cellState = 255;
    else {
      next_cellState = (cellState - last_cellState) + (int)total;
      //if(last_cellState > 0) next_cellState -= last_cellState;
      if(next_cellState > 255) next_cellState = 255;
      else if(next_cellState < 0) next_cellState = 0;}}
    last_cellState = cellState;
    //float total = 0;
    //for(int i = 1; i <= 8; i++) total += cellSurrounding(i).cellState;
    //float average = (int)total / 8;
    //if(average >= 255) {next_cellState = 0;}
    //else if(average <= 0) {next_cellState = 255;}
    //else {
    //  next_cellState = cellState + average;
    //  if(last_cellState > 0) {next_cellState -= last_cellState;}
    //  if(next_cellState > 255) {next_cellState = 255;}
    //  else if(next_cellState < 0) {next_cellState = 0;}}
    //last_cellState = cellState;
}
}
void flagCopy(Cell[] cellArray){
  for(int i = 0; i < cellCount - 1; i++) cellArray[i].cellState = cellArray[i].next_cellState;
}
void drawMatrix(Cell[] cellArray , int interval , int cellHeight , float cellSize){
  flagCopy(cellArray);
  
  int index = 0;
  float pointX , pointY;
  
  for(int i = 0; i < cellHeight; i++){
    for(int j = 0; j < interval; j++){
      pointX = (j * cellSize) + (cellSize / 2);
      pointY = (i * cellSize) + (cellSize / 2);
      
      fill(cellArray[index].cellState);
      
      ellipse(pointX , pointY , cellSize , cellSize);
      index++;
    }
  }
}
void set_cellState(Cell cell){
  cell.cellState = cell.next_cellState = 
  ((float)cell.cellNumber / cellLength) * 28;
}
void mousePressed(){
  for(int i = 0; i < cellLength; i++){
    set_cellState(cellArray[i]);
      //cellArray[i].cellState = cellArray[i].next_cellState = 
      //((float)cellArray[i].cellNumber / cellLength) * 200;
  }
}

int interval;
int cellHeight;
int cellLength;
Cell[] cellArray;

void setup(){
  size(854 , 480);
  //fullScreen();
  frameRate(60);
  background(255);
  smooth();
  
  afr = new AverageFrameRate();
  
  cellSize = 10;
  interval = (int)(width / cellSize);
  cellHeight = (int)(height / cellSize);
  cellLength = (interval * cellHeight);
  cellArray = new Cell[cellLength];
  for(int i = 0; i < cellLength; i++) cellArray[i] = new Cell(interval , cellArray , cellHeight);
  println("done is cell create");
  //println(cellArray[1998].cellSurrounding(5).flag);
  //drawMatrix(cellArray , interval , cellHeight , cellSize);
  //println("1 -> 9" + cellArray[0].cellSurrounding(1).flag);
  //println("3 -> 7" + cellArray[2].cellSurrounding(3).flag);
  //println("7 -> 3" + cellArray[6].cellSurrounding(6).flag);
  //println("9 -> 1" + cellArray[8].cellSurrounding(8).flag);
  //println("4 -> 5" + cellArray[3].cellSurrounding(5).flag);
  //println("2 -> 8" + cellArray[1].cellSurrounding(2).flag);
  //println("2 -> 8 -> 7" + cellArray[1].cellSurrounding(2).cellSurrounding(4).flag);
}

void draw(){
 background(255);
 drawMatrix(cellArray , interval , cellHeight , cellSize);
 if(frameCount % 6 == 0)for(int i = 0; i < cellLength; i++) cellArray[i].calcNextState();
 fill(255,255,0);
 textSize(28);
 //text("frameRate : " + afr.averageFrameRateFunction() , 0 ,28);
 int recFrameCnt = 1200;
  fill(0);
  textSize(14);
  println("frameCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : recFrameCnt - (frameCount - 1)) , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("processing-####.jpg");
 }
  
  class AverageFrameRate{
  float averageFrameRate = 0;
  float sumFrame = 0;
  
  float averageFrameRateFunction(){
    sumFrame += frameRate;
    
    if(frameCount % 30 == 0){
      averageFrameRate = ((float)((int)((sumFrame / 30) * 10))) / 10;
      sumFrame = 0;
    }
    return averageFrameRate;
  }
}