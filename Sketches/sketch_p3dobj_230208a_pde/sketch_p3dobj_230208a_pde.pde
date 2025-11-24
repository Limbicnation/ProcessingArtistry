import processing.opengl.*;
import processing.core.*;

PShape model;
float xAngle = 0;
float yAngle = 0;

void setup() {
  size(800, 800, P3D);
  model = loadShape("model.obj");
}

void draw() {
  background(200);
  lights();
  translate(width/2, height/2, 0);
  rotateX(xAngle + frameCount * 0.0125);
  rotateY(yAngle + frameCount * 0.01);
  shape(model);
}

void mouseDragged() {
  xAngle += (pmouseY - mouseY) * 0.01;
  yAngle += (pmouseX - mouseX) * 0.01;
}

void mousePressed() {
  xAngle = 0;
  yAngle = 0;
}
