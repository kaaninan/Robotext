// TODO
/*
- Motorları ters gimeye ayarlar
- Motor pinlerini gir


/* Program Düzenlemesi
 * 1- Tanımlamalar
 * 2- OSC Event
 * 3- Gonderme Fonksiyonları
 * 4- Gelen Bilgiyi İşleme Fonksiyonları
 * 5- Setup
 * 6- Draw 
*/

import oscP5.*;
import netP5.*;
import processing.serial.*;

Serial serial;
OscP5 oscP5;
import cc.arduino.*;
NetAddress remoteLocation;

color off = color(4, 79, 111);
color on = color(84, 145, 158);

Arduino arduino_uno;
Arduino arduino_mega;


// ## ARDUINO UNO PIN ## //

// PWM
int a_motor_sol_on = 3;
int a_motor_sol_arka = 5;
int a_motor_sag_on = 6;
int a_motor_sag_arka = 9;

// YON
int a_motor_sol_on_d = 2;
int a_motor_sol_arka_d = 4;
int a_motor_sag_on_d = 7;
int a_motor_sag_arka_d = 8;

// ENKODER
int e_motor_sol_on = 0;
int e_motor_sol_arka = 1;
int e_motor_sag_on = 2;
int e_motor_sag_arka = 3;


int led_k_1 = 10;
int led_k_2 = 11;

int led_y_1 = 12;
int led_y_2 = 13;



// ## ARDUINO MEGA PIN ## //

// DIGITAL
int a_kizilotesi_1 = 23;
int a_hareket_1 = 22;
int a_hareket_2 = 31;
int a_hoparlor = 30;

// ANALOG
int a_ses = 0;
int a_uzaklik_on_1 = 1;
int a_uzaklik_on_2 = 2;
int a_uzaklik_sag_1 = 3;
int a_uzaklik_sag_2 = 4;
int a_uzaklik_sol_1 = 5;
int a_uzaklik_sol_2 = 6;

// PWM


String IP = "192.168.42.2";

String s_arduino_uno = "/dev/ttyACM0";
String s_arduino_mega = "/dev/ttyUSB0";



// ## TANIMLAMALAR ## //

float bgcolor;			// Background color
float fgcolor;			// Fill color
float xpos, ypos;	        // Starting position of the ball


// Giriş
int giris = 0;

int devam = 0;
int devam1 = 0;
int devam2 = 0;
int devam3 = 0;
int devam4 = 0;


// Motor
float motor_sol = 0.0f;
float motor_sag = 0.0f;

float motor_ters_sol = 0.0f;
float motor_ters_sag = 0.0f;

float motor_etkin_sol_on = 0.0f;
float motor_etkin_sol_arka = 0.0f;
float motor_etkin_sag_on = 0.0f;
float motor_etkin_sag_arka = 0.0f;

float buzzer = 0.0f;


// #OSC#
String s_motor_sol = "/Motor/sol";
String s_motor_sag = "/Motor/sag";

String s_buzzer = "/Motor/buzzer";

String s_motor_sol_on = "/Motor/etkin_multitoggle/2/1";
String s_motor_sol_arka = "/Motor/etkin_multitoggle/1/1";
String s_motor_sag_on = "/Motor/etkin_multitoggle/2/2";
String s_motor_sag_arka = "/Motor/etkin_multitoggle/1/2";

String s_motor_sol_ters = "/Motor/sol_ters";
String s_motor_sag_ters = "/Motor/sag_ters";



// Hareket
float hareket_etkin = 0;
float hareket_seviye_1 = 0;
float hareket_seviye_2 = 0;
float hareket_alarm = 0;
float hareket_sifirla = 0;


// Sensor
float sensor_uzaklik = 0;
float sensor_isik = 0;
float sensor_yakinlik = 0;
float sensor_hareket = 0;
float sensor_kizilotesi = 0;



// ## OSC ## //

