#include <IRremote.h>
#include <LiquidCrystal.h>

int pin_voltaj = 0;
int ir_pin = 6;
int buzzer = 12;
int uyari_led = 13;
IRrecv irrecv(ir_pin);
decode_results results;

LiquidCrystal lcd(5, 4, 3, 2, 1, 0);


float voltaj = 0;

#define CH1 0xFFA25D 
#define CH 0xFF629D
#define CH2 0xFFE21D 
#define PREV 0xFF22DD 
#define NEXT 0xFF02FD 
#define PLAYPAUSE 0xFFC23D 
#define VOL1 0xFFE01F 
#define VOL2 0xFFA857 
#define EQ 0xFF906F
#define BUTON0 0xFF6897 
#define BUTON100 0xFF9867 
#define BUTON200 0xFFB04F 
#define BUTON1 0xFF30CF 
#define BUTON2 0xFF18E7 
#define BUTON3 0xFF7A85 
#define BUTON4 0xFF10EF 
#define BUTON5 0xFF38C7
#define BUTON6 0xFF5AA5 
#define BUTON7 0xFF42BD 
#define BUTON8 0xFF4AB5 
#define BUTON9 0xFF52AD

void setup() {
  pinMode(ir_pin, INPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(uyari_led, OUTPUT);
  irrecv.enableIRIn(); 
  
  lcd.begin(16, 2);
  lcd.print("Kaan INAN :)");
}

void loop() {

  if (irrecv.decode(&results)) {
    
    Serial.println(results.value);
    
    if (results.value == CH1) {
    }
    if (results.value == CH){
    }
    if (results.value == CH2){
    }
    if (results.value == PREV){
    }
    if (results.value == NEXT){
    }
    if (results.value == PLAYPAUSE){
    }
    if (results.value == VOL1){
    }
    if (results.value == VOL2){
    }
    if (results.value == EQ) {
    }
    if (results.value == BUTON0) {
    }
    if (results.value == BUTON100) {
    }
    if (results.value == BUTON200) {
    }
    if (results.value == BUTON1) {
    }
    if (results.value == BUTON2) {
    }
    if (results.value == BUTON3){
    }
    if (results.value == BUTON4){
    }
    if (results.value == BUTON5){
    }
    if (results.value == BUTON6){
    }
    if (results.value == BUTON7){
    }
    if (results.value == BUTON8){ 
    }
    if (results.value == BUTON9){ 
    }

    irrecv.resume();
  }
  
  lcd.setCursor(0, 1);
  lcd.print(millis()/1000);
  
  
  
  
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
  
}

 
