import processing.serial.*;

Serial myPort; //creates local serial object from serial library


void setup() {
  
  printArray(Serial.list()); //link processing to serial port (correct one)
  myPort = new Serial(this, Serial.list()[2], 9600); // setup this laptop, choose serial prot, set baud rate
  myPort.write(1);
}

int printPlz = 0;

void draw() {
  while(myPort.available() == 0);
  printPlz = myPort.read();
  println(printPlz);
  myPort.write(1);
  delay(10); 
}