void oscEvent(OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();
  float  val  = theOscMessage.get(0).floatValue();
  
  // Motor
  if(addr.equals(s_motor_sol)){ motor_sol  = val; }
  if(addr.equals(s_motor_sag)){ motor_sag  = val; }
  
  if(addr.equals(s_buzzer)){ buzzer  = val; }
  
  if(addr.equals(s_motor_sol_on)){ motor_etkin_sol_on  = val; }
  if(addr.equals(s_motor_sol_arka)){ motor_etkin_sol_arka  = val; }
  if(addr.equals(s_motor_sag_on)){ motor_etkin_sag_on  = val; }
  if(addr.equals(s_motor_sag_arka)){ motor_etkin_sag_arka  = val; }
  
  if(addr.equals(s_motor_sol_ters)){ motor_ters_sol  = val; }
  if(addr.equals(s_motor_sag_ters)){ motor_ters_sag  = val; }
  
  
  // Hareket
  if(addr.equals("/Hareket/etkin_toggle")){ hareket_etkin  = val; };
  if(addr.equals("/Hareket/seviye_multitoggle/1/1")){ hareket_seviye_1  = val; };
  if(addr.equals("/Hareket/seviye_multitoggle/1/2")){ hareket_seviye_2  = val; };
  if(addr.equals("/Hareket/alarm_push")){ hareket_alarm  = val; };
  if(addr.equals("/Hareket/sifirla_push")){ hareket_sifirla  = val; };
  
  
  // Sensor
  if(addr.equals("/Sensor/uzaklik_toggle")){ sensor_uzaklik  = val; };
  if(addr.equals("/Sensor/isik_toggle")){ sensor_isik  = val; };
  if(addr.equals("/Sensor/yakinlik_toggle")){ sensor_yakinlik  = val; };
  if(addr.equals("/Sensor/hareket_toggle")){ sensor_hareket  = val; };
  if(addr.equals("/Sensor/kizilotesi_toggle")){ sensor_kizilotesi  = val; };
   
  
  // Giris
  if(addr.equals("/Giris/multi/3/1")){ // Üçüncü
    if(devam == 1){
      if(devam1 == 1){
        devam2 = 1;
        devam3 = 0;
        devam4 = 0;
        giris = 0;
      }
    }
  }
  if(addr.equals("/Giris/multi/3/2")){ // İkinci
    if(devam == 1){
      devam1 = 1;
      devam2 = 0;
      devam3 = 0;
      devam4 = 0;
      giris = 0;
    }
  }
  if(addr.equals("/Giris/multi/3/3")){ // Birinci
    devam = 1;
    devam1 = 0;
    devam2 = 0;
    devam3 = 0;
    devam4 = 0;
    giris = 0;
  }
  if(addr.equals("/Giris/multi/2/1")){ // Dördüncü
    if(devam == 1){
      if(devam1 == 1){
        if(devam2 == 1){
          if(devam3 == 0){
            devam3 = 1;
            devam4 = 0;
          }
        }
      }
    }else{
      giris = 0;
    }
  }
  if(addr.equals("/Giris/multi/2/2")){ // Beşinci
    if(devam == 1){
      if(devam1 == 1){
        if(devam2 == 1){
          if(devam3 == 1){
            if(devam4 == 0){
              devam4 = 1;
            }
          }
        }
      }
    }
  }
  if(addr.equals("/Giris/multi/2/3")){
    devam = 0;
    giris = 0;
  }
  if(addr.equals("/Giris/multi/1/1")){
    devam = 0;
    giris = 0;
  }
  if(addr.equals("/Giris/multi/1/2")){
    devam = 0;
    giris = 0;
  }
  if(addr.equals("/Giris/multi/1/3")){
    devam = 0;
    giris = 0;
  }
  
  
  if(addr.equals("/Giris/buton")){
    if(val == 1){
      if(devam == 1){
        if(devam1 == 1){
          if(devam2 == 1){
            if(devam3 == 1){
              if(devam4 == 1){
                println("Giriş Başarılı");
                giris = 1;
              }
            }
          }
        }
      }
    }
  }
}









