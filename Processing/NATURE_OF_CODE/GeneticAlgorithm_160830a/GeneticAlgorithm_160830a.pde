String targetWords;
float mutationRate;
DNA[] population;

class DNA{
  char[] words;
  float fitness;
  DNA(){
    words = new char[targetWords.length()];
    for(int i = 0; i < words.length; i++){
      words[i] = (char)random(32 , 128);
    }
  }
  void fitness(){
    int count = 0;
    for(int i = 0; i < targetWords.length(); i++){
      if(words[i] == targetWords.charAt(i)){
        count++;
      }
    }
    fitness = (float)count / targetWords.length();
  }
  DNA crossover(DNA partner){
    DNA child = new DNA();
    for(int i = 0; i < words.length; i++){
      if(random(1) < 0.5){
        child.words[i] = words[i];
      }
      else{
        child.words[i] = partner.words[i];
      }
    }
    return child;
  }
  void mutate(float mutationRate){
    for(int i = 0; i < words.length; i++){
      if(random(1) < mutationRate){
        words[i] = (char)random(32 , 128);
      }
    }
  }
  String getPhrase(){
    return new String(words);
  }
}
DNA[] topDNA_arr;
int GenerationNumber;
int firstPerfectGenerationNumber;
void setup(){
  size(854 , 480);
  smooth();
  frameRate(60);
  background(255);
  
  targetWords = "Port of Nagoya Public Aquarium";
  //targetWords = "to be or not to be";
  
  mutationRate = 0.01;
  population = new DNA[1000];
  for(int i = 0; i < population.length; i++){
    population[i] = new DNA();
  }
  
  topDNA_arr = new DNA[(int)(height / 20.0)];
  for(int i = 0; i < topDNA_arr.length; i++){
    topDNA_arr[i] = null;
  }
  GenerationNumber = 0;
  firstPerfectGenerationNumber = -1;
}
void draw(){
  background(255);
  
  GenerationNumber++;
  
  float SumFitness = 0;
  float maxFitness = 0;
  DNA topDNA = null;
  for(int i = 0; i < population.length; i++){
    population[i].fitness();
    SumFitness += population[i].fitness;
    if(maxFitness < population[i].fitness){
      maxFitness = population[i].fitness;
      topDNA = population[i];
    }
  }
  
  DNA tempDNA = topDNA_arr[0];
  topDNA_arr[0] = topDNA;
  for(int i = 1; i < topDNA_arr.length; i++){
    DNA tempDNA1 = topDNA_arr[i];
    topDNA_arr[i] = tempDNA;
    tempDNA = tempDNA1;
  }
  pushStyle();
  fill(0);
  textSize(20);
  for(int i = 0; i < topDNA_arr.length;i++){
    if(topDNA_arr[i] != null){
      text(topDNA_arr[i].getPhrase() , 0 , (i + 1) * 20.0);
      text(topDNA_arr[i].fitness , targetWords.length() * 14.0 , (i + 1) * 20.0);
    }
  }
  textSize(40);
  text(GenerationNumber , width - 150 , 40);
  if(topDNA.fitness == 1 && firstPerfectGenerationNumber == -1){
    firstPerfectGenerationNumber = GenerationNumber;
  }
  if(firstPerfectGenerationNumber != -1){
    fill(0 , 0 , 255);
    text(firstPerfectGenerationNumber , width - 250 , 40);
  }
  popStyle();
  
  DNA[] nextPopulation = new DNA[population.length];
  for(int j = 0; j < population.length; j++){
    float randomA = random(SumFitness);
    float randomB = random(SumFitness);
    DNA partnerA = null;
    DNA partnerB = null;
    float SumFitness1 = 0;
    for(int i = 0; i < population.length; i++){
      SumFitness1 += population[i].fitness;
      if(partnerA == null && randomA <= SumFitness1){
        partnerA = population[i];
      }
      if(partnerB == null && randomB <= SumFitness1){
        partnerB = population[i];
      }
      if(partnerA != null && partnerB != null){
        break;
      }
    }
    nextPopulation[j] = partnerA.crossover(partnerB);
    
    nextPopulation[j].mutate(mutationRate);
  }
  population = nextPopulation;
  
}