/*
  ReceiveData
  by Scott Kildall

  Expects a string of comma-delimted Serial data from Arduino:
  ** field is 0 or 1 as a string (switch)
  ** second fied is 0-4095 (potentiometer)
  ** third field is 0-4095 (LDR) —— NOT YET IMPLEMENTED
  
  
    Will change the background to red when the button gets pressed
    Will change speed of ball based on the potentiometer
    
 */
 

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;  



// Data coming in from the data fields
String [] data;
int switchValue = 0;    // index from data fields
int potValue = 1;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 1;

// animated ball
int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems




void setup ( ) {
  size (800,  600);    
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, Serial.list()[serialIndex],  115200); 
  
} 


// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string AND casts it to an integer
    inBuffer = (trim(inBuffer));
    
    data = split(inBuffer, ',');
 
    // do an error check here?
    switchValue = int(data[0]);
    potValue = int(data[1]);
  }
} 

//-- change background to red if we have a button
void draw ( ) {  
  // calling all my functions!
  checkSerial();
  
  drawBackground();
 
  drawCrazyRectangle();
  
  textAppears();
  
} 

// if input value is 1 (from ESP32, indicating a button has been pressed), change the background
void drawBackground() {
  //if you press the switch then the background will switch throgh random colors rapidly
   if( switchValue == 1 ){
    background(random(0, 255), random(0, 255), random(0, 255) );
   }
  else
    background(250, 100, 100); 
}

void textAppears(){
  //when you press the button it jump scares you with a spooky message "BOO"
  if(switchValue == 1){
     String s = "BOO";
     textSize(100);
     fill(255);
     text(s, width/2 - 100, height/2);
  }
}

//-- animate ball left to right, use potValue to change speed
void drawCrazyRectangle() {
  
  if(potValue > 500 && potValue < 2000){
  /*This is some really cool code that I found from an old in-class example I did from 
  a pervious class I had! makes random shapes go in random places with some random colors!*/
  float X = random(0, width);
  float Y = random(0, height);
  float colR = random(0);
  float colG = random(0);
  float colB = random(0, 255);
  rect(X, Y, X, Y);
  fill(colR, colG, colB);
  }
 
}