// ## TELEFONA GONDER ## / (Arduino'dan Geleni Yollama)


// Uzaklık
void gonder_uzaklik(String sol, String on, String sag){
  
  OscMessage msg_sol = new OscMessage("/Uzaklik/sol_olcum");
  OscMessage msg_on = new OscMessage("/Uzaklik/on_olcum");
  OscMessage msg_sag = new OscMessage("/Uzaklik/sag_olcum");
  
  msg_sol.add(sol);
  msg_on.add(on +" cm");
  msg_sag.add(sag +" cm");
  
  oscP5.send(msg_sol, remoteLocation);
  oscP5.send(msg_on, remoteLocation);
  oscP5.send(msg_sag, remoteLocation);
  
  // TODO KONTROL
  
  OscMessage msg_sol_l = new OscMessage("/Uzaklik/sol_led");
  OscMessage msg_on_l = new OscMessage("/Uzaklik/on_led");
  OscMessage msg_sag_l = new OscMessage("/Uzaklik/sag_led");
  
  msg_on_l.add(0);
  msg_sag_l.add(0);
  
  oscP5.send(msg_sol_l, remoteLocation);
  oscP5.send(msg_on_l, remoteLocation);
  oscP5.send(msg_sag_l, remoteLocation);
}

void gonder_uzaklik_sifirla(){ 
  
  OscMessage msg_sol = new OscMessage("/Uzaklik/sol_olcum");
  OscMessage msg_on = new OscMessage("/Uzaklik/on_olcum");
  OscMessage msg_sag = new OscMessage("/Uzaklik/sag_olcum");
  
  msg_sol.add(0 +" cm");
  msg_on.add(0 +" cm");
  msg_sag.add(0 +" cm");
  
  oscP5.send(msg_sol, remoteLocation);
  oscP5.send(msg_on, remoteLocation);
  oscP5.send(msg_sag, remoteLocation);
  
  
  OscMessage msg_sol_l = new OscMessage("/Uzaklik/sol_led");
  OscMessage msg_on_l = new OscMessage("/Uzaklik/on_led");
  OscMessage msg_sag_l = new OscMessage("/Uzaklik/sag_led");
  
  msg_sol_l.add(0);
  msg_on_l.add(0);
  msg_sag_l.add(0);
  
  oscP5.send(msg_sol_l, remoteLocation);
  oscP5.send(msg_on_l, remoteLocation);
  oscP5.send(msg_sag_l, remoteLocation);
}



// Işık

void gonder_isik(int ust, int alt){
  
  OscMessage msg_ust = new OscMessage("/Isik/ust_olcum");
  OscMessage msg_alt = new OscMessage("/Isik/alt_olcum");
  
  msg_ust.add(ust);
  msg_alt.add(alt);
  
  oscP5.send(msg_ust, remoteLocation);
  oscP5.send(msg_alt, remoteLocation);
  
  if(ust < 150){
    OscMessage msg_ust_yetersiz = new OscMessage("/Isik/ust_yetersiz");
    msg_ust_yetersiz.add("Yetersiz");
    oscP5.send(msg_ust_yetersiz, remoteLocation);
  }else{
    OscMessage msg_ust_yetersiz = new OscMessage("/Isik/ust_yetersiz");
    msg_ust_yetersiz.add("");
    oscP5.send(msg_ust_yetersiz, remoteLocation);
  }
  
  if(alt < 40){
    OscMessage msg_alt_yetersiz = new OscMessage("/Isik/alt_yetersiz");
    msg_alt_yetersiz.add("Yetersiz");
    oscP5.send(msg_alt_yetersiz, remoteLocation);
  }else{
    OscMessage msg_alt_yetersiz = new OscMessage("/Isik/alt_yetersiz");
    msg_alt_yetersiz.add("");
    oscP5.send(msg_alt_yetersiz, remoteLocation);
  }
  
}

