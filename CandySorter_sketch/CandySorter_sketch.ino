// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.


#include <Servo.h> 

const unsigned int kEntryServo = 9;
const unsigned int kExitServo = 10;
const unsigned int kPickupPosition = 160;
const unsigned int kInspectPosition = 90;
const unsigned int kDropPosition = 20;
const unsigned int kMinPosition = 20;
const unsigned int kMaxPosition = 160;
const unsigned int kNumChoices = 12;


Servo entryServo;
Servo exitServo;
               
int pos = 0;    // variable to store the servo position 
 
void setup() 
{ 
  Serial.begin(9600);
  Serial.println("Init entry servo");
  entryServo.attach(kEntryServo);
  Serial.println("Init exit servo");
  exitServo.attach(kExitServo);
} 
 
 
void loop() 
{ 
  

//  for(pos = 0; pos < 160; pos += 1)  // goes from 0 degrees to 180 degrees 
//  {                                  // in steps of 1 degree 
//    entryServo.write(pos);              // tell servo to go to position in variable 'pos' 
//    exitServo.write(pos);
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

} 



void pickupCandy(){
    entryServo.write(kPickupPosition); 
}

void inspectCandy(){
    entryServo.write(kInspectPosition); 
}

void dropCandy(){
    entryServo.write(kDropPosition);  
}

void dispenseCandy(unsigned int pos, unsigned int totalPositions){
//    unsigned int p = map(pos, 0, 1023, kMinPosition, kMaxPosition);
  unsigned int total = kMaxPosition - kMinPosition;
  float perStep = total / (kNumChoices - 1);
  unsigned int p = kMinPosition + perStep * pos;
  
  char *s = (char*)malloc(16 * sizeof(char));
  sprintf(s, "Pos: %u:%u", pos, p);
  Serial.println(s);



  exitServo.write(p);
}
