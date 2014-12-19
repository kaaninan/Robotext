// ## ARDUINO'DAN GELEN ## //

int basla = 0;
int basla2 = 0;

int[] oku_uzaklik() {
  int[] degerler = new int[3]; // SIRA:  ON, SAG, SOL
  degerler[0] = arduino_uno.analogRead(1) + arduino_uno.analogRead(2);
  degerler[1] = arduino_uno.analogRead(3) + arduino_uno.analogRead(4);
  degerler[2] = arduino_uno.analogRead(5) + arduino_uno.analogRead(6);
  return degerler;
}


void mega_oku_hareket_sag(boolean osc) {
  int hareket_durum = arduino_mega.digitalRead(a_hareket_1);

  if (hareket_durum == Arduino.HIGH) {

    if (osc == true)
      gonder_hareket(hareket_sayisi_sag, true);

    println("Hareket Var (SAG)");
    hareket_oldu_sag = true;
    
    if(basla == 0){
      mega_servo_dondur("sag");
      resim_cek();
      basla = 1;
    }
    
  } else {

    if (osc == true)
      gonder_hareket(hareket_sayisi_sag, false);

    println("Toplam Hareket (SAG): "+hareket_sayisi_sag);

    if (hareket_oldu_sag == true) {
      hareket_sayisi_sag++;
      hareket_oldu_sag = false;
    }
  }
}

void mega_oku_hareket_sol() {
  int hareket_durum = arduino_mega.digitalRead(a_hareket_2);

  if (hareket_durum == Arduino.HIGH) {
    println("Hareket Var (SOL)");
    hareket_oldu_sol = true;
    
    if(basla2 == 0){
      mega_servo_dondur("sol");
      resim_cek();
      basla2 = 1;
    }
    
  } else {
    println("Toplam Hareket (SOL): "+hareket_sayisi_sol);

    if (hareket_oldu_sol == true) {
      hareket_sayisi_sol++;
      hareket_oldu_sol = false;
    }
  }
}


void mega_oku_ses() {
  int ses_durum = arduino_mega.digitalRead(a_ses);

  if (ses_durum == Arduino.LOW) {
    println("Ses Algilandi");
  }
}

