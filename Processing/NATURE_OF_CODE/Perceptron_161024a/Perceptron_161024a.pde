Perceptron ptron;
Trainer[] training = new Trainer[2000];

void setup(){
  size(854 , 480);
  frameRate(60);
  ptron = new Perceptron(3);
  for(int i = 0; i < training.length; i++){
    training[i] = new Trainer(random(width) , random(height));
  }
}
int count = 0;
void draw(){
  background(255);
  
  ptron.train(training[count].inputs , training[count].answer);
  count = (count + 1) % training.length;
  
  pushStyle();
  stroke(0);
  strokeWeight(1);
  for(int i = 0; i < training.length; i++){ 
    if(ptron.feedforward(training[i].inputs) == 1){
      fill(0);
    }
    else{
      noFill();
    }
     ellipse(training[i].inputs[0] , training[i].inputs[1] , 8 , 8);
  }
  popStyle();
}