void gonder_isik_sifirla(){
  
  int olcum = 0;
  int olcum2 = 0;
  
  OscMessage msg_ust = new OscMessage("/Isik/ust_olcum");
  OscMessage msg_alt = new OscMessage("/Isik/alt_olcum");
  
  msg_ust.add(olcum);
  msg_alt.add(olcum2);
  
  oscP5.send(msg_ust, remoteLocation);
  oscP5.send(msg_alt, remoteLocation);

  OscMessage msg_ust_yetersiz = new OscMessage("/Isik/ust_yetersiz");
  msg_ust_yetersiz.add("");
  oscP5.send(msg_ust_yetersiz, remoteLocation);
  
}



// Hareket

int a = 0;
int sayi;
int hareket;
void gonder_hareket(boolean sayi2, boolean hareket2){
  
  if(hareket_sifirla == 1){
    sayi = 0;
    hareket = 0; 
  }
  
  if(sayi2 == true)
    sayi++;
    
  if(hareket2 == true)
    hareket = 1;
  else
    hareket = 0;
  
  OscMessage msg_led = new OscMessage("/Hareket/hareket_led");
  OscMessage msg_olcum = new OscMessage("/Hareket/sayi_olcum");
  
  msg_led.add(hareket);
  msg_olcum.add(sayi);
  
  oscP5.send(msg_led, remoteLocation);
  oscP5.send(msg_olcum, remoteLocation);
  
}

void gonder_hareket_sifirla(){
  
  OscMessage msg_led = new OscMessage("/Hareket/hareket_led");
  OscMessage msg_olcum = new OscMessage("/Hareket/sayi_olcum");
  
  OscMessage msg_toggle = new OscMessage("/Hareket/etkin_toggle");
  
  msg_led.add(0);
  msg_olcum.add(0);
  msg_toggle.add(0);
  
  oscP5.send(msg_led, remoteLocation);
  oscP5.send(msg_olcum, remoteLocation);
  oscP5.send(msg_toggle, remoteLocation);
  
}



// Yakınlık

void gonder_yakinlik(int yakin){
  
  OscMessage msg_olcum = new OscMessage("/Yakinlik/yakinlik_olcum");
  
  msg_olcum.add(yakin);
  
  oscP5.send(msg_olcum, remoteLocation);
  
  if(yakin < 150){
    OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
    msg_yerde.add("Yerde  Degil");
    oscP5.send(msg_yerde, remoteLocation);
  }else{
    OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
    msg_yerde.add("");
    oscP5.send(msg_yerde, remoteLocation);
  }
  
}

void gonder_yakinlik_sifirla(){
  
  int sayi = 0;
  
  OscMessage msg_olcum = new OscMessage("/Yakinlik/yakinlik_olcum");
  msg_olcum.add(sayi);
  oscP5.send(msg_olcum, remoteLocation);
  
  OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
  msg_yerde.add("");
  oscP5.send(msg_yerde, remoteLocation);

}



// Voltaj

