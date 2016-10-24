class Trainer{
  float[] inputs;
  int answer;
  
  Trainer(float x , float y){
    inputs = new float[3];
    inputs[0] = x;
    inputs[1] = y;
    inputs[2] = 1;
    answer = f(x , y);
  }
  int f(float x , float y){
    return x * ((float)9 / 16) > y? -1 : 1;
  }
}