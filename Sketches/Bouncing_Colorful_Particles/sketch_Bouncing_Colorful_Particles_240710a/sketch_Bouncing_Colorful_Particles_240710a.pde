particle[] particles;
int frameCounter = 0; // Counter to track frames
float noiseScale = 0.05; // Noise scale for distortion

void setup() {
  size(800, 600);
  background(0); // black background
  
  noStroke();
  
  int numParticles = 100;
  particles = new particle[numParticles];
  
  for (int i = 0; i < numParticles; i++) {
    particles[i] = new particle(random(width), random(height));
  }
}

void draw() {
  background(0); // keep the black background
  
  for (particle p : particles) {
    p.update();
    p.display();
  }
  
  frameCounter++; // Increment the frame counter
  
  // Save the frame as a PNG file in the specified directory
     saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/Bouncing_Colorful_Particles/frame-####.png");
}

class particle {
  float x, y;
  float speedX, speedY;
  float size;
  color particleColor;
  
  particle(float tempX, float tempY) {
    x = tempX;
    y = tempY;
    speedX = random(-1, 1);
    speedY = random(-1, 1);
    size = random(10, 200); // Increased size range
    particleColor = color(random(255), random(255), random(255)); // Initial random color
  }
  
  void update() {
    x += speedX;
    y += speedY;
    
    // bounce off edges
    if (x < 0 || x > width) {
      speedX *= -1;
    }
    if (y < 0 || y > height) {
      speedY *= -1;
    }
    
    // Change color every 10 frames
    if (frameCounter % 15 == 0) {
      particleColor = color(random(255), random(255), random(255));
    }
  }
  
  void display() {
    float distortionX = noise(x * noiseScale, y * noiseScale, frameCount * 0.01) * 20 - 10; // Enhanced distortion for x
    float distortionY = noise(y * noiseScale, x * noiseScale, frameCount * 0.01) * 20 - 10; // Enhanced distortion for y
    fill(particleColor);
    ellipse(x + distortionX, y + distortionY, size, size);
  }
}
