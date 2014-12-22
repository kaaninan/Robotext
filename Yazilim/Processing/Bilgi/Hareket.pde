boolean running = false;
boolean first = true;
boolean the_first = false;
boolean olcmeye_basla = false;

int[] hareket_sol_dizi = new int[9];
int[] hareket_sag_dizi = new int[9];

void hareket(String yon){

  if(running == false){
    
    // İlk Hareket Algılandığında Grafik Verilerini Başlat
    if(the_first)
      olcmeye_basla = true;
    
    running = true;
    
    if(yon == "sag"){
      servo_dondur("sag");
    }else{
      servo_dondur("sol");
    }
    
    delay(200); // Servonun dönme süresi
    
    resim_cek();
    resim_no++;
    ses("hareket");
    
    if(first == true){
      thread("sendMailBirinci");
    }
    
    running = false;
  
  }else{
    
    // Üst üste hareket algılandığında
    
  }
}


int sol_nerde = 0;
int sag_nerde = 0;

int ia;
int ai;

void hareket_olc(){
  
  if(olcmeye_basla){
    if(sol_nerde < 10){
      if(hareket_oldu_sag)
        ia = 1;
      else
        ia = 0;
        
      if(hareket_oldu_sol)
        ai = 1;
      else
        ai = 0;
      
      hareket_sol_dizi[sol_nerde] = ai;
      hareket_sol_dizi[sag_nerde] = ia;
      
      sol_nerde++;
      sag_nerde++;
    
    }else{
      thread("sendMailIkinci");
    }
  }
}
