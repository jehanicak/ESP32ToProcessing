int yBallPos;        // calc on startup
int direction = -1;    // 1 or -1

void setup ( ) {
  size (800,  600);    
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, Serial.list()[serialIndex],  115200); 
  
  // settings for drawing the ball
  ellipseMode(CENTER);
  xBallMin = hBallMargin;
  xBallMax = width - hBallMargin;
  xBallPos = width/2;
  yBallPos = height/2;
  
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
  // every loop, look for serial information
  checkSerial();
  
  drawBackground();
  drawBall();
  
} 

// if input value is 1 (from ESP32, indicating a button has been pressed), change the background
void drawBackground() {
   if( switchValue == 1 )
    background(random(255), random(255), random(255));
  else
    background(250, 240, 210); 
}

//-- animate ball left to right, use potValue to change speed
void drawBall() {
    fill(255,0,0);
    ellipse( xBallPos, yBallPos, ballDiameter, ballDiameter );
    float speed = map(potValue, minPotValue, maxPotValue, minBallSpeed, maxBallSpeed);
    
    //-- change speed
    xBallPos = xBallPos + (speed * direction);
    
    //-- make adjustments for boundaries
    adjustBall();
}

//-- check for boundaries of ball and make adjustments for it to "bounce"
void adjustBall() {
  if( xBallPos > xBallMax ) {
    direction = -1;    // go left
    xBallPos = xBallMax;
  }
  else if( xBallPos < xBallMin ) {
    direction = 1;    // go right
    xBallPos = xBallMin;
  }
}
