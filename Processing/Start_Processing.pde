import processing.serial.*;

Serial myPort; //creates local serial object from serial library


void setup() {
  
  printArray(Serial.list()); //link processing to serial port (correct one)
  myPort = new Serial(this, Serial.list()[2], 9600); // setup this laptop, choose serial prot, set baud rate
  
  delay(100);
}

int data1 = 0;
int data2 = 0;
int time = 0;

void draw() {
  
    println("start");

    myPort.write(1);        //write 0 to serial to start data collection.
    for(int i = 0; i < 1000; i++) {
      while (myPort.available() < 1);
      println("1");
      //println(myPort.available());
      data1 = myPort.read();    // reads data from serial port, strips data from port.
      while (myPort.available() < 1);
      println("2");
      //println(myPort.available());
      data2 = myPort.read();
      while (myPort.available() < 1);
      println("3");
      //println(myPort.available());
      time = myPort.read();
      println(i);
      delay(10);
    } 
}
