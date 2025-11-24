float angle;
float x = 1;
float y = 2.2;
Fractal fractalShape;
int frameCountAtLastCall;
int loopDirection = 1;
String exportPath = "/home/gero/GitHub/Processing_Lab/Processing_Output/StrokeWeightPink/"; //Change this to your desired folder path
int frameCount = 0;
int captureInterval = 1; //Number of frames between each capture

void setup() {
  size(512, 512);
  angle = PI / 4;
  fractalShape = new Fractal();
  frameCountAtLastCall = 0;
  frameRate(30);
}

void draw() {
  //background(random(255), random(255), random(255));
  angle += 0.005 * loopDirection;
  if (angle >= TWO_PI || angle <= 0) {
    loopDirection *= -1;
  }
  fractalShape.display();
  exportFrame();
}
// Save Animation Frames
void exportFrame() {
  if (frameCount % captureInterval == 0) {
    saveFrame(exportPath+"animation_"+frameCount+".png");
  }
  frameCount++;
}

class Fractal {
  float x, y;
  color col;

  Fractal() {
    x = width / 2;
    y = height;
    col = color(random(255), random(255), random(255));
  }

  void display() {
    strokeWeight(64);
    drawFractal(x, y, 100, col);
  }

  void drawFractal(float x, float y, float len, color c) {
    stroke(c);
    line(x, y, x, y - len);
    if (len > 4) {
      // Change the speed of the animation
      if (frameCount - frameCountAtLastCall > 30) {
        col = color(random(255), random(255), random(255));
        background(random(255), random(255), random(255));
        frameCountAtLastCall = frameCount;
      }
      pushMatrix();
      rotate(angle);
      drawFractal(x, y - len, len * 0.67, col);
      popMatrix();
      pushMatrix();
      rotate(-angle);
      drawFractal(x, y - len, len * 0.67, col);
      popMatrix();
   
    }
  }
}
