/*

Copyright (c) 2012, 2013 RedBearLab

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

//"services.h/spi.h/boards.h" is needed in every new project
#include <SPI.h>
#include <boards.h>
#include <ble_mini.h>
#include <services.h>
#include <Servo.h> 
 
#define DIGITAL_OUT_PIN    4
#define DIGITAL_IN_PIN     5
#define PWM_PIN            6
#define SERVO_PIN          7
#define ANALOG_IN_PIN      A5

Servo myservo;

static boolean start_transmitting = false;
static long sample_rate = 1000;
static long device = 12;

void setup()
{
  // Default pins set to 9 and 8 for REQN and RDYN
  // Set your REQN and RDYN here before ble_begin() if you need
  //ble_set_pins(3, 2);
  
  // Init. and start BLE library.
  BLEMini_begin(57600);

  // Enable serial debug
  Serial.begin(57600);
  
  pinMode(DIGITAL_OUT_PIN, OUTPUT);
  pinMode(DIGITAL_IN_PIN, INPUT);
  
  // Default to internally pull high, change it if you need
  digitalWrite(DIGITAL_IN_PIN, HIGH);
  //digitalWrite(DIGITAL_IN_PIN, LOW);
  
  myservo.attach(SERVO_PIN);
}

void loop()
{ 

  if(BLEMini_available()) { // jtan: does this need to be ==3?
    byte data0 = BLEMini_read();
    byte data1 = BLEMini_read();
    byte data2 = BLEMini_read();
    
    if (data0 == 0x01) {
      Serial.write("Start transmission\n");
      start_transmitting = true;
      BLEMini_write(0x01);
      BLEMini_write(1);
      BLEMini_write(0x00);
    }
    if (data0 == 0x02) {
      Serial.write("Stop transmission\n");
      start_transmitting = false;
      BLEMini_write(0x02);
      BLEMini_write(1);
      BLEMini_write(0x00);
    }
    if (data0 == 0x04) {
      Serial.write("Set sampling rate\n");
      if (data1 == 0x10) {
        sample_rate = 500;
      } else {
        sample_rate = int(data1) * 1000;
      }
      
      Serial.write("Set Success!\n");
      BLEMini_write(0x04);
      BLEMini_write(1);
      BLEMini_write(0x00);
    }
    if (data0 == 0x05) {
      Serial.write("Reporting Sensors\n");
      BLEMini_write(0x05);
      BLEMini_write(device);
      BLEMini_write(1);
      BLEMini_write(0x00);
    }
    
  }
  
  if (start_transmitting) {
    Serial.write("Transmit...\n");
    
//    long sensorID1 = 1;
//    long r1 = random(30);
//    
//    long sensorID2 = 2;
//    long r2 = random(30);
//    
//    long sensorID3 = 3;
//    long r3 = random(30);
//    
//    long sensorID4 = 4;
//    long r4 = random(30);
//    
//    long sensorID5 = 5;
//    long r5 = random(30);
    
    
    BLEMini_write(0x06); //This identifies how to handle this package
    BLEMini_write(device);

    uint16_t value = temp_calib(analogRead(ANALOG_IN_PIN))*10; 
    BLEMini_write(value >> 8); // jtan: Which of these is actually needed?
    BLEMini_write(value); // Sizing issue? jtan: not sure we actually need this one here...
    
//    ble_write(sensorID1);
//    ble_write(r1);
//    
//    ble_write(sensorID2);
//    ble_write(r2);
//    
//    ble_write(sensorID3);
//    ble_write(r3);
//    
//    ble_write(sensorID4);
//    ble_write(r4);
//    
//    ble_write(sensorID5);
//    ble_write(r5);
//    
    BLEMini_write(0x00);
    
    delay(sample_rate);

  }
  

//  ble_do_events();  
 
}


float temp_calib(float temp_raw){
  //float VCC = analogRead(power_read);
  //Serial.println(VCC);  
  float temp_f = (temp_raw*0.1743)-10.027+constant;
  return temp_f;
}
