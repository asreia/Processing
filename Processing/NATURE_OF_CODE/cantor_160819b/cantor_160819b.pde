int count = 1;
void cantor_(float x0 , float x1 , float y){
  if(x1 - x0 < 1){
    println(x1 - x0 , count++);
    return;
  }
  float x2 = ((x1 - x0) / 3.0) + x0;
  float x3 = ((x1 - x0) * (2.0 / 3.0)) + x0;
  float y1 = ((height - y) / 10.0) + y;
  
  pushStyle();
  stroke(0);
  strokeWeight(1);
  fill(0);
  rect(x0 , y , x2 - x0 , 5);
  rect(x3 , y , x1 - x3 , 5);
  popStyle();
  
  cantor_(x0 , x2 , y1);
  cantor_(x3 , x1 , y1);
}

void cantor(float x , float y , float len){
  if(len < 1) return;
  
  line(x , y , x + len , y);
  
  y += (height - y) / 10;
  len /= 3;
  
  cantor(x , y , len);
  cantor(x + (len * 2) , y , len);
}
int cnt = 0;
void sinCosWave(int n , float x , float y , float r){
  if(n <= 0) return;
  cnt++;
  n--;
  float angle = 0;
  stroke(random(255) , random(255) , random(255));
  float prevY = y;
  float prevX = x;
  for(int i = 1; i <= r; i++){
  line(prevX , prevY , prevX = (x - (i * 2)) , prevY = ((sin(angle += (PI/r)) * r) + y));
  if(i == r) sinCosWave(n , prevX , prevY , r);
  }
  prevY = y;
  prevX = x;
  for(int i = 1; i <= r; i++){
  line(prevX , prevY , prevX = (x + (i * 2)) , prevY = ((sin(angle += (PI/r)) * r) + y));
  if(i == r) sinCosWave(n , prevX , prevY , r);
  }
  prevY = y;
  prevX = x;
  for(int i = 1; i <= r; i++){
  line(prevX , prevY , prevX = ((sin(angle += (PI/r)) * r) + x) , prevY = (y - (i * 2)));
  if(i == r) sinCosWave(n , prevX , prevY , r);
  }
  prevY = y;
  prevX = x;
  for(int i = 1; i <= r; i++){
  line(prevX , prevY , prevX = ((sin(angle += (PI/r)) * r) + x) , prevY = (y + (i * 2)));
  if(i == r) sinCosWave(n , prevX , prevY , r);
  }
  prevY = y;
  prevX = x;
  for(int i = 1; i <= r; i++){
   line(prevX , prevY , prevX = (x - (i * 2)) , prevY = ((cos(angle += (PI/r)) * r) + y));
   if(i == r) sinCosWave(n , prevX , prevY , r);
  }
  prevY = y;
  prevX = x;
  for(int i = 1; i <= r; i++){
   line(prevX , prevY , prevX = (x + (i * 2)) , prevY = ((cos(angle += (PI/r)) * r) + y));
   if(i == r) sinCosWave(n , prevX , prevY , r);
  }
  prevY = y;
  prevX = x;
  for(int i = 1; i <= r; i++){
   line(prevX , prevY , prevX = ((cos(angle += (PI/r)) * r) + x) , prevY = (y - (i * 2)));
   if(i == r) sinCosWave(n , prevX , prevY , r);
  }
  prevY = y;
  prevX = x;
  for(int i = 1; i <= r; i++){
   line(prevX , prevY , prevX = ((cos(angle += (PI/r)) * r) + x) , prevY = (y + (i * 2)));
   if(i == r) sinCosWave(n , prevX , prevY , r);
  }
}

void setup(){
  size(854 , 480);
  //smooth();
  background(255);
  
  //cantor_(0 , width , 0);
  //cantor(0 , 0 , width);
  sinCosWave(6,width / 2 , height / 2 , 20);
  println(cnt);
}