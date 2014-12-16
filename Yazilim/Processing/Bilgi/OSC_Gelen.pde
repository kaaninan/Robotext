// ## GELEN OSC ## //

void oscEvent(OscMessage theOscMessage) {

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
   
  
  
  // GİRİŞ
  
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
