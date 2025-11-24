float angle = 0;
int frameCount = 0;
int numPetals = 16; // Start with 16 petals

void setup() {
  size(1024, 1024);
  background(0); // Change the background to black
  noStroke();
  drawFlower(width / 2, height / 2, 200, 24, PI / 3); // Increase the petals to 12
}

void draw() {
  background(0);
  angle += 0.01; // Increment the angle for animation
// Use a sine wave to smoothly vary the number of petals from 16 to 64
  numPetals = int(map(sin(frameCount * 0.02), -1, 1, 16, 64));

  drawFlower(width / 2, height / 2, 200, numPetals, angle);
  
  // Save the frame as PNG image
  //saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/Colorful_Blooming/Colorful_Blooming_" + nf(frameCount, 4) + ".png");
  //frameCount++;

}

void drawFlower(float x, float y, float radius, int petals, float angle) {
  for (int i = 0; i < petals; i++) {
    float x1 = x + cos(TWO_PI * i / petals + angle) * radius;
    float y1 = y + sin(TWO_PI * i / petals + angle) * radius;
    float x2 = x + cos(TWO_PI * (i + 1) / petals + angle) * radius;
    float y2 = y + sin(TWO_PI * (i + 1) / petals + angle) * radius;

    float controlX1 = x1 + cos(angle) * radius * 1.8;
    float controlY1 = y1 + sin(angle) * radius * 1.8;
    float controlX2 = x2 + cos(-angle) * radius * 1.8;
    float controlY2 = y2 + sin(-angle) * radius * 1.8;

    // Calculate gradient colors
    color color1 = color(random(255), random(255), random(255));
    color color2 = color(random(255), random(255), random(255));

    // Draw the filled shape with gradient
    for (float t = 0; t <= 1; t += 0.1) {
      color interColor = lerpColor(color1, color2, t);
      fill(interColor);
      float bx = bezierPoint(x1, controlX1, controlX2, x2, t);
      float by = bezierPoint(y1, controlY1, controlY2, y2, t);
      ellipse(bx, by, 48, 48); // Increase the ellipse size to 48
    }
  }
}