void gonder_voltaj(float voltaj, float voltaj_uzaklik, float voltaj_yakinlik, float voltaj_isik, float voltaj_kizilotesi, float voltaj_hareket, float voltaj_besleme){
  
  
  OscMessage msg = new OscMessage("/Voltaj/ana_voltaj"); 
  
  OscMessage msg_1 = new OscMessage("/Voltaj/uzaklik");
  OscMessage msg_2 = new OscMessage("/Voltaj/yakinlik");
  OscMessage msg_3 = new OscMessage("/Voltaj/isik");
  OscMessage msg_4 = new OscMessage("/Voltaj/kizilotesi");
  OscMessage msg_5 = new OscMessage("/Voltaj/hareket");
  OscMessage msg_6 = new OscMessage("/Voltaj/besleme");
  
  
  msg_1.add(voltaj_uzaklik);
  msg_2.add(voltaj_yakinlik);
  msg_3.add(voltaj_isik);
  msg_4.add(voltaj_kizilotesi);
  msg_5.add(voltaj_hareket);
  msg_6.add(voltaj_besleme);
  
  msg.add(voltaj);
  
  oscP5.send(msg, remoteLocation);
  
  oscP5.send(msg_1, remoteLocation);
  oscP5.send(msg_2, remoteLocation);
  oscP5.send(msg_3, remoteLocation);
  oscP5.send(msg_4, remoteLocation);
  oscP5.send(msg_5, remoteLocation);
  oscP5.send(msg_6, remoteLocation);
  
  /*
  if(sayi < 150){
    OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
    msg_yerde.add("Yerde  Degil");
    oscP5.send(msg_yerde, remoteLocation);
  }else{
    OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
    msg_yerde.add("");
    oscP5.send(msg_yerde, remoteLocation);
  }
  */
}

void gonder_voltaj_sifirla(){
  
  OscMessage msg = new OscMessage("/Voltaj/ana_voltaj"); 
  
  OscMessage msg_1 = new OscMessage("/Voltaj/uzaklik");
  OscMessage msg_2 = new OscMessage("/Voltaj/yakinlik");
  OscMessage msg_3 = new OscMessage("/Voltaj/isik");
  OscMessage msg_4 = new OscMessage("/Voltaj/kizilotesi");
  OscMessage msg_5 = new OscMessage("/Voltaj/hareket");
  OscMessage msg_6 = new OscMessage("/Voltaj/besleme");
  
  
  msg_1.add(0);
  msg_2.add(0);
  msg_3.add(0);
  msg_4.add(0);
  msg_5.add(0);
  msg_6.add(0);
  
  msg.add(0);
  
  oscP5.send(msg, remoteLocation);
  
  oscP5.send(msg_1, remoteLocation);
  oscP5.send(msg_2, remoteLocation);
  oscP5.send(msg_3, remoteLocation);
  oscP5.send(msg_4, remoteLocation);
  oscP5.send(msg_5, remoteLocation);
  oscP5.send(msg_6, remoteLocation);
}







// ## SIFIRLAMA ## // (Sadece Arduino'ya gidenler için)

void sifirla_motor(){
  
  OscMessage msg_1 = new OscMessage(s_motor_sol);
  OscMessage msg_2 = new OscMessage(s_motor_sag);

  OscMessage msg_3 = new OscMessage(s_motor_sol_on);
  OscMessage msg_4 = new OscMessage(s_motor_sol_arka);
  OscMessage msg_5 = new OscMessage(s_motor_sag_on);
  OscMessage msg_6 = new OscMessage(s_motor_sag_arka);
  
  OscMessage msg_7 = new OscMessage(s_motor_sol_ters);
  OscMessage msg_8 = new OscMessage(s_motor_sag_ters);


  msg_1.add(0);
  msg_2.add(0);
  msg_3.add(0);
  msg_4.add(0);
  msg_5.add(0);
  msg_6.add(0);
  msg_7.add(0);
  msg_8.add(0);
  
  oscP5.send(msg_1, remoteLocation);
  oscP5.send(msg_2, remoteLocation);
  oscP5.send(msg_3, remoteLocation);
  oscP5.send(msg_4, remoteLocation);
  oscP5.send(msg_5, remoteLocation);
  oscP5.send(msg_6, remoteLocation);
  oscP5.send(msg_7, remoteLocation);
  oscP5.send(msg_8, remoteLocation);

}








// ## Arduino'ya Gönderme ## //


// Giris

