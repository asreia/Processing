class CA{
  int[] cells;
  int[] ruleset;
  int w = 1;
  int generation = 0;
  int cnt = 0;
  CA(){
    cells = new int[width / w];
    int[] ruleset_ = {0 , 1 , 0 , 1 , 1 , 0 , 1 , 0};
    ruleset = ruleset_;
    cells[int(cells.length / 2)] = 1;
  }
  void generate(){
    int[] nextgen = new int[cells.length];
    for(int i = 1; i < cells.length - 1; i++){
      nextgen[i] = rules(cells[i - 1] , cells[i] , cells[i + 1]);
    }
    cells = nextgen;
    generation++;
    if(generation > height / w){
      generation = 0;
      cnt++;
      for(int i = 0; i < cells.length; i++){
        if(cnt % 2 == 0){
        cells[i] = 0;
        if(i == int(cells.length / 2)) cells[i] = 1;
        }
        else{
          cells[i] = (int)random(0 , 2);
        }
      }
      int n = (int)random(0 , 256);
      println(n , cnt % 2 == 0);
      for(int i = 0; i < 8; i++){
        ruleset[i] = (int)(n % 2);
        n /= 2;
      }
    }
  }
  int rules(int a , int b , int c){
    int index = a * (int)pow(2 , 2) + b * (int)pow(2 , 1) + c * (int)pow(2 , 0);
    return ruleset[index];
  }
  void display(){
    noStroke();
    for(int i = 0; i < cells.length; i++){
      if(cells[i] == 0) fill(255);
      else              fill(0);
      rect(i * w , generation * w , w , w);
    }
  }
}
CA ca;
void setup(){
  size(854 , 480);
  //fullScreen();
  smooth();
  ca = new CA();
  background(255);
}
void draw(){
  ca.display();
  ca.generate();
}