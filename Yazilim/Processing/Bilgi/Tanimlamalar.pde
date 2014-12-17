import oscP5.*;
import netP5.*;
import processing.serial.*;
import processing.video.*;
import cc.arduino.*;
import javax.mail.*;
import javax.mail.internet.*;
import gab.opencv.*;
import java.awt.*;

OscP5 oscP5;
NetAddress remoteLocation;
Capture video;
Capture cam;
OpenCV opencv;

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
  int a_servo_1 = 4;
  
  // DIGITAL
  int a_ses = 23;
  int a_hareket_1 = 22;
  int a_hareket_2 = 31;
  int a_hoparlor = 30;
  int a_buzzer = 24;
  
  // ANALOG
  
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

  // GİRİŞ EKRANI
  
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



// ### GENEL TANIMLAMALAR ### //

int resim_no = 0;
int resim_baslangic = 0;

boolean hareket_oldu_sag = false;
int hareket_sayisi_sag = 0;

boolean hareket_oldu_sol = false;
int hareket_sayisi_sol = 0;
