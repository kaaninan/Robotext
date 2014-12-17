// Kamera
void resim_cek(){
  
  println("Resim Cekiliyor");
  cam.read();
  image(cam, 320, 0); 
  saveFrame("/Users/kaaninan/Desktop/test"+resim_no+".png");
  resim_no++;
  
}


void resim_baslangic() {
  
  resim_baslangic = resim_no;
  
}
