//Arraylist to hold location of all the cities
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> unChangedPoints = new ArrayList<PVector>();
int startSize = 0;

//Variable to hold information to be sent to csv file
String[] submission;
int submissionIndex = 1;

//method that runs initially on startup
void setup(){
  //Set graphics variables
  background(255);
  stroke(0);
  size(1000, 500);
  
  //Load location of cities and set to arraylist as well as drawing on screen
  String[] citiesRaw = loadStrings("cities.csv");
  for(int i = 1;  i < citiesRaw.length; i++){
    String data[] = citiesRaw[i].split(",");
    point(float(data[1])/5, height-float(data[2])/5);
    PVector tmp = new PVector(float(data[1])/5.0, height-float(data[2])/5.0);
    points.add(tmp);
    unChangedPoints.add(tmp);
  }
  
  //initalize start size and submission array
  startSize = points.size();
  submission = new String[startSize + 2];
  submission[0] = "Path";
}

void draw(){
  
}

//method run when a key is pressed
void keyPressed(){
  //clear the screen
  background(255);
  
  //Set the place where the salesman starts
  PVector northPole = points.get(0);
  submission[submissionIndex] = ("" + unChangedPoints.indexOf(northPole));
  submissionIndex++;
  
  //remove this point because the salesman no longer has to travel there
  //points.remove(northPole);
  PVector start = northPole.copy();
  //Repeat until all points have been traveled to
  while(points.size() > 1){
    
    //Find a random end point to travel to
    int index = (int)random(1, points.size()-1);
      PVector end = points.get(index);
      submission[submissionIndex] = ("" + unChangedPoints.indexOf(end));
      submissionIndex++;
      line(start.x, start.y, end.x, end.y);
      points.remove(end);
      
      //Before finishing this loop, generate a start point to begin with on next loop
      if(points.size() > 0){
       int startIndex = (int)random(1, points.size()-1);
       start = points.get(startIndex);
       submission[submissionIndex] = ("" + unChangedPoints.indexOf(start));
       submissionIndex++;
       points.remove(start);
      }
    //show progress
    println("completed: "  + (startSize-points.size())/float(startSize));
  }
  submission[submissionIndex] = ("" + points.indexOf(northPole));
  saveStrings("output.csv", submission);
}