void gonder_giris(){
  
  String basarili = "Giris Yapildi";
  String isim = "ROBOTEXT PLATFORM";
  String hata = "Lutfen Giris Yapin";
  
  OscMessage msg_basarili = new OscMessage("/Giris/basarili");
  OscMessage msg_isim = new OscMessage("/Giris/isim");
  OscMessage msg_basarisiz = new OscMessage("/Giris/basarisiz");
  
  if(giris == 1){
    msg_basarili.add(basarili);
    msg_isim.add(isim);
    msg_basarisiz.add("");
  }else{
    msg_basarili.add("");
    msg_isim.add("");
    msg_basarisiz.add(hata);
  }
  
  oscP5.send(msg_basarili, remoteLocation);
  oscP5.send(msg_isim, remoteLocation);
  oscP5.send(msg_basarisiz, remoteLocation);
  
}

// Motor

// Uzaklık

// Hareket

// Sensor



// ## ARDUINO SENSOR OKUMA ## //
int[] oku_uzaklik(){

  int[] degerler = new int[3];
  
  degerler[0] = 12;
  degerler[1] = 12212;
  degerler[2] = 2121;
  
  return degerler;
  
}




void setup() {
  size(320,360);
  frameRate(25);
  
  println(Arduino.list());
  arduino_uno = new Arduino(this, s_arduino_uno, 57600);
  arduino_mega = new Arduino(this, s_arduino_mega, 57600);
  
  remoteLocation = new NetAddress(IP, 9000);
  oscP5 = new OscP5(this,8000);
  
  // ARDUINO UNO PIN MODE
  
  arduino_uno.pinMode(a_motor_sol_on, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sol_arka, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sag_on, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sag_arka, Arduino.OUTPUT);
  
  arduino_uno.pinMode(a_motor_sol_on_d, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sol_arka_d, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sag_on_d, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sag_arka_d, Arduino.OUTPUT);
    
  arduino_uno.pinMode(led_k_1, Arduino.OUTPUT);
  arduino_uno.pinMode(led_k_2, Arduino.OUTPUT);
  arduino_uno.pinMode(led_y_1, Arduino.OUTPUT);
  arduino_uno.pinMode(led_y_2, Arduino.OUTPUT);
  
}



// ####### KONTROL ####### //
void motor_kontrol(){
  
  if(motor_ters_sol == 1){
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.HIGH);
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.HIGH);
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.LOW);
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.LOW);
  }else{
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.LOW);
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.LOW);
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.HIGH);
    arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.HIGH);
  }
  
  if(motor_ters_sag == 1){
    // SAG TARAF
  }
  
  
  arduino_uno.analogWrite(a_motor_sag_on, int(motor_sag));
  arduino_uno.analogWrite(a_motor_sag_arka, int(motor_sag));
  arduino_uno.analogWrite(a_motor_sol_on, int(motor_sol));
  arduino_uno.analogWrite(a_motor_sol_arka, int(motor_sol));
  
  // LED
  
  if(int(motor_sag) == 0 && int(motor_sol) == 0){
    arduino_uno.digitalWrite(led_k_1, Arduino.HIGH);
    arduino_uno.digitalWrite(led_k_2, Arduino.HIGH);
    arduino_uno.digitalWrite(led_y_1, Arduino.LOW);
    arduino_uno.digitalWrite(led_y_2, Arduino.LOW);
  }else{
    arduino_uno.digitalWrite(led_k_1, Arduino.LOW);
    arduino_uno.digitalWrite(led_k_2, Arduino.LOW);
    arduino_uno.digitalWrite(led_y_1, Arduino.HIGH);
    arduino_uno.digitalWrite(led_y_2, Arduino.HIGH);
  }
  
}






String val;
int b = 1; // Hareket için

void draw() {
  
  gonder_giris();
  
  if(giris == 0){ // Giriş yapılmadıysa
    
    gonder_uzaklik_sifirla();
    gonder_isik_sifirla();
    gonder_hareket_sifirla();
    gonder_yakinlik_sifirla();
    gonder_voltaj_sifirla();
    
    sifirla_motor();
    
    
  }else{
    
    motor_kontrol();
    
  }
  
}
