import processing.serial.*;

Serial myPort; //creates local serial object from serial library

int xTick = 100;
int yTick = 240;

void setup() {
  
  printArray(Serial.list()); //link processing to serial port (correct one)
  myPort = new Serial(this, Serial.list()[2], 9600); // setup this laptop, choose serial prot, set baud rate
  
  fullScreen();            // set display to be completely fullscreen
  background(100);            // set background color
  rect(50, 200, 1436, 700);    //box for signal
  
  line(80, 850, 1400, 850);    //horizontal axis
  
  fill(0);                      // 3 lines for horizontal axis label
  textSize(20);
  text("TIME", 1410, 855);
  
  for(int i = 0; i < 10; i++) {    //horizontal axis tick marks
    xTick = xTick + 130;
    line(xTick, 840, xTick, 860);
  }
  
  line(100, 240, 100, 870);    //vertical axis
  
  fill(0);                  // 3 lines for vertical axis label
  textSize(20);
  text("VOLTAGE", 60, 230);
  
  for(int i = 0; i < 10; i++) {    //vertical axis tick marks
    line(90, yTick, 110, yTick);
    yTick = yTick + 61;
  }
}

int[] data = new int[1000];

//voltage axis data
int maxVolt = 200;
int voltLabel = 0;
int inc = 0;

//time axis data
int timeElapsed = 80;
int timeLabel = 0;
int increment = 0;

boolean goUp = true;
boolean goDown = false;
int cord = 0;
float temp = 0;

void draw() {
  
  fill(255);
  noStroke();
  rect(101, 240, 1300, 609);
  rect(80, 860, 1400, 30);
  rect(55, 240, 35, 640);
  stroke(0);
  fill(0);
  int xCord = 101; // max x = 1536
  
  myPort.write(1);
  for(int i = 0; i < 1000; i++) {
    while(myPort.available() == 0) {}
      data[i] = myPort.read();
      println(i);
  }
  
  //temp = random(300, 800);
  //cord = int(temp);
  //for(int i = 1; i < 1000; i++) {
  //  if(goUp && cord < 800) {
  //    data[i] = cord;
  //    cord++;
  //  } else if(goUp) {
  //    goUp = false;
  //    goDown = true;
  //  } else if(goDown && cord > 300) {
  //    data[i] = cord;
  //    cord = cord - 1;
  //  } else if(goDown) {
  //    goDown = false;
  //    goUp = true;
  //  } else {}
  //}
  

  xTick = 100;
  increment = timeElapsed/10;
  timeLabel = 0;
  yTick = 850;
  inc = maxVolt/10;
  voltLabel = 0;
  for(int k = 0; k < 10; k++) {
    
    text(timeLabel, xTick, 880);
    timeLabel = timeLabel + increment;
    xTick = xTick + 130; 
    
    text(voltLabel, 60, yTick);
    voltLabel = voltLabel + inc;
    yTick = yTick - 61;
  }
  
  
  for(int k = 0; k < 1000; k++) {
    point(xCord, data[k] + 400);
    xCord++;
  }
}
