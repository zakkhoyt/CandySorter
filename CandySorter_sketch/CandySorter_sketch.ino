

// BLE libraries available here: http://redbearlab.com/rbl_library
// Redbear includes
#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>

// VWW includes
#include <Servo.h> 

//#define VWW_ENABLE_BLE 1
#define VWW_ENBABLE_SERVOS 1



// Readbear Defines
#define DIGITAL_OUT_PIN    4
#define DIGITAL_IN_PIN     5
#define PWM_PIN            6
#define SERVO_PIN          7
#define ANALOG_IN_PIN      A5

//Servo myservo;

// VWW Defines
const unsigned int kLoadServo = 9;
const unsigned int kDropServo = 10;
const unsigned int kPickupPosition = 160;
const unsigned int kInspectPosition = 90;
const unsigned int kDropPosition = 20;
const unsigned int kMinPosition = 20;
const unsigned int kMaxPosition = 160;
const unsigned int kNumChoices = 12;


Servo loadServo;
Servo dropServo;
int pos = 0;    // variable to store the servo position 



void setup()
{
  
#if defined(VWW_ENABLE_BLE)
  // Default pins set to 9 and 8 for REQN and RDYN
  // Set your REQN and RDYN here before ble_begin() if you need
  //ble_set_pins(3, 2);
  
  // Init. and start BLE library.
  ble_begin();
  
  // Enable serial debug
  Serial.begin(57600);
  
  pinMode(DIGITAL_OUT_PIN, OUTPUT);
  pinMode(DIGITAL_IN_PIN, INPUT);
  
  // Default to internally pull high, change it if you need
  digitalWrite(DIGITAL_IN_PIN, HIGH);
  //digitalWrite(DIGITAL_IN_PIN, LOW);
  
//  myservo.attach(SERVO_PIN);
  
#endif

#if defined(VWW_ENBABLE_SERVOS)
  Serial.begin(9600);
  Serial.println("Init load servo");
  loadServo.attach(kLoadServo);
  Serial.println("Init drop servo");
  dropServo.attach(kDropServo);
#endif
}

void loop()
{
  
#if defined(VWW_ENABLE_BLE)
  static boolean analog_enabled = false;
  static byte old_state = LOW;
  
  // If data is ready
  while(ble_available())
  {
    // read out command and data
    byte data0 = ble_read();
    byte data1 = ble_read();
    byte data2 = ble_read();
    
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
//      myservo.write(data1);
    }
    else if (data0 == 0x04)
    {
      analog_enabled = false;
//      myservo.write(0);
      analogWrite(PWM_PIN, 0);
      digitalWrite(DIGITAL_OUT_PIN, LOW);
    }
  }
  
  if (analog_enabled)  // if analog reading enabled
  {
    // Read and send out
    uint16_t value = analogRead(ANALOG_IN_PIN); 
    ble_write(0x0B);
    ble_write(value >> 8);
    ble_write(value);
  }
  
  // If digital in changes, report the state
  if (digitalRead(DIGITAL_IN_PIN) != old_state)
  {
    old_state = digitalRead(DIGITAL_IN_PIN);
    
    if (digitalRead(DIGITAL_IN_PIN) == HIGH)
    {
      ble_write(0x0A);
      ble_write(0x01);
      ble_write(0x00);    
    }
    else
    {
      ble_write(0x0A);
      ble_write(0x00);
      ble_write(0x00);
    }
  }
  
  if (!ble_connected())
  {
    analog_enabled = false;
    digitalWrite(DIGITAL_OUT_PIN, LOW);
  }
  
  // Allow BLE Shield to send/receive data
  ble_do_events();  
#endif




#if defined(VWW_ENABLE_SERVOS)  
  
  
  //  for(pos = 0; pos < 160; pos += 1)  // goes from 0 degrees to 180 degrees 
//  {                                  // in steps of 1 degree 
//    loadServo.write(pos);              // tell servo to go to position in variable 'pos' 
//    dropServo.write(pos);
//    delay(15);                       // waits 15ms for the servo to reach the position 
//  } 

  unsigned int i = 0;
  randomSeed(analogRead(0));
  for(;;){
    pickupCandy();
    delay(200);
    
    inspectCandy();
    delay(500);
    
    dropCandy();
    
    

//    unsigned int rNum = random(kNumChoices);
    if(i == kNumChoices - 1){
      i = 0;
    } else {
      i++;
    }
    dispenseCandy(i, kNumChoices);
    delay(200);
  }

#endif
}



void pickupCandy(){
    loadServo.write(kPickupPosition); 
}

void inspectCandy(){
    loadServo.write(kInspectPosition); 
}

void dropCandy(){
    loadServo.write(kDropPosition);  
}

void dispenseCandy(unsigned int pos, unsigned int totalPositions){
//    unsigned int p = map(pos, 0, 1023, kMinPosition, kMaxPosition);
  unsigned int total = kMaxPosition - kMinPosition;
  float perStep = total / (kNumChoices - 1);
  unsigned int p = kMinPosition + perStep * pos;
  
  char *s = (char*)malloc(16 * sizeof(char));
  sprintf(s, "Pos: %u:%u", pos, p);
  Serial.println(s);



  dropServo.write(p);
}


