// KABLO
// Mavi: 8
// Beyaz: 11

int latchPin = 8;
int clockPin = 12;
int dataPin = 11;
 
void setup() {
   pinMode(latchPin, OUTPUT);
   pinMode(clockPin, OUTPUT);
   pinMode(dataPin, OUTPUT);
}
 
void loop() {
  segment(6);
  delay(200);
  segment(1);
  delay(200);
}

void segment(int sayi){
  int s_deger;
  
  if(sayi == 0){ s_deger = 16; }
  if(sayi == 1){ s_deger = 17; }
  if(sayi == 2){ s_deger = 4; }
  if(sayi == 3){ s_deger = 5; }
  if(sayi == 4){ s_deger = 8; }
  if(sayi == 5){ s_deger = 9; }
  if(sayi == 6){ s_deger = 12; }
  if(sayi == 7){ s_deger = 13; }
  if(sayi == 8){ s_deger = 2; }
  if(sayi == 9){ s_deger = 5; }
  
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, s_deger);
  digitalWrite(latchPin, HIGH);
}
