import java.util.Random;

float[] sumRandom_arr;
int arrayRange;
Random generator;

void setup(){
  size(854 , 480);
  smooth();
  arrayRange = 20;
  sumRandom_arr = new float[arrayRange];
  for(int i = 0; i < arrayRange; i++) sumRandom_arr[i] = 0;
  generator = new Random();
}

void draw(){
  if(frameCount % 6 == 0){
      background(255);
      double t;
      println(t = generator.nextGaussian());
      sumRandom_arr[(int)(((t + 3) / 6) * arrayRange)] += 4;
      float sumAve = 0;
      stroke(0);
      fill(0 , 255 , 255);
      for(int i = 0; i < arrayRange; i++){
        rect(i * ((float)width / arrayRange) , height - (sumRandom_arr[i]) , ((float)width / arrayRange) , sumRandom_arr[i]);
        sumAve += sumRandom_arr[i];
      }
      sumAve /= arrayRange;
      stroke(0 , 255 , 0);
      line(0 , height - sumAve , width , height - sumAve);
  }
}
  