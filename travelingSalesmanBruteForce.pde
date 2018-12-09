//Variables to hold universal node values
int nodeNumber = 10;
ArrayList<PVector> cities = new ArrayList<PVector>();

//runs initially on setup
void setup(){
  size(500, 500);
  background(50, 50, 50);
  //saveStrings("bruteForceTime.csv", getData(10));
}

//looping function
void draw(){
  
}

//Method runs to record data on time usage depending on node size
String[] getData(int record){
 String[] output = new String[record];
 cities.clear();
 for(int i = 0; i < record; i++){
  while(cities.size() < i){
   float x = random(width);
   float y = random(height);
   cities.add(new PVector(x, y));
  }
   
   //record the time
   float prevTime = millis();
   bruteForce(cities);
   float timeSpent = (millis() - prevTime);
   output[i] = "" + timeSpent;
 }
 return output;
}

//Run when a key is pressed
void keyPressed(){
  
  //Clear current values
  background(50, 50, 50);
  cities.clear();
  int index = 0;
  while(cities.size() < nodeNumber){
    //Create the random nodes
   float x = random(width);
   float y = random(height);
   cities.add(new PVector(x, y));
   stroke(0);
   ellipse(x, y, 10, 10);
   text(index, x+20, y);
   index++;
  }
  drawLines(bruteForce(cities));
}

//Draw lines between node inputs
void drawLines(ArrayList<PVector> nodes){
 stroke(255, 255, 255);
 for(int i = 0; i < nodes.size()-1; i++){
  line(nodes.get(i).x, nodes.get(i).y, nodes.get(i+1).x, nodes.get(i+1).y); 
 }
}

//Method that will brute force find the shortest path
ArrayList<PVector> bruteForce(ArrayList<PVector> nodes){
  
 //Create variable to hold all paths, and shorest path
 ArrayList<ArrayList> routes = new ArrayList<ArrayList>();
 ArrayList<PVector> shortestRoute = new ArrayList<PVector>();
 
 //Generate the routes
 routes = allRoutesBruteForce(nodes, null, null, factorial(nodes.size()));
 
 //If we found some routes
 if(routes.size() > 0){
   
  //Default shortest distance is the first
  float shortestDistance = getDistance(routes.get(0));
  shortestRoute = clone(routes.get(0));
  
  //Look through all the routes
  for(ArrayList current : routes){
    
   //if we found a shorter distance, save it
   float currentDistance = getDistance(current);
   if(currentDistance < shortestDistance){
    shortestDistance = currentDistance;
    shortestRoute = clone(current);
   }
  }
 }
 return shortestRoute;
}

//Method gets total distance along a route
float getDistance(ArrayList<PVector> route){
 float distance = 0;
 for(int i = 0; i < route.size()-1; i++){
  distance += route.get(i).dist(route.get(i+1)); 
 }
 return distance;
}

//Intermediary method for the brute force method
ArrayList<ArrayList> allRoutesBruteForce(ArrayList<PVector> inCity, ArrayList<PVector> route, ArrayList<ArrayList> routes, int total){
  
  //If this is the first time running recursion, initialize variables
  if(route == null){
   route = new ArrayList<PVector>();
   routes = new ArrayList<ArrayList>();
  }
  
  //If there are nodes to be added to the list
  if(inCity.size() > 0){
   
   //Append a node to the end the first time through loop, and each subsequent time change it
   route.add(inCity.get(0));
   for(int i = 0; i < inCity.size(); i++){
    ArrayList<PVector> tmp = new ArrayList<PVector>();
    for(int z = 0; z < inCity.size(); z++){
     //If the node is not the one selected, add it to a list to be passed through next time
     if(z != i){
       tmp.add(inCity.get(z));
     }
     
     //This node was selected, change the last node on the current route to this node
     else{
      route.set(route.size()-1, inCity.get(z)); 
     }
    }
    //Recurse through again
    allRoutesBruteForce(tmp, clone(route), routes, factorial(cities.size()));
   }
  }
  
  //We completed a route, print how much we have done, and add route to list of routes
  else{
   float percent = (routes.size() / float(total))*100.0;
   routes.add(route);
  }
  return routes;
}

//Method to copy Arraylists, as to treat them independently each layer of recursion
ArrayList<PVector> clone(ArrayList<PVector> inputArray){
 ArrayList<PVector> outputArray = new ArrayList<PVector>();
 for(PVector current : inputArray){
  outputArray.add(current.copy()); 
 }
 return outputArray;
}

//Method for the factorial of an integer
int factorial(int n){
 if(n == 0){
   return 1;
 }
 else{
  return n*factorial(n-1); 
 }
}
