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

/* Program D\u00fczenlemesi

  A- TANIMLAMALAR 
    1- Arduino Uno Pin Tan\u0131mlama
    2- Arduino Mega Pin Tan\u0131mlama 
    3- Open Sound Control Tan\u0131mlama
    4- Processing Tan\u0131mlama
    
  B- OPEN SOUND CONTROL
    1- Gelen Veri
    2- Giden Veri
    3- S\u0131f\u0131rlamalar
  
  C- ARDUINO
    1- Arduino'ya Manual Veri G\u00f6nderme
    2- Arduino'dan Gelen Veri
  
  D- SETUP
    1- Arduino pinMode()
    2- Serial Ba\u015flatma
  
  E- DRAW
    1- G\u00fcvenlik Kontrol\u00fc

*/


//String IP = "192.168.42.4";
String IP = "192.168.1.23";

String s_arduino_uno = "/dev/ttyACM0";
String s_arduino_mega = "/dev/ttyUSB0";







OscP5 oscP5;

NetAddress remoteLocation;

Arduino arduino_uno;
Arduino arduino_mega;


// ### ARDUINO PIN ### //

  // ## UNO ## //
  
  // PWM
  int a_motor_sol_on = 3;
  int a_motor_sol_arka = 5;
  int a_motor_sag_on = 6;
  int a_motor_sag_arka = 9;
  
  // DIGITAL
  int a_motor_sol_on_d = 2;
  int a_motor_sol_arka_d = 4;
  int a_motor_sag_on_d = 7;
  int a_motor_sag_arka_d = 8;
  
  int a_led_k_1 = 10;
  int a_led_k_2 = 11;
  
  int a_led_y_1 = 12;
  int a_led_y_2 = 13;
  
  // ANALOG
  int a_motor_sol_on_e = 0;
  int a_motor_sol_arka_e = 1;
  int a_motor_sag_on_e = 2;
  int a_motor_sag_arka_e = 3;
  
  
  
  
  // ## MEGA ## //
  
  // PWM
  int a_uzaklik_sicaklik = 2;
  int a_ekran = 3;
  
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
  
  



// ### OPEN SOUND CONTROL ### //
  
  // 2. SAYFA
  
  String ikinci_sayfa = "/Motor/";
  
  String s_motor_sol = ikinci_sayfa+"sol";
  String s_motor_sag = ikinci_sayfa+"sag";
  
  String s_motor_sol_ters = ikinci_sayfa+"sol_ters";
  String s_motor_sag_ters = ikinci_sayfa+"sag_ters";
  
  String s_motor_sol_on = ikinci_sayfa+"etkin_multitoggle/2/1";
  String s_motor_sol_arka = ikinci_sayfa+"etkin_multitoggle/1/1";
  String s_motor_sag_on = ikinci_sayfa+"etkin_multitoggle/2/2";
  String s_motor_sag_arka = ikinci_sayfa+"etkin_multitoggle/1/2";
  
  String s_buzzer = ikinci_sayfa+"buzzer";
  
  String s_led_1 = ikinci_sayfa+"multi_led/1/1";
  String s_led_2 = ikinci_sayfa+"multi_led/1/2";
  String s_led_3 = ikinci_sayfa+"multi_led/1/3";
  String s_led_4 = ikinci_sayfa+"multi_led/1/4";
  
  String s_servo_1 = ikinci_sayfa+"servo_1";
  String s_servo_2 = ikinci_sayfa+"servo_2";
  
  String s_uzaklik_on = ikinci_sayfa+"uzaklik_on";
  String s_uzaklik_sag = ikinci_sayfa+"uzaklik_sag";
  String s_uzaklik_sol = ikinci_sayfa+"uzaklik_sol";





// ### PROCESSING ### //

  // G\u0130R\u0130\u015e EKRANI
  
  int giris = 0;
  
  int devam = 0;
  int devam1 = 0;
  int devam2 = 0;
  int devam3 = 0;
  int devam4 = 0;
  
  
  // MOTOR
  
  float motor_sol = 0.0f;
  float motor_sag = 0.0f;
  
  float motor_sol_ters = 0.0f;
  float motor_sag_ters = 0.0f;
  
  float motor_etkin_sol_on = 0.0f;
  float motor_etkin_sol_arka = 0.0f;
  float motor_etkin_sag_on = 0.0f;
  float motor_etkin_sag_arka = 0.0f;
  
  float buzzer = 0.0f;
  
  float servo_1 = 0.0f;
  float servo_2 = 0.0f;
  
  float led_1 = 0.0f;
  float led_2 = 0.0f;
  float led_3 = 0.0f;
  float led_4 = 0.0f;
  
  
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






