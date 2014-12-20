void ses_merhaba() throws InterruptedException, IOException {
    Runtime run = Runtime.getRuntime();
    Process proc = run.exec(new String[]{"/bin/sh", "-c", "omxplayer /home/pi/merhaba.mp3"});
    proc.waitFor();
    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    while(br.ready())
        println(br.readLine());
}
