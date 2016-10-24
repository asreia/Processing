PVector locSub(PVector p0 , PVector p1){
  PVector p2 = PVector.sub(p0 , p1);
  p2.x = abs(p2.x);
  p2.y = abs(p2.y);
  boolean p2x = p2.x < width / 2;
  boolean p2y = p2.y < height / 2;
  if(p2x  && p2y){
    return PVector.sub(p0 , p1);
  }
  else if(!p2x && p2y){
    float d;
    if((d = p0.x - p1.x) > 0){
      d -= width;
    }
    else{
      d += width;
    }
    return new PVector(d , p0.y - p1.y);
  }
  else if(p2x && !p2y){
    float d;
    if((d = p0.y - p1.y) > 0){
      d -= height;
    }
    else{
      d += height;
    }
    return new PVector(p0.x - p1.x , d);
  }
  else if(!p2x && !p2y){
    float d;
    if((d = p0.x - p1.x) > 0){
      d -= width;
    }
    else{
      d += width;
    }
    float d1;
    if((d1 = p0.y - p1.y) > 0){
      d1 -= height;
    }
    else{
      d1 += height;
    }
    return new PVector(d , d1);
  }
  return null;
}
float locDist(PVector p0 , PVector p1){
  return locSub(p0 , p1).mag();
}