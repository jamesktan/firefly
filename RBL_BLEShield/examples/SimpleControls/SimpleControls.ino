/*

Copyright (c) 2012, 2013 RedBearLab

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

//"services.h/spi.h/boards.h" is needed in every new project
#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
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
  ble_begin();
  Serial.println(ANALOG_IN_PIN);
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

  if(ble_available()) {
    byte data0 = ble_read();
    byte data1 = ble_read();
    byte data2 = ble_read();
    
    if (data0 == 0x01) {
      // Start
      start_transmitting = true;
      ble_write(0x01);
      ble_write(1);
      ble_write(0x00);
    }
    if (data0 == 0x02) {
      // Stop
      start_transmitting = false;
      ble_write(0x02);
      ble_write(1);
      ble_write(0x00);
    }
    if (data0 == 0x04) {
      // Sample Change
      if (data1 == 0x10) {
        sample_rate = 500;
      } else {
        sample_rate = int(data1) * 1000;
      }
      
      // Success Response
      ble_write(0x04);
      ble_write(1);
      ble_write(0x00);
      Serial.write("HI: ");
      Serial.write(sample_rate);
    }
    if (data0 == 0x05) {
      // Report # of Sensors
      ble_write(0x05);
      ble_write(device);
      ble_write(5);
      ble_write(0x00);
    }
    
  }
  
  if (start_transmitting) {
   
    Serial.write("MOO\n");
    // Report Sensor Values
        
    long sensorID1 = 1;
    long r1 = random(30);
    
    long sensorID2 = 2;
    long r2 = random(30);
    
    long sensorID3 = 3;
    long r3 = random(30);
    
    long sensorID4 = 4;
    long r4 = random(30);
    
    long sensorID5 = 5;
    long r5 = random(30);
    
    
    ble_write(0x06);
    ble_write(device);

    ble_write(sensorID1);
    ble_write(r1);
    
    ble_write(sensorID2);
    ble_write(r2);
    
    ble_write(sensorID3);
    ble_write(r3);
    
    ble_write(sensorID4);
    ble_write(r4);
    
    ble_write(sensorID5);
    ble_write(r5);
    
    ble_write(0x00);
    Serial.write("Hello1");
    Serial.write(sample_rate);
    Serial.write("Hello2");
    delay(sample_rate);

  }
  
//  while(ble_available())
//  {
//    // read out command and data
//    byte data0 = ble_read();
//    byte data1 = ble_read();
//    byte data2 = ble_read();
//    Serial.println(ble_available());
////    Serial.println(data0);
////    Serial.println(data1);
////    Serial.println(data2);
//    
//    Serial.println('ble available \n');
//    if (data0 == 0x01)  // Command is to control digital out pin
//    {
//      if (data1 == 0x01)
//        digitalWrite(DIGITAL_OUT_PIN, HIGH);
//      else
//        digitalWrite(DIGITAL_OUT_PIN, LOW);
//    }
//    else if (data0 == 0xA0) // Command is to enable analog in reading
//    {
//      Serial.println('analog');
//      if (data1 == 0x01)
//        analog_enabled = true;
//      else
//        analog_enabled = false;
//    }
//    else if (data0 == 0x02) // Command is to control PWM pin
//    {
//      analogWrite(PWM_PIN, data1);
//    }
//    else if (data0 == 0x03)  // Command is to control Servo pin
//    {
//      myservo.write(data1);
//    }
//    else if (data0 == 0x04)
//    {
//      analog_enabled = false;
//      myservo.write(0);
//      analogWrite(PWM_PIN, 0);
//      digitalWrite(DIGITAL_OUT_PIN, LOW);
//    }
//  }
  
  // Do this even if not available.
  
//  uint16_t value = analogRead(ANALOG_IN_PIN); 
//  ble_write(0x0B);
//  ble_write(value >> 8);
//  ble_write(13);
//      
//  if (analog_enabled)  // if analog reading enabled
//  {
//    // Read and send out
//    uint16_t value = analogRead(ANALOG_IN_PIN); 
//    ble_write(0x0B);
//    ble_write(value >> 8);
//    ble_write(value);
//  }
//  
//  // If digital in changes, report the state
//  if (digitalRead(DIGITAL_IN_PIN) != old_state)
//  {
//    Serial.println("BLE DIGITAL RECEIVED");
//    old_state = digitalRead(DIGITAL_IN_PIN);
//    
//    if (digitalRead(DIGITAL_IN_PIN) == HIGH)
//    {
//      ble_write(0x0A);
//      ble_write(0x01);
//      ble_write(0x00);    
//    }
//    else
//    {
//      ble_write(0x0A);
//      ble_write(0x00);
//      ble_write(0x00);
//    }
//  }
//  
//  if (!ble_connected())
//  {
//    
//    analog_enabled = false;
//    digitalWrite(DIGITAL_OUT_PIN, LOW);
//  }
  
  // Allow BLE Shield to send/receive data
  ble_do_events();  
 
}



