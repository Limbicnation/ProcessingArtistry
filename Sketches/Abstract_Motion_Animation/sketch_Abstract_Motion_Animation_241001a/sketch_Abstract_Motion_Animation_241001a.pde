PShape[] shapes;
int numShapes = 50;

void setup() {
  size(800, 600);
  background(255);
  
  // Create multiple shapes
  shapes = new PShape[numShapes];
  for (int i = 0; i < numShapes; i++) {
    float size = random(10, 50);
    shapes[i] = createShape(RECT, random(width), random(height), size, size);
    shapes[i].setFill(color(random(255), random(255), random(255)));
    shapes[i].setStroke(color(0));
  }
}

void draw() {
  background(255);
  
  // Update and display each shape
  for (int i = 0; i < numShapes; i++) {
    PShape s = shapes[i];
    
    // Move the shape in a circular motion
    float angle = frameCount * 0.1 + i * TWO_PI / numShapes;
    float x = width / 2 + cos(angle) * width / 4;
    float y = height / 2 + sin(angle) * height / 4;
    
    // Push and pop the transformation matrix to apply translation
    pushMatrix();
    translate(x, y);
    shape(s);
    popMatrix();
  }
  
  // Add some sparkles
  for (int i = 0; i < 10; i++) {
    float x = random(width);
    float y = random(height);
    fill(random(255), 200, 200);
    ellipse(x, y, random(2, 5), random(2, 5));
  }
  
  // Draw a gradient background
  noStroke();
  for (int i = 0; i < height; i++) {
    float c = map(i, 0, height, 255, 100);
    fill(c, 50);
    rect(0, i, width, 1);
  }
}

void mousePressed() {
  // Reset the animation when the mouse is pressed
  setup();
}
