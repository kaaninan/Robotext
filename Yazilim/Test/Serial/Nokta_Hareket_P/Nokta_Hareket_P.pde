import processing.serial.*;
Serial myPort;

float bgcolor;
float fgcolor;
float xpos, ypos;

void setup() {
  size(400,300);

  println(Serial.list());
  myPort = new Serial(this, Serial.list()[6], 115200);
  myPort.bufferUntil('\n');
  
  smooth();
}

void draw() {
  background(bgcolor);
  fill(fgcolor);
  ellipse(xpos, ypos, 20, 20);
}


void serialEvent(Serial myPort) { 
  
  String myString = myPort.readStringUntil('\n');
  myString = trim(myString);
 
  int sensors[] = int(split(myString, ','));

  for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
    print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t"); 
  }
   
  println();
  
  if (sensors.length > 1) {
    xpos = map(sensors[0], 0,1023,0,width);
    ypos = map(sensors[1], 0,1023,0,height);
    fgcolor = sensors[2];
  }
  
  if(sensors[1] < 250){
    myPort.write("on 13");
  }else{
    myPort.write("on 52");
  } 
}

