int trig = 8;
int echo = 9;

int trig2 = 10;
int echo2 = 11;

int gonder1 = 5;
int gonder2 = 6;
int gonder3 = 7;

long deger;
long cm = 0;

long deger2;
long cm2 = 0;

void setup() {
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);
  
  pinMode(trig2, OUTPUT);
  pinMode(echo2, INPUT);
  
  pinMode(gonder1, OUTPUT);
  pinMode(gonder2, OUTPUT);
  pinMode(gonder3, OUTPUT);

}

void loop() {
  
  analogWrite(gonder2, cm);
  analogWrite(gonder3, cm2);

  digitalWrite(trig, LOW);
  digitalWrite(trig, HIGH);
  digitalWrite(trig, LOW);
  
  analogWrite(gonder2, cm);
  analogWrite(gonder3, cm2);
  
  deger = pulseIn(echo, HIGH);
  cm = deger/29/2;
  delay(10);
  
  analogWrite(gonder2, cm);
  analogWrite(gonder3, cm2);
  
  digitalWrite(trig2, LOW);
  digitalWrite(trig2, HIGH);
  digitalWrite(trig2, LOW);
  
  analogWrite(gonder2, cm);
  analogWrite(gonder3, cm2);
  
  deger2 = pulseIn(echo2, HIGH);
  cm2 = deger2/29/2;
  delay(10);
  
  analogWrite(gonder2, cm);
  analogWrite(gonder3, cm2);
}
