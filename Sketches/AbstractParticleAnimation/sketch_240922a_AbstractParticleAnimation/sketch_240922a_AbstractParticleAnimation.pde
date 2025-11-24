ArrayList<Particle> particles; // Declare particles globally

void setup() {
  size(400, 400);
  background(255);
  noStroke(); // Remove outlines for smooth shapes

  // Set initial particle values
  int numParticles = 100;
  particles = new ArrayList<Particle>();
  for (int i = 0; i < numParticles; i++) {
    particles.add(new Particle(random(width), random(height)));
  }
}

void draw() {
  background(255, 10); // Fade out previous frame for smooth animation

  for (Particle p : particles) {
    p.update();
    p.display();
  }
}

class Particle {
  float x, y;
  float speedX, speedY;
  float size;
  
  public Particle(float x, float y) {
    this.x = x;
    this.y = y;
    speedX = random(-2, 2);
    speedY = random(-2, 2);
    size = random(5, 15); // Initialize size in the constructor
  }

  void update() {
    x += speedX;
    y += speedY;

    // Bounce particles off edges
    if (x < 0 || x > width) {
      speedX *= -1;
    }
    if (y < 0 || y > height) {
      speedY *= -1;
    }
  }

  void display() {
    fill(random(255), random(255), random(255)); // Vary color randomly
    ellipse(x, y, size, size); // Use size for both width and height
  }
}
