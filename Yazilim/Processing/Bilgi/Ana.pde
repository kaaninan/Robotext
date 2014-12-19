String IP = "192.168.1.21";
int port = 6000;

String s_arduino_uno = "/dev/ttyACM0";
String s_arduino_mega = "/dev/ttyUSB0";

boolean arduino_uno_bagli = false;
boolean arduino_mega_bagli = false;

//String s_arduino_uno = "/dev/tty.usbmodem1411";
//String s_arduino_mega = "/dev/tty.usbserial-A603JL3X";


void setup() {

  println(Arduino.list());

  if (arduino_uno_bagli)
    arduino_uno = new Arduino(this, s_arduino_uno, 57600);

  if (arduino_mega_bagli)
    arduino_mega = new Arduino(this, s_arduino_mega, 57600);


  remoteLocation = new NetAddress(IP, 9000);
  oscP5 = new OscP5(this, port);



  // ARDUINO UNO PIN MODE
  if (arduino_uno_bagli == true) {
    arduino_uno.pinMode(a_motor_sol_on, Arduino.OUTPUT);
    arduino_uno.pinMode(a_motor_sol_arka, Arduino.OUTPUT);
    arduino_uno.pinMode(a_motor_sag_on, Arduino.OUTPUT);
    arduino_uno.pinMode(a_motor_sag_arka, Arduino.OUTPUT);

    arduino_uno.pinMode(a_motor_sol_on_d, Arduino.OUTPUT);
    arduino_uno.pinMode(a_motor_sol_arka_d, Arduino.OUTPUT);
    arduino_uno.pinMode(a_motor_sag_on_d, Arduino.OUTPUT);
    arduino_uno.pinMode(a_motor_sag_arka_d, Arduino.OUTPUT);

    arduino_uno.pinMode(a_led_k_1, Arduino.OUTPUT);
    arduino_uno.pinMode(a_led_k_2, Arduino.OUTPUT);
    arduino_uno.pinMode(a_led_y_1, Arduino.OUTPUT);
    arduino_uno.pinMode(a_led_y_2, Arduino.OUTPUT);
  }


  // ARDUINO MEGA PIN MODE
  if (arduino_mega_bagli) {
    arduino_mega.pinMode(a_uzaklik_sicaklik, Arduino.OUTPUT);
    arduino_mega.pinMode(a_ekran, Arduino.OUTPUT);

    arduino_mega.pinMode(a_ses, Arduino.INPUT);
    arduino_mega.pinMode(a_hareket_1, Arduino.INPUT);
    arduino_mega.pinMode(a_hareket_2, Arduino.INPUT);

    arduino_mega.pinMode(a_buzzer, Arduino.OUTPUT);

    arduino_mega.pinMode(a_servo_1, Arduino.SERVO);

    gonder_motor_sifirla(true);
    gonder_uzaklik_sifirla();
    gonder_isik_sifirla();
    gonder_hareket_sifirla();
    gonder_yakinlik_sifirla();
    gonder_voltaj_sifirla();
    
  }
  
  size(1280, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  video.start();
  
  cam = new Capture(this, 320, 240, 30);
  cam.start();
}








String val;
int b = 1; // Hareket için

void draw() {

  // GIRIS

  //gonder_giris();

  giris = 1;

  if (giris == 0) { // Giriş yapılmadıysa

    gonder_motor_sifirla(true);
    gonder_uzaklik_sifirla();
    gonder_isik_sifirla();
    gonder_hareket_sifirla();
    gonder_yakinlik_sifirla();
    gonder_voltaj_sifirla();
  } else {

    if (arduino_uno_bagli){
      uno_motor_kontrol_manual();
    }

    if (arduino_mega_bagli){
      mega_oku_hareket_sag(true);
      mega_oku_hareket_sol();
      //mega_oku_ses();
    }
  }
  
  
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  //println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
  
  cam.read();
  image(cam, 320, 0);
  
  
  
}

void keyPressed() {
   resim_cek();
}

void mousePressed() {
  thread("sendMail");
}


void captureEvent(Capture c) {
  c.read();
}
