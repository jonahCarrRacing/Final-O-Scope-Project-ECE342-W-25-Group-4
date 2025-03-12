import processing.serial.*;

Serial myPort;                 //creates local serial object from serial library

int xTick = 100;
int yTick = 240;

void setup() {
  
  printArray(Serial.list());                                 //link processing to serial port (correct one)
  myPort = new Serial(this, Serial.list()[2], 600000);         // setup this laptop, choose serial prot, set baud rate
  
  fullScreen();                            // set display to be completely fullscreen
  background(100);                            // set background color
  rect(30, 200, 1451, 700);                //box for signal
  
  line(80, 850, 1400, 850);                    //horizontal axis
  
  fill(0);                                  // horizontal axis label "TIME"
  textSize(20);
  text("TIME", 1410, 855);
  
  line(100, 240, 100, 870);              //vertical axis
  
  fill(0);                                // vertical axis label "VOLTAGE"
  textSize(20);
  text("VOLTAGE", 60, 230);
  
  for(int i = 0; i < 10; i++) {            //vertical axis tick marks
    line(90, yTick, 110, yTick);
    yTick = yTick + 61;
  }
  
  text("VoltScale", 195, 180);
  text("TimeScale", 580, 180);
  text("Trigger", 995, 180);
  
  myPort.write(0xff);
}

//1000 array to store data
int[] data = new int[1300];
int[] data2 = new int[1300];

//voltage axis data
float maxVolt = 13.5;
float voltLabel = -3.3;
float inc = 0;

//time axis data
String timeElapsed = "100";
int timeLabel = 0;
int increment = 0;

// hovering over buttons
boolean graphHover = false;
boolean encoderHover = false;

//process which state to be in
boolean graph = true;
boolean readLastGraph = false;
boolean readLastEncoder = false;

// Encoder Values
int encoder1 = 1;
String encoder2 = "0";
int encoder3 = 128;
float trigger = 1.6;


void draw() {
  update();
  if(graphHover) {
    fill(51);
  } else {
    fill(0);
  }
  rect(100, 50, 600, 100);
  
  if(encoderHover) {
    fill(51);
  } else {
    fill(0);
  }
  rect(800, 50, 600, 100);
  
  if(myPort.available() > 0 && graph) {
    
    if(readLastGraph) {
      graph = false;
      readLastGraph = false;
      myPort.write(0x00);
    } else {myPort.write(0xff);}
    
    GraphVoltage();
    
  } else if (myPort.available() > 0) {
    if(readLastEncoder) {
      graph = true;
      readLastEncoder = false;
      myPort.write(0xff);
    } else {myPort.write(0x00);}
    
    Encoder(); 
  } 
}

void update() {
  if(hoverGraph(100, 50, 600, 100)) {
    graphHover = true;
    encoderHover = false;
  } else if(hoverEncoder(800, 50, 600, 100)) {
    encoderHover = true;
    graphHover = false;
  } else {
    graphHover = encoderHover = false;
  }
}

void mousePressed() {
  if(graphHover) {
    readLastGraph = true;
  }
  if(encoderHover) {
    readLastEncoder = true;
  }
}

boolean hoverGraph(int x, int y, int width, int height) {
  if(mouseX >= x && mouseX <= x+width &&
     mouseY >= y && mouseY <= y+height) {
     return true;
   } else {
     return false;
   }
}

boolean hoverEncoder(int x, int y, int width, int height) {
  if(mouseX >= x && mouseX <= x+width &&
     mouseY >= y && mouseY <= y+height) {
     return true;
   } else {
     return false;
   }
}

void GraphVoltage() {                  //function to collect, and print samples to screen
  fill(255);
  noStroke();
  rect(101, 240, 1300, 609);                  // all rect() here cover numbers so
  rect(80, 860, 1400, 30);                    // that they don't write on top of other numbers
  rect(32, 240, 62, 640);                    //cover volt scale
  stroke(0);
  fill(0);
  
  line(200, 418, 800, 418);
  line(200, 672, 800, 672);
  
  for(int i = 0; i < 1300; i++) {                        // collect 1300 samples
    
    while(myPort.available() == 0) {}
    data[i] = myPort.read();
    data[i] = (data[i] - 127) * encoder1;
    
    while(myPort.available() == 0) {}
    data2[i] = myPort.read();
    data2[i] = (data2[i] - 127) * encoder1;
  }
  
  while(myPort.available() == 0) {}
  timeElapsed = myPort.readStringUntil('\n');              //collect timeElasped
  
  text("Time Elapsed: ", 600, 880);
  text(timeElapsed, 750, 880);                           //print out time elapsed (string)
  text("microseconds", 850, 880);
  
  yTick = 850;
  inc = maxVolt / (5 * encoder1);
  voltLabel = -13.5 / encoder1;
  for(int k = 0; k < 10; k++) {                  //LOOP to print out voltage at each tick mark
    text(voltLabel, 33, yTick);
    voltLabel = voltLabel + inc;
    yTick = yTick - 61;
  }
  
  
  int xCord = 101; // max x = 1536
  for(int k = 0; k < 1300; k++) {                    //LOOP to print out points
    
    if(data[k] > 304) {data[k] = 304;}                //check if passing boundaries
    if(data[k] < -304) {data[k] = -304;}
    point(xCord, 545 - data[k]);
    
    if(data2[k] > 304) {data2[k] = 304;}              //check if passing boundaries
    if(data2[k] < -304) {data2[k] = -304;}
    point(xCord, 545 - data2[k]);
    
    xCord++;
  }
}

void Encoder() {
  fill(200, 136, 252);
  rect(280, 160, 100, 30);
  rect(670, 160, 100, 30);
  rect(1060, 160, 100, 30);
  fill(0);

  while(myPort.available() == 0) {}                //read in values from microcontroller
  encoder1 = myPort.read();
  while(myPort.available() == 0) {}
  encoder2 = myPort.readStringUntil('\n');
  while(myPort.available() == 0) {}
  encoder3 = myPort.read();
  
  text(encoder1, 310, 180);
  text(encoder2, 700, 180);
  trigger = encoder3 * 3.3;
  trigger = trigger / 255;
  trigger = trigger - 1.65;
  text(trigger, 1090, 180);
}   
