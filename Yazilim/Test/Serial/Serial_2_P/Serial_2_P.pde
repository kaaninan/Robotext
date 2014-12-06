import processing.serial.*;
Serial myPort;

float bgcolor;
float fgcolor;
float xpos, ypos;

boolean first = true;

void setup() {
  size(640,480);

  // List all the available serial ports
 // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino module, so I open Serial.list()[0].
  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  myPort = new Serial(this, Serial.list()[6], 115200);

  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
  
  // draw with smooth edges:
  smooth();
  
  
  
}

void draw() {
  background(bgcolor);
  fill(fgcolor);
  // Draw the shape
  ellipse(xpos, ypos, 20, 20);
  
  
}

// serialEvent  method is run automatically by the Processing applet
// whenever the buffer reaches the  byte value set in the bufferUntil() 
// method in the setup():

void serialEvent(Serial myPort) {
  
  String myString = myPort.readStringUntil('\n');
  myString = trim(myString);
  
  println(myString);
  
  if(myString.equals("2")){ // Bağlantı Sağlandı
    first = false;
    myPort.write("p");
    println("Baglanildi");
  }
  
  else if(first == true){
    myPort.write('1');
    println("Karsi taraf bekleniyor..");
  }
  
  
  
  else if(myString.equals("o")){ // Bağlantı Durumunda
     
     println("geldi");
     myPort.write('k');
    
  }
  
  else{
    print("Uzaklik: ");
    println(myString);
    myPort.write('k');
  }
  
  
  

}
