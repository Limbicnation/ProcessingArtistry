import processing.opengl.*;
import java.io.File;

float angle;
float rotationSpeed = 0.03;
int frameCount = 0;

void setup() {
  size(800, 800, P3D);
  new File("frames").mkdirs();
}

void draw() {
  background(0);
  lights();
  translate(width / 2, height / 2);
  rotateX(angle);
  rotateY(angle * 1.3);
  rotateZ(angle * 1.5);
  box(200);
  angle += rotationSpeed;

  saveFrame("frames/frame_" + nf(frameCount, 4) + ".png");
  frameCount++;
}
