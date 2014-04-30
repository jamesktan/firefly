#include <ble_mini.h>
#include <Servo.h> 
 
#define DIGITAL_OUT_PIN    4
#define DIGITAL_IN_PIN     5
#define PWM_PIN            6
#define SERVO_PIN          7
#define ANALOG_IN_PIN      A5

Servo myservo;

unsigned long currentMillis;        // store the current value from millis()
unsigned long previousMillis;       // for comparison with currentMillis
int samplingInterval = 250;          // how often to run the main loop (in ms)

float resist = 47; 
float battery = 5;
float constant = -2;

void setup()
{
  BLEMini_begin(57600);
  
  pinMode(DIGITAL_OUT_PIN, OUTPUT);
  pinMode(DIGITAL_IN_PIN, INPUT);
  
  // Default to internally pull high, change it if you need
  digitalWrite(DIGITAL_IN_PIN, HIGH);
  //digitalWrite(DIGITAL_IN_PIN, LOW);
  
  myservo.attach(SERVO_PIN);
}

void loop()
{
  static boolean analog_enabled = false;
  static byte old_state = LOW;
  
  // If data is ready
  while ( BLEMini_available() == 3 )
  {
    // read out command and data
    byte data0 = BLEMini_read();
    byte data1 = BLEMini_read();
    byte data2 = BLEMini_read();
    
    if (data0 == 0x01)  // Command is to control digital out pin
    {
      if (data1 == 0x01)
        digitalWrite(DIGITAL_OUT_PIN, HIGH);
      else
        digitalWrite(DIGITAL_OUT_PIN, LOW);
    }
    else if (data0 == 0xA0) // Command is to enable analog in reading
    {
      if (data1 == 0x01)
        analog_enabled = true;
      else
        analog_enabled = false;
    }
    else if (data0 == 0x02) // Command is to control PWM pin
    {
      analogWrite(PWM_PIN, data1);
    }
    else if (data0 == 0x03)  // Command is to control Servo pin
    {
      myservo.write(data1);
    }
    else if (data0 == 0x04) // Command is to reset
    {
      analog_enabled = false;
      myservo.write(0);
      analogWrite(PWM_PIN, 0);
      digitalWrite(DIGITAL_OUT_PIN, LOW);
    }
  }
  
  if (analog_enabled)  // if analog reading enabled
  {
    currentMillis = millis();
    if (currentMillis - previousMillis > samplingInterval)
    {
      previousMillis += millis();
      
      // Read and send out
      uint16_t value = temp_calib(analogRead(ANALOG_IN_PIN))*10; 
      BLEMini_write(0x0B);
      BLEMini_write(value >> 8);
      BLEMini_write(value);
    }
  }
  
  // If digital in changes, report the state
  if (digitalRead(DIGITAL_IN_PIN) != old_state)
  {
    old_state = digitalRead(DIGITAL_IN_PIN);
    
    if (digitalRead(DIGITAL_IN_PIN) == HIGH)
    {
      BLEMini_write(0x0A);
      BLEMini_write(0x01);
      BLEMini_write(0x00);    
    }
    else
    {
      BLEMini_write(0x0A);
      BLEMini_write(0x00);
      BLEMini_write(0x00);
    }
  }
  
  delay(100);
}

float temp_calib(float temp_raw){
  //float VCC = analogRead(power_read);
  //Serial.println(VCC);  
  float temp_f = (temp_raw*0.1743)-10.027+constant;
  return temp_f;
}
