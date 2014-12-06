
// Test program for SparkFun Ardumoto board
// Copyright (c) 2009 mechomaniac.com
 
// To use, connect the Arduino to a computer and send commands using a serial terminal.
// eg AR40#   motor A forwards with a speed of 40
 
#define PwmPinMotorA 10
#define PwmPinMotorB 11
#define DirectionPinMotorA 12
#define DirectionPinMotorB 13
#define SerialSpeed 9600
#define BufferLength 16
#define LineEnd '#'
 
char inputBuffer[BufferLength];
 
void setup()
{
  // motor pins must be outputs
  pinMode(PwmPinMotorA, OUTPUT);
  pinMode(PwmPinMotorB, OUTPUT);
  pinMode(DirectionPinMotorA, OUTPUT);
  pinMode(DirectionPinMotorB, OUTPUT);
 
  Serial.begin(SerialSpeed);
}
 
// process a command string
void HandleCommand(char* input, int length)
{
  Serial.println(input);
  if (length < 2) { // not a valid command
    return;
  }
  int value = 0;
  // calculate number following command
  if (length > 2) {
    value = atoi(&input[2]);
  }
  int* command = (int*)input;
  // check commands
  // note that the two bytes are swapped, ie 'RA' means command AR
  switch(*command) {
    case 'FA':
      // motor A forwards
      analogWrite(PwmPinMotorA, value);
      digitalWrite(DirectionPinMotorA, HIGH);
      break;
    case 'RA':
      // motor A reverse
      analogWrite(PwmPinMotorA, value);
      digitalWrite(DirectionPinMotorA, LOW);
      break;
    case 'FB':
      // motor B forwards
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPinMotorB, LOW);
      break;
    case 'RB':
      // motor B reverse
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPinMotorB, HIGH);
      break;
    default:
      break;
  } 
}
 
void loop()
{
  // get a command string form the serial port
  int inputLength = 0;
  do {
    while (!Serial.available()); // wait for input
    inputBuffer[inputLength] = Serial.read(); // read it in
  } while (inputBuffer[inputLength] != LineEnd && ++inputLength < BufferLength);
  inputBuffer[inputLength] = 0; //  add null terminator
  HandleCommand(inputBuffer, inputLength);
}
