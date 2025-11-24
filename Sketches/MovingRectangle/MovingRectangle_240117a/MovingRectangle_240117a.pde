class MovingRectangle {
  float x, y, w, h;
  float r, g, b;
  float speedX, speedY;

  MovingRectangle() {
    x = random(width);
    y = random(height);
    w = random(20, 75); // Ensures a minimum size of 20 for better visibility
    h = random(5, 150); // Same as above
    r = random(255);
    g = random(255);
    b = random(255);
    speedX = random(-3, 3);
    speedY = random(-3, 3);
  }

  void update() {
    x += speedX;
    y += speedY;

    // Check boundaries and reverse direction if necessary
    if (x <= 0 || x >= width - w) {
      speedX *= -1;
    }
    if (y <= 0 || y >= height - h) {
      speedY *= -1;
    }
  }

  void display() {
    fill(r, g, b);
    rect(x, y, w, h);
  }
}

ArrayList<MovingRectangle> rectangles;

void setup() {
  size(1024, 1024);
  rectangles = new ArrayList<MovingRectangle>();

  for (int i = 0; i < 50; i++) {
    rectangles.add(new MovingRectangle());
  }
}

void draw() {
  background(0);

  for (MovingRectangle rect : rectangles) {
    rect.update();
    rect.display();
  }

  // Save the frame to the output directory
  saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/MovingRectangle/frame-####.png");
}
