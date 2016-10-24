void setup(){
  size(600,450);
  background(255);
  saiki(100);
  //rect(width / 3 , height / 3 , width / 3 , height / 3);
  println(P3D);
  String s = toString();
  println(s);
}

void saiki(int n){
  if(n < 1) return;
  fill(random(255) , random(255) , random(255));
  strokeWeight(2);
  rect(width / n , height / n , width / n , height / n);
  saiki(--n);
}

void draw(){
  
}