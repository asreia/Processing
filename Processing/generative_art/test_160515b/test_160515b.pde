  class Test0{
    String fuga = "abc";
    void fff(){println(fuga);}
    class Test{
      int n;
      int fuga = 555;
      Test(){n = 100;}
      int getN(){return n;}
      void setN(int m){n = m;}
    }
    void hoge(){
      class Test2{int i = 444;}
      Test2 u = new Test2();
      println(u.i);
      Test t = new Test();
      t.setN(4);
      println(t.getN());
      println(t.fuga);
    }
  }
void setup(){
  size(500,400);
  int[] arr = new int[4];
  for(int i = 0; i < 4; i++) arr[i] = i + 1;
  int n = arr[3];
  Test0 t0 = new Test0();
  t0.hoge();
  t0.fff();
  {println("block");}
  int a = 0 , b = 3; 
  float ans = 0;
  println(a / b);
  println((float)a / b);
  a = 2;
  ans = a / b;
  println(ans);
  ans = a / (float)b;
  println(ans);
  float a1 = 255 , total = 0;
  for(int i = 0; i < 8; i++) total += a1;
  total /= 8;
  println(total==255);
  int t;
  println(t = (t = (int)random(2 , 5)) >= 5 ? 4 : t);
  println(t);
  int[] number = new int[3];
  for(int i = 0; i < 1000; i++){
      t = (t = (int)random(2 , 5)) >= 5 ? 4 : t;
      for(int j = 0; j < number.length; j++) if(t == j + 2) number[j]++;
  }
  int sum = 0;
  for(int i = 0; i < number.length; i++){
    println(i + 2 +" : "+ number[i]);
    sum += number[i];
  }
  println("sum : " + sum);
  println((int)pow(2 , 1));
  println((int)#FFCC00);
  println(343.2 % 37);
  println(343.2 % (37 * 2));
  int[] arr1 = {};
  println("arr1" + arr1);
}
float h = 0;
void draw(){
  //background(#EF2EF0 , 100);
  fill(#30D139 , 10);
  rect(0 , 0 , width , height);
  fill(0);
  ellipse(width / 2 , h++ , width / 8 , width / 8);
}