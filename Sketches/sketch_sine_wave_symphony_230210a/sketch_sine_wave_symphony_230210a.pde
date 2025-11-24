import processing.core.*;

int numLines = 300;
float angle, angleStep;
float len = 300;
float[] x1 = new float[numLines];
float[] y1 = new float[numLines];
float[] x2 = new float[numLines];
float[] y2 = new float[numLines];

void setup() {
  size(800, 800);
  background(0);
  strokeWeight(2);
}

void draw() {
  translate(width/2, height/2);
  for (int i = 0; i < 360; i+=5) {
    pushMatrix();
    rotate(radians(i));
    float w = cos(radians(frameCount + i)) * 50;
    stroke(random(255), random(255), random(255));
    line(0, 0, 100 + w, 0);
    popMatrix();
  }
}
