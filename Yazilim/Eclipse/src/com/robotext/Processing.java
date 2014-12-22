package com.robotext;

import processing.core.*;

public class Processing extends PApplet {

  public void setup() {
    size(600,600);
    background(0);
  }

  public void draw() {
    stroke(255);
    if (mousePressed) {
      line(mouseX,mouseY,pmouseX,pmouseY);
    }
  }
}