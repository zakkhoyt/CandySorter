

// BLE libraries available here: http://redbearlab.com/rbl_library
// BLE includes
#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>

// Servo includes
#include <Servo.h>

// Preprocessors for debugging
#define VWW_ENABLE_BLE 1
#define VWW_ENABLE_SERVOS 1

// Command bytes for incoming BLE
const unsigned int kLoadCandyCommand = 0xB0;
const unsigned int kDropCandyCommand = 0xB1;
const unsigned int kIntializeServosCommand = 0xB2;
const unsigned int kSetLoadPositionCommand = 0xB3;
const unsigned int kSetInspectPositionCommand = 0xB4;
const unsigned int kSetDropCandyPositionCommand = 0xB5;
const unsigned int kSetDispenseMinPositionCommand = 0xB6;
const unsigned int kSetDispenseMaxPositionCommand = 0xB7;
const unsigned int kSetDispenseNumChoicesCommand = 0xB8;
// Command bytes for outgoing BLE
const unsigned int kCandyWasLoadedCommand = 0xC0;
const unsigned int kCandyWasDroppedCommand = 0xC1;
const unsigned int kServosDidInitializeCommand = 0xC2;
const unsigned int kLoadPositionWasSetCommand = 0xC3;
const unsigned int inspectPositionWasSetCommand = 0xC4;
const unsigned int kDropCandyPositionWasSetCommand = 0xC5;
const unsigned int kDispenseMinPositionWasSetCommand = 0xC6;
const unsigned int kDispenseMaxPositionWasSetCommand = 0xC7;
const unsigned int kDispenseNumChoicesWasSetCommand = 0xC8;

// I/O pins
const unsigned int kLEDPin = 4;
const unsigned int kLoadServoPin = 5;
const unsigned int kDropServoPin = 6;

// Servo positions
unsigned int loadPosition = 160;
unsigned int inspectPosition = 90;
unsigned int dropPosition = 20;
unsigned int dispenseMinPosition = 20;
unsigned int dispenseMaxPosition = 160;
unsigned int dispenseNumChoices = 12;

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
            dispenseCandy(data1, dispenseNumChoices);
            delay(200);
            
            
            // Send reply
            ble_write(kCandyWasDroppedCommand);
            ble_write(0x00);
            ble_write(0x00);
            
        }  else if (data0 == kIntializeServosCommand){
            Serial.println("Recieved initialize servos command.");
                        
            initServos();
            
            // Send reply
            ble_write(kServosDidInitializeCommand);
            ble_write(0x00);
            ble_write(0x00);
            
        } else if (data0 == kSetLoadPositionCommand){
            Serial.println("Recieved set load position command");
            
            loadPosition = data1;
            loadCandy();
            
            
            // Send reply
            ble_write(kLoadPositionWasSetCommand);
            ble_write(loadPosition);
            ble_write(0x00);
        } else if (data0 == kSetInspectPositionCommand){
            Serial.println("Recieved set inspect position command");
            
            inspectPosition = data1;
            inspectCandy();
            
            // Send reply
            ble_write(inspectPositionWasSetCommand);
            ble_write(inspectPosition);
            ble_write(0x00);
            
        } else if (data0 == kSetDropCandyPositionCommand){
            Serial.println("Recieved set drop position command.");
            
            dropPosition = data1;
            dropCandy();
            
            // Send reply
            ble_write(kDropCandyPositionWasSetCommand);
            ble_write(dropPosition);
            ble_write(0x00);
            
        } else if (data0 == kSetDispenseMinPositionCommand){
            Serial.println("Recieved set dispense min position command.");
            
            dispenseMinPosition = data1;
            dispenseCandy(0, dispenseNumChoices);
            
            // Send reply
            ble_write(kDispenseMinPositionWasSetCommand);
            ble_write(dispenseMinPosition);
            ble_write(0x00);
            
        } else if (data0 == kSetDispenseMaxPositionCommand){
            Serial.println("Recieved set dispense max position command.");
            
            dispenseMaxPosition = data1;
            dispenseCandy(dispenseNumChoices - 1, dispenseNumChoices);
            
            // Send reply
            ble_write(kDispenseMaxPositionWasSetCommand);
            ble_write(dispenseMaxPosition);
            ble_write(0x00);
            
        } else if (data0 == kSetDispenseNumChoicesCommand){
            Serial.println("Recieved set dispense num choices command");
            
            dispenseNumChoices = data1;
            
            for(unsigned int x = 0; x < dispenseNumChoices; x++){
                dispenseCandy(x, dispenseNumChoices);
                delay(200);
            }
            
            // Send reply
            ble_write(kDispenseNumChoicesWasSetCommand);
            ble_write(dispenseNumChoices);
            ble_write(0x00);
            
        } else {
            Serial.println("Unknown command");
        }
    }
    
    // Set status LED to on if connected
    if (ble_connected()) {
      digitalWrite(kLEDPin, HIGH);
    } else {
      digitalWrite(kLEDPin, LOW);
    }
    
    // Allow BLE Shield to send/receive data
    ble_do_events();
    
#endif

}

void loadCandy(){
    Serial.println("Loading candy position");
    
    loadServo.write(loadPosition); 
}

void inspectCandy(){
    Serial.println("Inspect candy position");
    loadServo.write(inspectPosition);
}

void dropCandy(){
    Serial.println("Drop candy position");
    loadServo.write(dropPosition);
}

void dispenseCandy(unsigned int pos, unsigned int totalPositions){
    //    unsigned int p = map(pos, 0, 1023, dispenseMinPosition, dispenseMaxPosition);
    unsigned int total = dispenseMaxPosition - dispenseMinPosition;
    float perStep = total / (dispenseNumChoices - 1);
    unsigned int p = dispenseMinPosition + perStep * pos;
    
    char *s = (char*)malloc(16 * sizeof(char));
    sprintf(s, "Pos: %u:%u", pos, p);
    Serial.println(s);
    free(s);
    
    
    
    dropServo.write(p);
}


void initServos(){
      // Move servos to default locations
    loadCandy();
    delay(100);
    inspectCandy();
    delay(100);
    dropCandy();
    delay(100);
    inspectCandy();
    delay(100);
    loadCandy();
    delay(100);
    inspectCandy();
    delay(100);
    
    for(unsigned int x = 0; x < dispenseNumChoices; x++){
      dispenseCandy(x, dispenseNumChoices);
      
      char *s = (char*)malloc(16 * sizeof(char));
      sprintf(s, "x: %d %d", x, dispenseNumChoices);
      Serial.println(s);
      free(s);
      delay(100);
    }
    for(int x = dispenseNumChoices - 2; x > -1; x--){
      dispenseCandy(x, dispenseNumChoices);
      
      char *s = (char*)malloc(16 * sizeof(char));
      sprintf(s, "x: %d %d", x, dispenseNumChoices);
      Serial.println(s);
      free(s);      
      delay(100);
    }

    delay(100);
}

