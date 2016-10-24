import controlP5.*;
ControlP5 cp5;
int _Levels = 0;
Branch branch;
float root_noiseAngle;

void Level_up(){
  _Levels++;
}
void Level_down(){
  _Levels = _Levels >= 1 ? --_Levels : 0;
}

void setup(){
  size(854 , 480);
  //fullScreen();
  frameRate(60);
  background(255);
  noFill();
  smooth();
  colorMode(HSB);
  root_noiseAngle = random(10);
  newTree();
  cp5 = new ControlP5(this);
  cp5.addButton("Level_up")
   .setPosition(width * 0.85,height * 0.04)
   .setSize(75,25)
   ;
  cp5 = new ControlP5(this);
  cp5.addButton("Level_down")
   .setValue(_Levels - 1)
   .setPosition(width * 0.85,height * 0.12)
   .setSize(75,25)
   ;
}

void draw(){
  background(255);
  root_noiseAngle += 0.005;
  branch.updateMe(width / 2 , height * 0.95 , ((noise(root_noiseAngle) * 0.04) + 0.98) * (PI * ((float)3 / 2)));
  branch.drawMe();
  int recFrameCnt = 2400;
  fill(0);
  textSize(14);
  //text("timeCountDown : " + (recFrameCnt - (frameCount - 1) <= 0 ? 0 : (float)((int)((recFrameCnt - (frameCount - 1)))/6))/10 , 0 , 14);
  //if(frameCount <= recFrameCnt)saveFrame("processing-####.jpg");
  textSize(28);
  fill(#37E3A5);
  text("Level : " + _Levels , 0 , 42);
  _Levels = (int)(mouseX / (width / 7)); //OpenProcessing you ni tuika.
}


void mouseReleased(){
  newTree();
}

void newTree(){
  float t0 = 1;
  for(int i = 0; i <= _Levels; i++) t0 *= pow(((float) 10 / 9) , i);
  t0 = pow(t0 ,(float)1 /(_Levels + 1));
  float t1 = (((float)height / (_Levels + 1)) * t0);
  float t2 = 0;
  for(int i = 0; i <= _Levels; i++) t2 += t1 * pow(((float)9 / 10) , i);
  branch = new Branch(_Levels , (((float)(height * 0.9) / (_Levels + 1)) * t0) , 
    ((noise(root_noiseAngle) * 0.04) + 0.98) * (PI * ((float)3 / 2)) , width / 2 , height * 0.95 , width * 0.03125);
  branch.drawMe();
}

class Branch{
  int level;
  float beginX , beginY , endX , endY;
  float angle;
  float radius;
  float weight;
  Branch[] branch = null;
  float noiseAngle;
  float[] colorNoise;
  float cpNoise;
  float leafs_noise;
  float[] angle_arr;
  
  Branch(int lv , float rds , float age , float bX , float  bY , float we){
    level = lv;
    radius = rds;
    weight = (we * 3) / 4;
    updateMe(bX , bY , age);
    noiseAngle = random(10);
    colorNoise = new float[3];
    for(int i = 0; i < colorNoise.length; i++) colorNoise[i] = random(255);
    cpNoise = random(10);
    leafs_noise = random(10);
    
    if(level > 0){
      int arrays;
      arrays = (arrays = (int)random(1 , 7)) >= 7 ? 6 : arrays;
      branch = new Branch[arrays];
      angle_arr = new float[branch.length];
      set_angle_arr();
      for(int i = 0; i < branch.length; i++){
        branch[i] = new Branch(level - 1 , radius * ((float)9 / 10) , angle_arr[i] , endX , endY , weight);
      }
    }
  }
  void set_angle_arr(){
    if(branch != null){
      noiseAngle += 0.003;
      float sumAngle = 0;
      for(int i = 0; i < branch.length; i++){
        sumAngle += ((noise(noiseAngle) * 0.6 ) + 0.7 ) * (PI / (branch.length + 1));
        angle_arr[i] = sumAngle + (angle - (PI / 2));
      }
      for(int i = 0; i < branch.length; i++) angle_arr[i] += ((float)branch.length / 2) * ((PI / (branch.length + 1)) - (sumAngle / (branch.length)));
    }
  }
  void updateMe(float bX , float bY , float age){
    angle = age;
    beginX = bX;
    beginY = bY;
    endX = beginX + (cos(angle) * radius);
    endY = beginY + (sin(angle) * radius);
    set_angle_arr();
    if(branch != null) for(int i = 0; i < branch.length; i++){
      branch[i].updateMe(endX , endY , angle_arr[i]);
    }
  }
  void drawMe(){
    int[] color_rgb = new int[3];
    float nv = 0.01;
    for(int i = 0; i < colorNoise.length; i++) color_rgb[i] = 
      i == 1 || i == 2 ? (int)((noise(colorNoise[i] += nv) * 127) + 128) : (int)(noise(colorNoise[i] += nv) * 255);
    stroke(color_rgb[0] , color_rgb[1] , color_rgb[2]);
    strokeWeight(weight);
    line(beginX , beginY , endX , endY);
    stroke(#30FC91);
    strokeWeight(weight * ((float)1 / 4));
    fill(#0E5A32);
    ellipse(beginX , beginY , weight * 1.5 , weight * 1.5);
    if(branch == null){
      leafs_noise += 0.0005;
      int leafs = ((int)(noise(leafs_noise) * 8)) + 1;
      for(int j = 0; j < leafs; j++){
        fill(color_rgb[0] , color_rgb[1] , color_rgb[2] , (noise(cpNoise) * 64) + 64);
        noStroke();
        float leafX , leafY;
        cpNoise += 0.002;
        leafX = (beginX + (((endX - beginX) / leafs) * (j + 1))) + cos((noise(cpNoise + j) * 2) * PI) * noise(cpNoise + j) * (width * 0.052);
        leafY = (beginY + (((endY - beginY) / leafs) * (j + 1))) + sin((noise(cpNoise + j) * 2) * PI) * noise(cpNoise + j) * (width * 0.052);
        float r;
        ellipse(leafX , leafY ,width * 0.026 * (r = noise(cpNoise) + 0.5) , width * 0.026 * r);
      }
    }
    if(branch != null) for(int i = 0; i < branch.length; i++){
      branch[i].drawMe();
    }
  }
}