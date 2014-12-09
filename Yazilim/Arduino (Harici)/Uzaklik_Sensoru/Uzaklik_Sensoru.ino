// TODO
// Sıcaklık ayarlaması

long on_deger = 0;
long sag_deger = 0;
long sol_deger = 0;

long on_deger_1 = 0;
long on_deger_2 = 0;
long sag_deger_1 = 0;
long sag_deger_2 = 0;
long sol_deger_1 = 0;
long sol_deger_2 = 0;

int sicaklik = 26;

// ON
int t_1 = 0;
int e_1 = 1;

// SAG
int t_2 = 2;
int e_2 = 4;

// SOL
int t_3 = 7;
int e_3 = 8;


// CIKIS
int on_1 = 3;
int on_2 = 5;

int sag_1 = 6;
int sag_2 = 9;

int sol_1 = 10;
int sol_2 = 11;


void setup() {
  pinMode(t_1, OUTPUT);
  pinMode(e_1, INPUT);
  
  pinMode(t_2, OUTPUT);
  pinMode(e_2, INPUT);
  
  pinMode(t_3, OUTPUT);
  pinMode(e_3, INPUT);
  
  pinMode(on_1, OUTPUT);
  pinMode(on_2, OUTPUT);
  pinMode(sag_1, OUTPUT);
  pinMode(sag_2, OUTPUT);
  pinMode(sol_1, OUTPUT);
  pinMode(sol_2, OUTPUT);
}

void loop() {
  
  // ON
  digitalWrite(t_1, LOW);
  digitalWrite(t_1, HIGH);
  digitalWrite(t_1, LOW);
  
  on_deger = (pulseIn(e_1, HIGH))/sicaklik/2;
  
  // SAG
  digitalWrite(t_2, LOW);
  digitalWrite(t_2, HIGH);
  digitalWrite(t_2, LOW);
  
  sag_deger = (pulseIn(e_2, HIGH))/sicaklik/2;
  
  // SOL
  digitalWrite(t_3, LOW);
  digitalWrite(t_3, HIGH);
  digitalWrite(t_3, LOW);
  
  sol_deger = (pulseIn(e_3, HIGH))/sicaklik/2;
  
  
  // DEGER HAZIRLAMA
  
  if(on_deger < 256){
    on_deger_1 = on_deger;
    on_deger_2 = 0;
  }else{
    on_deger_1 = 255;
    on_deger_2 = on_deger - 255;
  }
  
  if(sag_deger < 256){
    sag_deger_1 = sag_deger;
    sag_deger_2 = 0;
  }else{
    sag_deger_1 = 255;
    sag_deger_2 = sag_deger - 255;
  }
  
  if(sol_deger < 256){
    sol_deger_1 = sol_deger;
    sol_deger_2 = 0;
  }else{
    sol_deger_1 = 255;
    sol_deger_2 = sol_deger - 255;
  }
  
  
  // CIKTI
  
  analogWrite(on_1, on_deger_1);
  analogWrite(on_2, on_deger_2);
  
  analogWrite(sag_1, sag_deger_1);
  analogWrite(sag_2, sag_deger_2);
  
  analogWrite(sol_1, sol_deger_1);
  analogWrite(sol_2, sol_deger_2);
  
  delay(50); // TEST
  
}
