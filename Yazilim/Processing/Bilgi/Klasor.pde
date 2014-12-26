void dosyala() {
  
  println("Resimler Arsivleniyor..");
  
  try{
    thread("dir_bash");
  }catch (Exception c){
    println("ARSIVLENEMEDI");
  }
  
  println("Arsivlenme Tamamlandı");
}

void dir_bash() throws InterruptedException, IOException {
    Runtime run = Runtime.getRuntime();
    Process proc = run.exec(new String[]{"/bin/sh", "-c", "mv /home/pi/resimler/* /home/pi/arsiv/"+hour()+":"+minute()+" "+day()+"."+month()+"."+year()});
    proc.waitFor();
    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    while(br.ready())
        println(br.readLine());
}
