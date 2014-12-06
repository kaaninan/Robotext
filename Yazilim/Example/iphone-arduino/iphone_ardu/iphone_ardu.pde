
import oscP5.*;
import netP5.*;
import processing.serial.*;
Serial arduinoPort;
OscP5 oscP5;

float [] fader = new float [3];

void setup() {
  oscP5 = new OscP5(this,8000);
  arduinoPort = new Serial(this, Serial.list()[0], 9600);
}

void oscEvent(OscMessage theOscMessage) {

    String addr = theOscMessage.addrPattern();
   
       if(addr.indexOf("/1/fader") !=-1){
       String list[] = split(addr,'/');
     int  xfader = int(list[2].charAt(5) - 0x30);
     if(theOscMessage.get(0).floatValue() !=0){
     fader[xfader]  = theOscMessage.get(0).floatValue();
     }  
    }
}

void draw() {
//---------------------------------Motor A
 if(fader[1] > 0.65){
    arduinoPort.write("AF100#");
  }
   if(fader[1] < 0.35){
    arduinoPort.write("AR100#");
  }
  //--------------------------------Motor B
   if(fader[2] > 0.65){
    arduinoPort.write("BF100#");
  }
   if(fader[2] < 0.35){
    arduinoPort.write("BR100#");
  }
  //----------------------------stop commands
     if(fader[1] < 0.65 && fader[1] > 0.35 ){
    arduinoPort.write("AF0#");
  }
       if(fader[2] < 0.65 && fader[2] > 0.35 ){
    arduinoPort.write("BF0#");
  }
 
}