// ## GELEN OSC ## //

public void oscEvent(OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();
  float  val  = theOscMessage.get(0).floatValue();
  
  // 2. SAYFA
  
  if(addr.equals(s_motor_sol)){ motor_sol  = val; }
  if(addr.equals(s_motor_sag)){ motor_sag  = val; }
  
  if(addr.equals(s_motor_sol_ters)){ motor_sol_ters  = val; }
  if(addr.equals(s_motor_sag_ters)){ motor_sag_ters  = val; }
  
  if(addr.equals(s_motor_sol_on)){ motor_etkin_sol_on  = val; }
  if(addr.equals(s_motor_sol_arka)){ motor_etkin_sol_arka  = val; }
  if(addr.equals(s_motor_sag_on)){ motor_etkin_sag_on  = val; }
  if(addr.equals(s_motor_sag_arka)){ motor_etkin_sag_arka  = val; }
  
  if(addr.equals(s_buzzer)){ buzzer  = val; }
  
  if(addr.equals(s_servo_1)){ servo_1  = val; }
  if(addr.equals(s_servo_2)){ servo_2  = val; }
  
  if(addr.equals(s_led_1)){ led_1  = val; }
  if(addr.equals(s_led_2)){ led_2  = val; }
  if(addr.equals(s_led_3)){ led_3  = val; }
  if(addr.equals(s_led_4)){ led_4  = val; }
  
  
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
   
  
  
  // G\u0130R\u0130\u015e
  
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










// ### GIDEN OSC ### //


  // UZAKLIK
  
  public void gonder_uzaklik(String sol, String on, String sag){
    
    OscMessage msg_on = new OscMessage(s_uzaklik_on);
    OscMessage msg_sag = new OscMessage(s_uzaklik_sag);
    OscMessage msg_sol = new OscMessage(s_uzaklik_sol);
    
    msg_on.add(on +" cm");
    msg_sag.add(sag +" cm");
    msg_sol.add(sol +" cm");
    
    
    oscP5.send(msg_on, remoteLocation);
    oscP5.send(msg_sag, remoteLocation);
    oscP5.send(msg_sol, remoteLocation);
    
  }

  public void gonder_uzaklik_sifirla(){ 
    
    OscMessage msg_on = new OscMessage(s_uzaklik_on);
    OscMessage msg_sag = new OscMessage(s_uzaklik_sag);
    OscMessage msg_sol = new OscMessage(s_uzaklik_sol);
    
    msg_on.add("0");
    msg_sag.add("0");
    msg_sol.add("0");
    
    
    oscP5.send(msg_on, remoteLocation);
    oscP5.send(msg_sag, remoteLocation);
    oscP5.send(msg_sol, remoteLocation);
  }



  // ISIK
  
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
  
  
  
  // HAREKET
  
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
  
  
  
  // YAKINLIK
  
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
  
  
  
  // VOLTAJ
  
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


  // GIRIS
  
  public void gonder_giris(){
    
    String basarili = "Giris Yapildi";
    String isim = "ROBOTEXT";
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







// ## SIFIRLAMA ## // (Sadece Arduino'ya gidenler i\u00e7in)

  // 2. SAYFA - MOTOR

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








// ## ARDUINO'YA GONDERME ## // (MANUAL)
  
  
  // MOTOR
  
  public void motor_kontrol(){
    
    println("MOTOR:: SOL: "+PApplet.parseInt(motor_sol)+" SAG: "+PApplet.parseInt(motor_sag)+"    YON:: SOL: "+PApplet.parseInt(motor_sol_ters)+" SAG: "+PApplet.parseInt(motor_sag_ters)+"    ETKIN:: "+PApplet.parseInt(motor_etkin_sol_on)+","+PApplet.parseInt(motor_etkin_sol_arka)+","+PApplet.parseInt(motor_etkin_sag_on)+","+PApplet.parseInt(motor_etkin_sag_arka)+"     BUZZER:: "+PApplet.parseInt(buzzer));
    
    
    if(PApplet.parseInt(motor_etkin_sol_on) == 1)
      arduino_uno.analogWrite(a_motor_sol_on, PApplet.parseInt(motor_sol));
    else
      arduino_uno.analogWrite(a_motor_sol_on, 0);
      
    if(PApplet.parseInt(motor_etkin_sol_arka) == 1)
      arduino_uno.analogWrite(a_motor_sol_arka, PApplet.parseInt(motor_sol));
    else
      arduino_uno.analogWrite(a_motor_sol_arka, 0);
      
      
     
    if(PApplet.parseInt(motor_etkin_sag_on) == 1)
      arduino_uno.analogWrite(a_motor_sag_on, PApplet.parseInt(motor_sag));
    else
      arduino_uno.analogWrite(a_motor_sag_on, 0);
      
    if(PApplet.parseInt(motor_etkin_sag_arka) == 1)
      arduino_uno.analogWrite(a_motor_sag_arka, PApplet.parseInt(motor_sag));
    else
      arduino_uno.analogWrite(a_motor_sag_arka, 0);
      
    
    
    
    if(PApplet.parseInt(motor_sol_ters) == 1){
      arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.LOW);
      arduino_uno.digitalWrite(a_motor_sol_arka_d, Arduino.LOW);
    }else{
      arduino_uno.digitalWrite(a_motor_sol_on_d, Arduino.HIGH);
      arduino_uno.digitalWrite(a_motor_sol_arka_d, Arduino.HIGH);
    }
    
    
    if(PApplet.parseInt(motor_sag_ters) == 1){
      arduino_uno.digitalWrite(a_motor_sag_on_d, Arduino.LOW);
      arduino_uno.digitalWrite(a_motor_sag_arka_d, Arduino.LOW);
    }else{
      arduino_uno.digitalWrite(a_motor_sag_on_d, Arduino.HIGH);
      arduino_uno.digitalWrite(a_motor_sag_arka_d, Arduino.HIGH);
    }
    
    
    // LED
    
    if(PApplet.parseInt(motor_sag) == 0 && PApplet.parseInt(motor_sol) == 0){
      arduino_uno.digitalWrite(a_led_k_1, Arduino.HIGH);
      arduino_uno.digitalWrite(a_led_k_2, Arduino.HIGH);
      arduino_uno.digitalWrite(a_led_y_1, Arduino.LOW);
      arduino_uno.digitalWrite(a_led_y_2, Arduino.LOW);
    }else{
      arduino_uno.digitalWrite(a_led_k_1, Arduino.LOW);
      arduino_uno.digitalWrite(a_led_k_2, Arduino.LOW);
      arduino_uno.digitalWrite(a_led_y_1, Arduino.HIGH);
      arduino_uno.digitalWrite(a_led_y_2, Arduino.HIGH);
    }
    
  }




// ## ARDUINO'DAN GELEN ## //

  public int[] oku_uzaklik(){
  
    int[] degerler = new int[3];
    
    degerler[0] = 12;
    degerler[1] = 12212;
    degerler[2] = 2121;
    
    return degerler;
    
  }









public void setup() {
  size(500, 120, P3D);
  //frameRate(25);
  
  println(Arduino.list());
  //arduino_uno = new Arduino(this, s_arduino_uno, 57600);
  //arduino_mega = new Arduino(this, s_arduino_mega, 57600);
  
  remoteLocation = new NetAddress(IP, 9000);
  oscP5 = new OscP5(this,8000);
  
  // ARDUINO UNO PIN MODE
  
  /*
  arduino_uno.pinMode(a_motor_sol_on, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sol_arka, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sag_on, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sag_arka, Arduino.OUTPUT);
  
  arduino_uno.pinMode(a_motor_sol_on_d, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sol_arka_d, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sag_on_d, Arduino.OUTPUT);
  arduino_uno.pinMode(a_motor_sag_arka_d, Arduino.OUTPUT);
    
  arduino_uno.pinMode(a_led_k_1, Arduino.OUTPUT);
  arduino_uno.pinMode(a_led_k_2, Arduino.OUTPUT);
  arduino_uno.pinMode(a_led_y_1, Arduino.OUTPUT);
  arduino_uno.pinMode(a_led_y_2, Arduino.OUTPUT);
 */ 
 
}








String val;
int b = 1; // Hareket i\u00e7in

public void draw() {
  
  // TEXT
  
  textSize(32);

  text("Ak\u00e7abaat Fen Lisesi", 10, 40);   
  fill(0, 102, 153);
  
  text("ROBOTEXT PLATFORM", 10, 90);  
  fill(0, 102, 153, 51);
  
  
  
  // GIRIS
  
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
