void ses(String cumle){
  
  if(cumle == "merhaba"){
    
    try{
      ses_merhaba_bash();
    }catch(Exception c){
      println("Ses Çalmada Sorun Oldu");
    }
    
  }else if(cumle == "hareket"){
  
    try{
      ses_hareket_bash();
    }catch(Exception c){
      println("Ses Çalmada Sorun Oldu");
    }
  
  }else if(cumle == "hareket_basla"){
  
    try{
      ses_hareket_basla_bash();
    }catch(Exception c){
      println("Ses Çalmada Sorun Oldu");
    }
      
  }
  
}

void ses_merhaba_bash() throws InterruptedException, IOException {
    Runtime run = Runtime.getRuntime();
    Process proc = run.exec(new String[]{"/bin/sh", "-c", "omxplayer /home/pi/merhaba.mp3"});
    proc.waitFor();
    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    while(br.ready())
        println(br.readLine());
}

void ses_hareket_bash() throws InterruptedException, IOException {
    Runtime run = Runtime.getRuntime();
    Process proc = run.exec(new String[]{"/bin/sh", "-c", "omxplayer /home/pi/hareket.mp3"});
    proc.waitFor();
    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    while(br.ready())
        println(br.readLine());
}

void ses_hareket_basla_bash() throws InterruptedException, IOException {
    Runtime run = Runtime.getRuntime();
    Process proc = run.exec(new String[]{"/bin/sh", "-c", "omxplayer /home/pi/hareket_basla.mp3"});
    proc.waitFor();
    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    while(br.ready())
        println(br.readLine());
}
