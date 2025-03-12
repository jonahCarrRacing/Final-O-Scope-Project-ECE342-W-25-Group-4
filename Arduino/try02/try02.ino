void setup() {
  Serial.begin(9600);
  while(Serial.available() == 0) {}
}

uint8_t data[1000];
uint8_t data2[1000];
bool goUp = true;
bool goDown = false;
bool ready = false;
int cord = random(10, 100);
unsigned long timeElapsed = 250;

void loop() {
  for(int i = 1; i < 1000; i++) {
    if(goUp && cord < 200) {
      data[i] = cord;
      cord++;
    } else if(goUp) {
      goUp = false;
      goDown = true;
    } else if(goDown && cord > 0) {
      data[i] = cord;
      cord = cord - 1;
    } else if(goDown) {
      goDown = false;
      goUp = true;
    } else {}
  }

  cord = random(0, 255);
  for(int i = 1; i < 1000; i++) {
    if(goUp && cord < 255) {
      data2[i] = cord;
      cord++;
    } else if(goUp) {
      goUp = false;
      goDown = true;
    } else if(goDown && cord > 0) {
      data2[i] = cord;
      cord = cord - 1;
    } else if(goDown) {
      goDown = false;
      goUp = true;
    } else {}
  }

  // while(Serial.available() == 0) {}
  // Serial.read();
  // for(int i = 0; i < 1000; i++) {
  //     Serial.print("Line");
  //     Serial.print(i);
  //     Serial.print(":  ");
  //     Serial.println(data[i]);
  // }

  while(Serial.available() == 0) {}
  Serial.read();
  for(int i = 0; i < 1000; i++) {
    Serial.write(data[i]);
    Serial.write(data2[i]);
    Serial.write(timeElapsed);
  }
}