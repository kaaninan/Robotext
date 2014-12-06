#include <Servo.h>
#include "notes.h" 
#include "IO_pins.h"
#include "constants.h"

// define Global Variables
long time;                                     // used for chasing the LEDs
int lightchase;                                // used for chasing the LEDs
int leftspeed;                                 // speed of left motor
int rightspeed;                                // speed of right motor
int pan=pancenter;                             // position of pan servo
int tilt=tiltcenter;                           // position of tilt servo
int distance;                                  // distance of object being tracked
int leftIRvalue;                               // reading from Compound Eye left sensor
int rightIRvalue;                              // reading from Compound Eye right sensor
int upperIRvalue;                              // reading from Compound Eye upper sensor
int lowerIRvalue;                              // reading from Compound Eye lower sensor
int temp;
int noise;

// define Servos
Servo panservo;                                // define panservo
Servo tiltservo;                               // define tiltservo

void setup()
{
  // initialize servos and configure pins

  panservo.attach(PANpin);                     // configure pin as pan servo
  panservo.writeMicroseconds(pancenter);       // initialize neck pan servo  
  tiltservo.attach(TILpin);                    // configure pin as tilt servo                      
  tiltservo.writeMicroseconds(tiltcenter);     // initialize neck tilt servo 

  pinMode (LMDpin,OUTPUT);                     // configure Left Motor Direction pin as output
  pinMode (RMDpin,OUTPUT);                     // configure Right Motor Direction pin as output
  pinMode (CEIpin,OUTPUT);                     // configure Compound Eye IR pin for output
  pinMode (Speaker,OUTPUT);                    // configure speaker pin for output
  pinMode (FRLpin,OUTPUT);                     // configure Front Right LEDs pin for output
  pinMode (FLLpin,OUTPUT);                     // configure Front Left  LEDs pin for output
  pinMode (RLLpin,OUTPUT);                     // configure Rear  Left  LEDs pin for output
  pinMode (RRLpin,OUTPUT);                     // configure Rear  Right LEDs pin for output 


  // play tune on powerup / reset
  int melody[] = {NOTE_C4,NOTE_G3,NOTE_G3,NOTE_A3,NOTE_G3,0,NOTE_B3,NOTE_C4};
  int noteDurations[] = {4,8,8,4,4,4,4,4};
  for (byte Note = 0; Note < 8; Note++)        // Play eight notes
  {
    int noteDuration = 1000/noteDurations[Note];
    tone(Speaker,melody[Note],noteDuration);
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
  }  
  //Serial.begin(9600);
}


void loop()
{
  if (millis()-time>249)                        // chase LEDs every 250mS
  {
    time=millis();
    lightchase=lightchase+1-4*(lightchase>3);   // counts from 1-4 repeatedly
    
  }

  digitalWrite(LMDpin,(leftspeed>0));           // set Left Motor Direction to forward if speed>0
  analogWrite(LMSpin,abs(leftspeed));           // set Left Motor Speed

  digitalWrite(RMDpin,(rightspeed>0));          // set Right Motor Direction to forward if speed>0
  analogWrite(RMSpin,abs(rightspeed));          // set Left  Motor Speed

  panservo.writeMicroseconds(pan);              // update pan servo  position
  tiltservo.writeMicroseconds(tilt);            // update tilt servo position

  IReye();
  IRfollow();
  ObjectDetection();

}

void IReye()
{//============================================================= READ IR COMPOUND EYE ================================================


  digitalWrite(CEIpin,HIGH);                                  // turn on IR LEDs to read TOTAL IR LIGHT (ambient + reflected)
  delay(2);
  leftIRvalue=analogRead(CELpin);                             // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  rightIRvalue=analogRead(CERpin);                            // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  upperIRvalue=analogRead(CEUpin);                            // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  lowerIRvalue=analogRead(CEDpin);                            // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT

  digitalWrite(CEIpin,LOW);                                   // turn off IR LEDs to read AMBIENT IR LIGHT (IR from indoor lighting and sunlight)
  delay(2);
  leftIRvalue=leftIRvalue-analogRead(CELpin);                 // REFLECTED IR = TOTAL IR - AMBIENT IR
  rightIRvalue=rightIRvalue-analogRead(CERpin);               // REFLECTED IR = TOTAL IR - AMBIENT IR
  upperIRvalue=upperIRvalue-analogRead(CEUpin);               // REFLECTED IR = TOTAL IR - AMBIENT IR
  lowerIRvalue=lowerIRvalue-analogRead(CEDpin);               // REFLECTED IR = TOTAL IR - AMBIENT IR

  distance=(leftIRvalue+rightIRvalue+upperIRvalue+lowerIRvalue)/4;// distance of object is average of reflected IR

  noise++;
  if(noise>5)
  {
    tone(Speaker,distance*5+100,5);                            // produce sound every eighth loop - high pitch = close distance
    noise=0;
  }  
}

