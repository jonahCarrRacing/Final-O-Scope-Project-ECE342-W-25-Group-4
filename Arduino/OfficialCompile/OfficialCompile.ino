#include <ADC.h>
#include <ADC_util.h>
#define ENCODER_DO_NOT_USE_INTERRUPTS
#include <Encoder.h>

const int pin1 = 25;    //ADC 0
const int pin2 = 39;    //ADC 1

Encoder myEnc1(5, 6);     // makes new encoder object
Encoder myEnc2(7, 8);
Encoder myEnc3(9, 10);

ADC *adc = new ADC();     // makes new ADC object

void setup() {
  pinMode(pin1, INPUT_DISABLE);    //disable pin, will be using object
  pinMode(pin2, INPUT_DISABLE);   //disable pin, will be using object

  //ADC0 gets no average, 8 bit resolution, conversion speed = high, sample speed = high 
  adc->adc0->setAveraging(0);
  adc->adc0->setResolution(8);
  adc->adc0->setConversionSpeed(ADC_CONVERSION_SPEED::HIGH_SPEED);
  adc->adc0->setSamplingSpeed(ADC_SAMPLING_SPEED::VERY_HIGH_SPEED);

  //ADC0 gets no average, 8 bit resolution, conversion speed = high, sample speed = high 
  adc->adc1->setAveraging(0);
  adc->adc1->setResolution(8);
  adc->adc1->setConversionSpeed(ADC_CONVERSION_SPEED::HIGH_SPEED);
  adc->adc1->setSamplingSpeed(ADC_SAMPLING_SPEED::VERY_HIGH_SPEED);
  
  adc->startSynchronizedContinuous(pin1, pin2);

  delay(500);   //delay for setup

  Serial.begin(9600); //set baud rate // doesn't actually matter for teensy

  while(Serial.available() == 0) {};
}

unsigned long timeTemp = 0;
unsigned long timeElapsed = 0;

uint8_t newVoltage = 0;
bool belowTrigger = true;

uint8_t v1[1300];
uint8_t v2[1300];

uint8_t sentNumber = 255;
bool sendArray = true;
bool serialAvailable = false;

long position1 = 1;
long position2 = 0;
long position3 = 128;

void loop() {

  if(sendArray) {
    newVoltage = adc->adc0->analogReadContinuous();
    if(newVoltage >= position3) {
      if(belowTrigger) {
        belowTrigger = false;
        timeTemp = micros();
        for(int i = 0; i < 1300; i++) {
          v1[i] = adc->adc0->analogReadContinuous();
          v2[i] = adc->adc1->analogReadContinuous();
          delayNanoseconds(position2 * 77);
        }
        timeElapsed = micros() - timeTemp;
        serialAvailable = true;
      }
    } else {belowTrigger = true;}
  } else {
    position1 = myEnc1.read();
    if(position1 < 1) {position1 = 1;}
    position2 = myEnc2.read();
    if(position2 < 0) {position2 = 0;}
    position3 = myEnc3.read();
    if(position3 < 0) {position3 = 0;}
    serialAvailable = true;
  }

  if(serialAvailable) {
    while(Serial.available() == 0) {}       // check for data available
      sentNumber = Serial.read();  //strip port
      if(sentNumber > 0) {
        sendArray = true;
        for(int i = 0; i < 1300; i++) {     // send all 1000 samples
          Serial.write(v1[i]);
          Serial.write(v2[i]);
        }
        Serial.println(timeElapsed);    //send TimeElapse
      } else {
        sendArray = false;
        Serial.write(position1);
        Serial.println(position2);
        Serial.write(position3);
      }
    serialAvailable = false;
  }
}