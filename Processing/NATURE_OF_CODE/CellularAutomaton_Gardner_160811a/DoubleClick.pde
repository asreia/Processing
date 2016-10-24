class DoubleClick{
  int clickTimeCounter;
  boolean doubleClick;
  int prevMouseButton;
  int copyMouseButton;
  
  DoubleClick(){
    clickTimeCounter = 0;
    doubleClick = false;
    prevMouseButton = mouseButton;
  }
  void clickMonitoring(){
    copyMouseButton = mouseButton;
    if(!mousePressed) copyMouseButton = 0;
    doubleClick = false;
    if(copyMouseButton == LEFT && prevMouseButton != copyMouseButton){
      if(clickTimeCounter > 0){
        if(clickTimeCounter < frameRate * 0.3){
          doubleClick = true;
        }
      }
      else if(clickTimeCounter == 0){
        clickTimeCounter++;
      }
    }
    if(clickTimeCounter > 0) clickTimeCounter++;
    if(clickTimeCounter > frameRate * 0.3){
      clickTimeCounter = 0;
    }
    prevMouseButton = copyMouseButton;
  }
}