void IRfollow()
{//============================================================= TRACK OBJECT WITH EYE ===============================================
  int panscale;
  int panadjust;
  int tiltscale;
  int tiltadjust;

  leftspeed=0;                                                  // start with motor speeds set to 0
  rightspeed=0;

  if (distance<distancemax)                                     // if no object in range then center neck
  {
    if (pan>pancenter)pan--;
    if (pan<pancenter)pan++;
    if (tilt>tiltcenter)tilt--;
    if (tilt<tiltcenter)tilt=tilt++;
  }
  else
  {
    //-------------------------------------------------------------Track object with head------------------------------------------------
    panscale=(leftIRvalue+rightIRvalue)/panscalefact;
    tiltscale=(upperIRvalue+lowerIRvalue)/tiltscalefact;        //
    if (leftIRvalue>rightIRvalue)
    {
      panadjust=(leftIRvalue-rightIRvalue)*5/panscale;
      pan=pan-panadjust;
    }
    if (leftIRvalue<rightIRvalue)
    {
      panadjust=(rightIRvalue-leftIRvalue)*5/panscale;          //
      pan=pan+panadjust;
    }
    if (upperIRvalue>lowerIRvalue)
    {
      tiltadjust=(upperIRvalue-lowerIRvalue)*5/tiltscale;
      tilt=tilt-tiltadjust;
    }
    if (lowerIRvalue>upperIRvalue)
    {
      tiltadjust=(lowerIRvalue-upperIRvalue)*5/tiltscale;       //
      tilt=tilt+tiltadjust;
    }
    constrain(pan,panmin,panmax);
    constrain(tilt,tiltmin,tiltmax); 


    //-------------------------------------------------------------Turn body to follow object--------------------------------------------

    temp=pan-pancenter;                                         // how far offcenter is pan servo                  
    if (abs(temp)>pandeadband)                                  // if panservo is outside of deadband
    {
      leftspeed=  temp/2;                                       // adjust left  motor speed to turn body toward object
      rightspeed= -temp/2;                                      // adjust right motor speed to turn body toward object
    }
    //------------------------------------------------------Move forward or backward to follow object------------------------------------

    temp=abs(distance-bestdistance);

    if (temp>disdeadband)
    {
      temp=(temp-disdeadband)/3;
      if (distance>bestdistance)
      {
        rightspeed=rightspeed-temp;
        leftspeed=leftspeed-temp;
      }
      else
      {
        rightspeed=rightspeed+temp;
        leftspeed=leftspeed+temp;
      }
    }
    constrain (leftspeed,-255,255);                           // limit speed for PWM
    constrain (rightspeed,-255,255);                          // limit speed for PWM
  }
}

void ObjectDetection()
//============================================================Avoid hitting objects==================================================

{
  int frontrightsen;
  int frontleftsen;
  int rearleftsen;
  int rearrightsen;

  //turn on edge detection LEDs
  digitalWrite(FRLpin,1);
  digitalWrite(FLLpin,1);
  digitalWrite(RLLpin,1);
  digitalWrite(RRLpin,1);
  delayMicroseconds(50);
  
  // read total IR values
  frontrightsen=analogRead(FRSpin);
  frontleftsen=analogRead(FLSpin);
  rearleftsen=analogRead(RLSpin);
  rearrightsen=analogRead(RRSpin);

  // turn off edge detection LEDs
  digitalWrite(FRLpin,0);
  digitalWrite(FLLpin,0);
  digitalWrite(RLLpin,0);
  digitalWrite(RRLpin,0);
  delayMicroseconds(50);

  // subtract ambient IR from total IR to give reflected IR values
  frontrightsen=frontrightsen-analogRead(FRSpin);
  frontleftsen=frontleftsen-analogRead(FLSpin);
  rearleftsen=rearleftsen-analogRead(RLSpin);
  rearrightsen=rearrightsen-analogRead(RRSpin);

  // turn on indicator LED if object closer than safe distance otherwise chase LEDs
  digitalWrite(FRLpin,(lightchase==4 || frontrightsen>safedistance));
  digitalWrite(FLLpin,(lightchase==1 || frontleftsen>safedistance));
  digitalWrite(RLLpin,(lightchase==2 || rearleftsen>safedistance));
  digitalWrite(RRLpin,(lightchase==3 || rearrightsen>safedistance));

  // Adjust motor speeds to avoid collision
  if (frontrightsen>safedistance && rightspeed>0) rightspeed=0;
  if (frontleftsen>safedistance && leftspeed>0) leftspeed=0;
  if (rearleftsen>safedistance && leftspeed<0) leftspeed=0;
  if (rearrightsen>safedistance && rightspeed<0) rightspeed=0;

}





