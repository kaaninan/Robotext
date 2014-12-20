/*

  Özellikler
    - Uzaklık sensöründen verileri okuma
    - Verileri seçilen sensörü göre sıralı ledlerde gösterme
    - Anlık olarak sıcaklığı takip edip en doğru sıcaklığa ulaşma
    - Zaman aşımı ile gecikmeleri önleme
    - Voltajı sürekli ölçerek azalığında ledle ve buzzerla uyarı verme
    
*/


int on_deger = 0;
int arka_deger = 0;

float sicaklik = 29;

int a = 0;
int bekle = 50;

float voltaj = 0;

// Giriş Çıkış

const int on_t = 0;
const int on_e = 1;

const int arka_t = 2;
const int arka_e = 3;

const int on_c_1 = 4;
const int on_c_2 = 5;

const int arka_c_1 = 6;
const int arka_c_2 = 7;

const int latchPin = 8;
const int dataPin = 9;
const int clockPin = 10;

const int buzzer = 11;
const int uyari_led = 12;

const int secim = 13;


// Analog

const int pin_voltaj = 0;
const int pin_sicaklik = 1;


void setup(){
  
  pinMode(on_t, OUTPUT);
  pinMode(on_e, INPUT);
  
  pinMode(arka_t, OUTPUT);
  pinMode(arka_e, INPUT);
  
  pinMode(on_c_1, OUTPUT);
  pinMode(on_c_2, OUTPUT);
  
  pinMode(arka_c_1, OUTPUT);
  pinMode(arka_c_2, OUTPUT);
  
  pinMode(buzzer, OUTPUT);
  
  pinMode(uyari_led, OUTPUT);
  
  pinMode(latchPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  
  pinMode(secim, INPUT);
  
  acilis_animasyonu();
  
}




void loop() {
  
  if(a == 0){
    
    digitalWrite(on_t, LOW);
    digitalWrite(on_t, HIGH);
    digitalWrite(on_t, LOW);
    
    on_deger = (pulseIn(on_e, HIGH, 10000))/sicaklik/2;
    delay(bekle);
    a = 1;
    
  }else{
    
    digitalWrite(arka_t, LOW);
    digitalWrite(arka_t, HIGH);
    digitalWrite(arka_t, LOW);
    
    arka_deger = (pulseIn(arka_e, HIGH, 10000))/sicaklik/2;
    delay(bekle);
    a = 0;
    
  }
  
  // SECIM KONTROL
  
  if(digitalRead(secim) == HIGH){
    int led_seviye = map(on_deger, 0, 50, 0, 6);
    registerWrite(led_seviye, HIGH);
  }else{
    int led_seviye = map(arka_deger, 0, 50, 0, 6);
    registerWrite(led_seviye, HIGH);
  }
  
  
  // KONTROL
   
  if(on_deger < 10){
    digitalWrite(on_c_1, HIGH);
    digitalWrite(on_c_2, LOW);
  
  }else if(9 < on_deger < 30){
    digitalWrite(on_c_2, HIGH);
    digitalWrite(on_c_1, LOW);
    
  }else if(on_deger >= 30){
    digitalWrite(on_c_1, LOW);
    digitalWrite(on_c_2, LOW);
  }
    
  if(arka_deger < 10){
    digitalWrite(arka_c_1, HIGH);
    digitalWrite(arka_c_2, LOW);
  
  }else if(9 < arka_deger < 30){
    digitalWrite(arka_c_2, HIGH);
    digitalWrite(arka_c_1, LOW);

  }else if(arka_deger >= 30){
    digitalWrite(arka_c_1, LOW);
    digitalWrite(arka_c_2, LOW);
  }
  
  
  
  // Voltaj
  int voltage = analogRead(pin_voltaj);
  voltaj = voltage * (5.0 / 1023.0);
  
  if(voltaj < 3.00){
    digitalWrite(uyari_led, HIGH);
    digitalWrite(buzzer, HIGH);
    delay(100);
    digitalWrite(buzzer, LOW);
    delay(100);
    
  }else
    digitalWrite(uyari_led, LOW);
    
    
  
  // Sıcaklık
  float sicaklik = (5.0 * analogRead(pin_sicaklik) * 100.0) / 1024;
  
}






void acilis_animasyonu(){
  
  int a_bekle = 15;
  
  for(int i = 0; i < 7; i++){
    registerWrite(i, HIGH);
    delay(a_bekle);
  }
  
  for(int i = 7; i >= 0; i--){
    registerWrite(i, HIGH);
    delay(a_bekle);
  }
  
  for(int a = 0; a < 1; a++){
    for(int i = 1; i < 7; i++){
      registerWrite(i, HIGH);
      delay(a_bekle);
    }
    
    for(int i = 7; i >= 0; i--){
      registerWrite(i, HIGH);
      delay(a_bekle);
    }
  }
  
  registerWrite(0, LOW);
}






void registerWrite(int whichPin, int whichState) {
  byte bitsToSend = 0;
  digitalWrite(latchPin, LOW);
  bitWrite(bitsToSend, whichPin, whichState);
  shiftOut(dataPin, clockPin, MSBFIRST, bitsToSend);
  digitalWrite(latchPin, HIGH);
}
