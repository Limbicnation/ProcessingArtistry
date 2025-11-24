float angle = 0;
float[] sizes;
float[] x;
float[] y;
int frameCount = 0;

void setup() {
  size(800, 800);
  frameRate(30); // Set the desired framerate
  background(0);
  noStroke();

  sizes = new float[500];
  x = new float[500];
  y = new float[500];

  for (int i = 0; i < 500; i++) { // Increase the loop limit to 500
    sizes[i] = random(150, 300);
    x[i] = random(width);
    y[i] = random(height);
  }
}

void draw() {
  background(0);

  angle += 0.01;

  for (int i = 0; i < 500; i++) { // Increase the loop limit to 500
    drawFractal(x[i], y[i], sizes[i], angle, 4);
  }

  if (frameCount < 300) { // Adjust the desired number of frames to save
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/Fractal_Bloom/frame_" + nf(frameCount, 4) + ".png");
    frameCount++;
  } else {
    noLoop();
  }
}

void drawFractal(float x, float y, float size, float angle, int depth) {
  fill(random(255), random(255), random(255));

  if (depth == 0) {
    ellipse(x, y, size, size);
    return;
  }

  float nextSize = size * 0.5; // Increase the scale by 5 (size * 5)

  float xOffset = cos(angle) * size * 0.6;
  float yOffset = sin(angle) * size * 0.6;

  drawFractal(x - xOffset, y - yOffset, nextSize, angle + PI / 4, depth - 1);
  drawFractal(x + xOffset, y + yOffset, nextSize, angle - PI / 4, depth - 1);
}
