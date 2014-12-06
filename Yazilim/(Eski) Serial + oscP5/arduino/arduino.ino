int firstSensor = 0;
int secondSensor = 0;
int thirdSensor = 0;
int inByte = 0;

int motor = 3;
int motor2 = 6;
int motor3 = 5;
int motor4 = 9;

int motor1__;
int motor2__;
int motor3__;

int d_motor = 2;
int d_motor2 = 4;
int d_motor3 = 7;
int d_motor4 = 8;

int motor1_d = 0;
int motor2_d = 0;
int motor3_d = 0;
int motor4_d = 0;

int trig =22;
int echo = 23;

String command;

int deger;
int cm = 255;

boolean devam = true;

void setup(){
  Serial.begin(115200);
  
  pinMode(motor, OUTPUT);
  pinMode(motor2, OUTPUT);
  pinMode(motor3, OUTPUT);
  pinMode(motor4, OUTPUT);
  
  pinMode(d_motor, OUTPUT);
  pinMode(d_motor2, OUTPUT);
  pinMode(d_motor3, OUTPUT);
  pinMode(d_motor4, OUTPUT);
  
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);
  
  pinMode(13, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(52, OUTPUT);
  
  establishContact();
}

void loop(){
  
  if(devam == true){
    
    
    devam = false;
  }
}

void serialEvent() {
  
  while (Serial.available()) {
    
    motor1__ = Serial.parseInt();
    motor2__ = Serial.parseInt();
    motor3__ = Serial.parseInt();
    
    if (Serial.read() == '\n') {
      
      devam = true;
      digitalWrite(13, HIGH);
      
      analogWrite(motor, motor1__);
      analogWrite(motor2, motor1__);
      analogWrite(motor3, motor2__);
      analogWrite(motor4, motor2__);
      
      if(motor3__ == 0){
        digitalWrite(d_motor, LOW);
        digitalWrite(d_motor2, LOW);
        digitalWrite(d_motor3, HIGH);
        digitalWrite(d_motor4, HIGH);
      }
      else{
        digitalWrite(d_motor, HIGH);
        digitalWrite(d_motor2, HIGH);
        digitalWrite(d_motor3, LOW);
        digitalWrite(d_motor4, LOW);
      }
    }
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0,0,0");   // send an initial string
    delay(300);
  }
}
