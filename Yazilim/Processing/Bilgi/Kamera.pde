void resim_cek() {
  
  println("Resim Çekiliyor");
  try{
    delay(100);
    test();
  }catch (Exception c){
    println("test hata");
  }
  println("Resim Çekildi");
  
  thread("sendMail");
}

void test() throws InterruptedException, IOException {
    Runtime run = Runtime.getRuntime();
    Process proc = run.exec(new String[]{"/bin/sh", "-c", "fswebcam -r 1280x720  /home/pi/guvenlik0.jpg"});
    proc.waitFor();
    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    while(br.ready())
        println(br.readLine());
}
