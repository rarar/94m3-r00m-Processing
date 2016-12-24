import processing.serial.*;
import processing.sound.*;


AudioIn input;
Amplitude rms;

int scale=1;

Serial glowPort;

void setup() {
  size(640, 360);
  background(255);

  String portName = Serial.list()[1];
  println(Serial.list()[1]);
  glowPort = new Serial(this, portName, 115200);

  //Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // start the Audio Input
  input.start();

  // create a new Amplitude analyzer
  rms = new Amplitude(this);

  // Patch the input to an volume analyzer
  rms.input(input);
}      


void draw() {
  background(125, 255, 125);
  scale=int(map(rms.analyze(), 0, 0.5, 1, 350));
  noStroke();

  if (rms.analyze() > 0.6) {
    glowPort.write('H');
    println(rms.analyze());
  } else if (rms.analyze() > 0.125) {
      glowPort.write('J');
  } else {
    glowPort.write('L'); 
  }
  
  fill(255, 0, 150);
  // We draw an ellispe coupled to the audio analysis
  ellipse(width/2, height/2, 1*scale, 1*scale);
}