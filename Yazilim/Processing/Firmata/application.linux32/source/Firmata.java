import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import processing.serial.*; 
import cc.arduino.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Firmata extends PApplet {

// TODO
/*
- Motorlar\u0131 ters gimeye ayarlar
- Motor pinlerini gir


/* Program D\u00fczenlemesi
 * 1- Tan\u0131mlamalar
 * 2- OSC Event
 * 3- Gonderme Fonksiyonlar\u0131
 * 4- Gelen Bilgiyi \u0130\u015fleme Fonksiyonlar\u0131
 * 5- Setup
 * 6- Draw 
*/





Serial serial;
OscP5 oscP5;

NetAddress remoteLocation;

int off = color(4, 79, 111);
int on = color(84, 145, 158);

Arduino arduino_uno;
Arduino arduino_mega;


// ## ARDUINO UNO P\u0130N ## //
int a_motor_sol_on = 6;
int a_motor_sol_arka = 9;
int a_motor_sag_on = 10;
int a_motor_sag_arka = 11;

int a_motor_sol_on_d = 23;
int a_motor_sol_arka_d = 23;
int a_motor_sag_on_d = 23;
int a_motor_sag_arka_d = 23;

int led_k_1 = 12;
int led_k_2 = 14;

int led_y_1 = 13;
int led_y_2 = 15;




String IP = "192.168.42.2";

String s_arduino_uno = "/dev/ttyACM0";
String s_arduino_mega = "/dev/ttyUSB0";



// ## TANIMLAMALAR ## //

float bgcolor;			// Background color
float fgcolor;			// Fill color
float xpos, ypos;	        // Starting position of the ball


// Giri\u015f
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

public void oscEvent(OscMessage theOscMessage) {

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
  if(addr.equals("/Giris/multi/3/1")){ // \u00dc\u00e7\u00fcnc\u00fc
    if(devam == 1){
      if(devam1 == 1){
        devam2 = 1;
        devam3 = 0;
        devam4 = 0;
        giris = 0;
      }
    }
  }
  if(addr.equals("/Giris/multi/3/2")){ // \u0130kinci
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
  if(addr.equals("/Giris/multi/2/1")){ // D\u00f6rd\u00fcnc\u00fc
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
  if(addr.equals("/Giris/multi/2/2")){ // Be\u015finci
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
                println("Giri\u015f Ba\u015far\u0131l\u0131");
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


// Uzakl\u0131k
public void gonder_uzaklik(String sol, String on, String sag){
  
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

public void gonder_uzaklik_sifirla(){ 
  
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



// I\u015f\u0131k

public void gonder_isik(int ust, int alt){
  
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

public void gonder_isik_sifirla(){
  
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
public void gonder_hareket(boolean sayi2, boolean hareket2){
  
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

public void gonder_hareket_sifirla(){
  
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



// Yak\u0131nl\u0131k

public void gonder_yakinlik(int yakin){
  
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

public void gonder_yakinlik_sifirla(){
  
  int sayi = 0;
  
  OscMessage msg_olcum = new OscMessage("/Yakinlik/yakinlik_olcum");
  msg_olcum.add(sayi);
  oscP5.send(msg_olcum, remoteLocation);
  
  OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
  msg_yerde.add("");
  oscP5.send(msg_yerde, remoteLocation);

}



// Voltaj

public void gonder_voltaj(float voltaj, float voltaj_uzaklik, float voltaj_yakinlik, float voltaj_isik, float voltaj_kizilotesi, float voltaj_hareket, float voltaj_besleme){
  
  
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

public void gonder_voltaj_sifirla(){
  
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







// ## SIFIRLAMA ## // (Sadece Arduino'ya gidenler i\u00e7in)

public void sifirla_motor(){
  
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








// ## Arduino'ya G\u00f6nderme ## //


// Giris

public void gonder_giris(){
  
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

// Uzakl\u0131k

// Hareket

// Sensor



// ## ARDUINO SENSOR OKUMA ## //
public int[] oku_uzaklik(){

  int[] degerler = new int[3];
  
  degerler[0] = 12;
  degerler[1] = 12212;
  degerler[2] = 2121;
  
  return degerler;
  
}




public void setup() {
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
public void motor_kontrol(){
  
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
  
  
  arduino_uno.analogWrite(a_motor_sag_on, PApplet.parseInt(motor_sag));
  arduino_uno.analogWrite(a_motor_sag_arka, PApplet.parseInt(motor_sag));
  arduino_uno.analogWrite(a_motor_sol_on, PApplet.parseInt(motor_sol));
  arduino_uno.analogWrite(a_motor_sol_arka, PApplet.parseInt(motor_sol));
  
  // LED
  
  if(PApplet.parseInt(motor_sag) == 0 && PApplet.parseInt(motor_sol) == 0){
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
int b = 1; // Hareket i\u00e7in

public void draw() {
  
  gonder_giris();
  
  if(giris == 0){ // Giri\u015f yap\u0131lmad\u0131ysa
    
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Firmata" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
