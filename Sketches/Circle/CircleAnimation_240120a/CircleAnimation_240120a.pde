int x, y;
int radius = 75;
float angle = 0;

void setup() {
  size(480, 480);
  x = width / 2;
  y = height / 2;
}

void draw() {
  background(255); // Clear the background
  x = int(width / 2 + 100 * cos(angle)); // Radius of circular path
  y = int(height / 2 + 100 * sin(angle)); // Radius of circular path
  angle += 0.1;

  fill(255, 0, 0); // Red color
  ellipse(x, y, radius * 2, radius * 2); // Draw the circle
}
