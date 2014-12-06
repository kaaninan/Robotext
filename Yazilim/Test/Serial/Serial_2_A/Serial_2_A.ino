int firstSensor = 0;
int secondSensor = 0;
int thirdSensor = 0;
String inByte;

int led = 52;
int led2 = 13;

boolean devam = false;

boolean first = true;

int trig = 22;
int echo = 23;
long deger;
int cm;

void setup(){
  Serial.begin(115200);
  pinMode(led, OUTPUT);
  pinMode(led2, OUTPUT);
  
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);
  
  establishContact();
}

void loop(){
  
  if(devam == true){

    digitalWrite(trig, LOW);
    digitalWrite(trig, HIGH);
    digitalWrite(trig, LOW);
    
    deger = pulseIn(echo, HIGH);
    cm = deger/29/2;

    
    digitalWrite(led2, HIGH);
    
    devam = false;
  }
}


void serialEvent() {
  
  while (Serial.available()) {
    
    int serialRead = Serial.read();
        
    if(serialRead == '1'){
      digitalWrite(led, HIGH);
      Serial.println('2');
    }
    
    else if(serialRead == 'p'){
      Serial.println('o');
    }
    
    else{
      devam = true;
      Serial.println(cm);
    }
    
  }
  
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0");
    delay(100);
  }
}

void analogSensorOku(){
  firstSensor = analogRead(0);
  secondSensor = analogRead(1);
  thirdSensor = analogRead(8);
}
