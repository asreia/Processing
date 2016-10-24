//testcode
World world;
//end
void setup(){
  //fullScreen();
  size(854 , 480);
  smooth();
  //testcode
  r = new Random();
  world = new World();
  //end
}
void draw(){
  //testcode
  world.run();
  //end
}