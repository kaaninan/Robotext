void resim_cek() {
  
  println("Resim Çekiliyor");
  try{
    test();
  }catch (Exception c){
    println("test hata");
  }
  println("Resim Çekildi");
  
  thread("sendMail");
}

void test() throws InterruptedException, IOException {
    Runtime run = Runtime.getRuntime();
    Process proc = run.exec(new String[]{"/bin/sh", "-c", "fswebcam  /home/pi/guvenlik0.jpg"});
    proc.waitFor();
    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    while(br.ready())
        println(br.readLine());
}
