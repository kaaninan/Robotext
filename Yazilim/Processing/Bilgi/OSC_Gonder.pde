// ### GIDEN OSC ### //

// MOTOR

void gonder_motor_sifirla(boolean ters) {

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

  if (ters == true) {
    oscP5.send(msg_7, remoteLocation);
    oscP5.send(msg_8, remoteLocation);
  }
}

// DURUM

void gonder_durum(String durum) {

  OscMessage msg_durum = new OscMessage(s_durum);
  msg_durum.add(durum);
  oscP5.send(msg_durum, remoteLocation);
}


// UZAKLIK

void gonder_uzaklik(int sol_1, int sol_2, int sag_1, int sag_2) {

  OscMessage msg_sag_1 = new OscMessage(s_uzaklik_sag_1);
  OscMessage msg_sag_2 = new OscMessage(s_uzaklik_sag_2);
  OscMessage msg_sol_1 = new OscMessage(s_uzaklik_sol_1);
  OscMessage msg_sol_2 = new OscMessage(s_uzaklik_sol_2);

  msg_sag_1.add(sag_1);
  msg_sag_2.add(sag_2);
  msg_sol_1.add(sol_1);
  msg_sol_2.add(sol_2);

  oscP5.send(msg_sag_1, remoteLocation);
  oscP5.send(msg_sag_2, remoteLocation);
  oscP5.send(msg_sol_1, remoteLocation);
  oscP5.send(msg_sol_2, remoteLocation);
}

void gonder_uzaklik_sifirla() { 

  OscMessage msg_sag_1 = new OscMessage(s_uzaklik_sag_1);
  OscMessage msg_sag_2 = new OscMessage(s_uzaklik_sag_2);
  OscMessage msg_sol_1 = new OscMessage(s_uzaklik_sol_1);
  OscMessage msg_sol_2 = new OscMessage(s_uzaklik_sol_2);

  msg_sag_1.add(0);
  msg_sag_2.add(0);
  msg_sol_1.add(0);
  msg_sol_2.add(0);

  oscP5.send(msg_sag_1, remoteLocation);
  oscP5.send(msg_sag_2, remoteLocation);
  oscP5.send(msg_sol_1, remoteLocation);
  oscP5.send(msg_sol_2, remoteLocation);
}



// ISIK

void gonder_isik(int ust, int alt) {

  OscMessage msg_ust = new OscMessage("/Isik/ust_olcum");
  OscMessage msg_alt = new OscMessage("/Isik/alt_olcum");

  msg_ust.add(ust);
  msg_alt.add(alt);

  oscP5.send(msg_ust, remoteLocation);
  oscP5.send(msg_alt, remoteLocation);

  if (ust < 150) {
    OscMessage msg_ust_yetersiz = new OscMessage("/Isik/ust_yetersiz");
    msg_ust_yetersiz.add("Yetersiz");
    oscP5.send(msg_ust_yetersiz, remoteLocation);
  } else {
    OscMessage msg_ust_yetersiz = new OscMessage("/Isik/ust_yetersiz");
    msg_ust_yetersiz.add("");
    oscP5.send(msg_ust_yetersiz, remoteLocation);
  }

  if (alt < 40) {
    OscMessage msg_alt_yetersiz = new OscMessage("/Isik/alt_yetersiz");
    msg_alt_yetersiz.add("Yetersiz");
    oscP5.send(msg_alt_yetersiz, remoteLocation);
  } else {
    OscMessage msg_alt_yetersiz = new OscMessage("/Isik/alt_yetersiz");
    msg_alt_yetersiz.add("");
    oscP5.send(msg_alt_yetersiz, remoteLocation);
  }
}

void gonder_isik_sifirla() {

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

void gonder_hareket(int sayi, boolean hareket) {

  OscMessage msg_led = new OscMessage("/Hareket/hareket_led");
  OscMessage msg_olcum = new OscMessage("/Hareket/sayi_olcum");

  msg_led.add(hareket);
  msg_olcum.add(sayi);

  oscP5.send(msg_led, remoteLocation);
  oscP5.send(msg_olcum, remoteLocation);
}

void gonder_hareket_sifirla() {

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

void gonder_yakinlik(int yakin) {

  OscMessage msg_olcum = new OscMessage("/Yakinlik/yakinlik_olcum");

  msg_olcum.add(yakin);

  oscP5.send(msg_olcum, remoteLocation);

  if (yakin < 150) {
    OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
    msg_yerde.add("Yerde  Degil");
    oscP5.send(msg_yerde, remoteLocation);
  } else {
    OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
    msg_yerde.add("");
    oscP5.send(msg_yerde, remoteLocation);
  }
}

void gonder_yakinlik_sifirla() {

  int sayi = 0;

  OscMessage msg_olcum = new OscMessage("/Yakinlik/yakinlik_olcum");
  msg_olcum.add(sayi);
  oscP5.send(msg_olcum, remoteLocation);

  OscMessage msg_yerde = new OscMessage("/Yakinlik/yakinlik_uyari");
  msg_yerde.add("");
  oscP5.send(msg_yerde, remoteLocation);
}



// VOLTAJ

void gonder_voltaj(float voltaj, float voltaj_uzaklik, float voltaj_yakinlik, float voltaj_isik, float voltaj_kizilotesi, float voltaj_hareket, float voltaj_besleme) {


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

void gonder_voltaj_sifirla() {

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

void gonder_giris() {

  String basarili = "Giris Yapildi";
  String isim = "ROBOTEXT";
  String hata = "Lutfen Giris Yapin";

  OscMessage msg_basarili = new OscMessage("/Giris/basarili");
  OscMessage msg_isim = new OscMessage("/Giris/isim");
  OscMessage msg_basarisiz = new OscMessage("/Giris/basarisiz");

  if (giris == 1) {
    msg_basarili.add(basarili);
    msg_isim.add(isim);
    msg_basarisiz.add("");
  } else {
    msg_basarili.add("");
    msg_isim.add("");
    msg_basarisiz.add(hata);
  }

  oscP5.send(msg_basarili, remoteLocation);
  oscP5.send(msg_isim, remoteLocation);
  oscP5.send(msg_basarisiz, remoteLocation);
}
