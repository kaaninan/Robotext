// TODO
// Sıcaklık ayarlaması

int deger = 0;

int deger_1 = 0;
int deger_2 = 0;

int sicaklik = 29;

// SAG
int trig = 2;
int echo = 4;

int cikis_1 = 3;
int cikis_2 = 5;


void setup() {
  
  Serial.begin(9600);
  
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);
  
  pinMode(cikis_1, OUTPUT);
  pinMode(cikis_2, OUTPUT);
}

void loop() {
  
  // SOL
  digitalWrite(trig, LOW);
  digitalWrite(trig, HIGH);
  digitalWrite(trig, LOW);
  
  deger = (pulseIn(echo, HIGH))/sicaklik/2;
  
  
  // DEGER HAZIRLAMA
  
  if(deger < 256){
    deger_1 = deger;
    deger_2 = 0;
  }else{
    deger_1 = 255;
    deger_2 = deger - 255;
  }
  
  
  // CIKTI
  
  analogWrite(cikis_1, deger_1);
  analogWrite(cikis_2, deger_2);
  
  Serial.println(deger);
  
  delay(100);
  
}
