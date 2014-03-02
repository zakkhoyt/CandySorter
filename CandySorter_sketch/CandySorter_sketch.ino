

// BLE libraries available here: http://redbearlab.com/rbl_library
// Redbear includes
#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>

// VWW includes
#include <Servo.h>

// Preprocessors for debugging
#define VWW_ENABLE_BLE 1
#define VWW_ENABLE_SERVOS 1

// Command byts for BLE
const unsigned int kLoadCandyCommand = 0xB0;
const unsigned int kDropCandyCommand = 0xB1;
const unsigned int kIntializeServosCommand = 0xB2;
const unsigned int kCandyWasLoadedCommand = 0xC0;
const unsigned int kCandyWasDroppedCommand = 0xC1;
const unsigned int kServosDidInitializeCommand = 0xC2;

// I/O pins
const unsigned int kLEDPin = 4;
const unsigned int kLoadServoPin = 5;
const unsigned int kDropServoPin = 6;

// Servo positions
const unsigned int kPickupPosition = 160;
const unsigned int kInspectPosition = 90;
const unsigned int kDropPosition = 20;
const unsigned int kMinPosition = 20;
const unsigned int kMaxPosition = 160;
const unsigned int kNumChoices = 12;

// Servos
Servo loadServo;
Servo dropServo;

void setup(){
Serial.begin(57600);

#if defined(VWW_ENABLE_BLE)
    // Init. and start BLE library.
    ble_begin();
    pinMode(kLEDPin, OUTPUT);
    digitalWrite(kLEDPin, LOW);
    Serial.println("BLE setup");
#endif
    
#if defined(VWW_ENABLE_SERVOS)
    Serial.println("Init load servo");
    loadServo.attach(kLoadServoPin);
    Serial.println("Init drop servo");
    dropServo.attach(kDropServoPin);
    
    initServos();    
    Serial.println("Servo setup");
#endif
}

void loop() {
    
#if defined(VWW_ENABLE_BLE)
    // If data is ready
    while(ble_available())
    {
        // Indicate that we are ready
        digitalWrite(kLEDPin, HIGH);
        
        // read out command and data
        byte data0 = ble_read();
        byte data1 = ble_read();
        byte data2 = ble_read();
        
        if (data0 == kLoadCandyCommand){
            Serial.println("Recieved load candy command.");
            
            // Load candy and move it to inspection position
            loadCandy();
            delay(200);
            inspectCandy();
            
            // Send loaded reply
            ble_write(kCandyWasLoadedCommand);
            ble_write(0x00);
            ble_write(0x00);
            
        } else if (data0 == kDropCandyCommand){
            Serial.println("Recieved drop candy command.");
            
            // Drop candy in indicated bin
            dropCandy();
            dispenseCandy(data1, 12);
            delay(200);
            
            
            // Send loaded reply
            ble_write(kCandyWasDroppedCommand);
            ble_write(0x00);
            ble_write(0x00);
            
        }  else if (data0 == kIntializeServosCommand){
            Serial.println("Recieved initialize servos command.");
                        
            initServos();
            
            // Send loaded reply
            ble_write(kServosDidInitializeCommand);
            ble_write(0x00);
            ble_write(0x00);
            
        } else {
            Serial.println("Unknown command");
        }
    }
    
    if (!ble_connected())
    {
      digitalWrite(kLEDPin, LOW);
//        analog_enabled = false;
//        digitalWrite(DIGITAL_OUT_PIN, LOW);
  
    }
    
    // Allow BLE Shield to send/receive data
    ble_do_events();
    
#endif

}

void loadCandy(){
    Serial.println("Loading candy position");
    
    loadServo.write(kPickupPosition); 
}

void inspectCandy(){
    Serial.println("Inspect candy position");
    loadServo.write(kInspectPosition); 
}

void dropCandy(){
    Serial.println("Drop candy position");
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


void initServos(){
      // Move servos to default locations
    loadCandy();
    delay(200);
    inspectCandy();
    delay(200);
    dropCandy();
    delay(200);
    inspectCandy();
    delay(200);
    loadCandy();
    delay(200);
    inspectCandy();
    delay(200);
    
    for(unsigned int x = 0; x < 12; x++){
      dispenseCandy(x, 12);
      delay(200);
    }
    for(int x = 10; x > -1; x--){
      dispenseCandy(x, 12);
      delay(200);
    }
//    dispenseCandy(0, 12);
}

