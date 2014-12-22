int resim_no = 0;
int resim_baslangic = 0;

void resim_cek() {
  
  println("Resim Çekiliyor");
  
  try{
    resim_bash();
  }catch (Exception c){
    println("Resim Çekilemedi");
  }
  
  println("Resim Çekildi");
}

void resim_bash() throws InterruptedException, IOException {
    Runtime run = Runtime.getRuntime();
    Process proc = run.exec(new String[]{"/bin/sh", "-c", "fswebcam -r "+cozunurluk+"  /home/pi/guvenlik-"+resim_no+".jpg"});
    proc.waitFor();
    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    while(br.ready())
        println(br.readLine());
}
