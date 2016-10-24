void setup(){
  size(960, 540, P3D);
}

void draw(){
  background(0, 15, 30);
  
  translate(width/2, height/2, 0);
  rotateX(frameCount*0.01);
  rotateY(frameCount*0.01);
  
  // 一つ前の座標を格納する
  float lastX = 0, lastY = 0, lastZ = 0;
  float radius = 200;
  float s = 0, t = 0;
  
  while(s <= 180){
    float radianS = radians(s);
    float radianT = radians(t);
    // 現在の座標を更新
    float x = radius * sin(radianS) * cos(radianT);
    float y = radius * sin(radianS) * sin(radianT);
    float z = radius * cos(radianS);
    
    stroke(0, 128, 128);
    if(lastX != 0){
      strokeWeight(1);
      // 現在の座標から一つ前の座標に線を引く
      line(x, y, z, lastX, lastY, lastZ);
    }
    strokeWeight(15);
    point(x, y, z);
    
    // 一つ前の座標を更新
    lastX = x;
    lastY = y;
    lastZ = z;
    
    // sとtを同時に更新
    s++;
    t+=10;
  }
}