// Sketch: ParticleFlow_250221
// Declare global variables
float t = 0; // Time variable for animation
int numEllipses = 30; // Number of ellipses
float[] xOffsets; // Array for x noise offsets
float[] yOffsets; // Array for y noise offsets
float[] angles; // Array for rotation angles
ParticleSystem[] particleSystems; // Array for particle systems
int maxFrames = 300; // Limit the number of frames to save (e.g., 5 seconds at 60 FPS)
String filename = "/home/gero/GitHub/Processing_Lab/Processing_Output/ParticleFlow/ParticleDance"; // Base filename for saved frames

void setup() {
  size(1024, 768); // Set canvas size to 1024x768 (4:3 ratio)
  colorMode(HSB, 360, 100, 100); // Use HSB color mode for vibrant gradients
  background(0); // Black background
  
  // Initialize arrays
  xOffsets = new float[numEllipses];
  yOffsets = new float[numEllipses];
  angles = new float[numEllipses];
  particleSystems = new ParticleSystem[numEllipses];
  
  // Populate arrays with random initial values
  for (int i = 0; i < numEllipses; i++) {
    xOffsets[i] = random(1000); // Unique noise offset for x
    yOffsets[i] = random(1000); // Unique noise offset for y
    angles[i] = random(TWO_PI); // Random initial angle
    particleSystems[i] = new ParticleSystem(new PVector(0, 0), color(0));
  }
}

void draw() {
  // Semi-transparent background for trailing effect
  fill(0, 20); // Black with low opacity
  rect(0, 0, width, height); 
  
  // Loop through each ellipse
  for (int i = 0; i < numEllipses; i++) {
    // Calculate position using Perlin noise
    float x = map(noise(xOffsets[i] + t), 0, 1, 0, width);
    float y = map(noise(yOffsets[i] + t), 0, 1, 0, height);
    
    // Size influenced by mouse X position
    float size = map(mouseX, 0, width, 20, 100) + sin(t + i) * 20;
    
    // Color based on position and time
    float hue = (t * 50 + i * 10) % 360; // Cycling hue
    float saturation = map(mouseY, 0, height, 50, 100); // Saturation from mouse Y
    float brightness = 100; // Full brightness
    
    // Push transformation matrix
    pushMatrix();
    translate(x, y); // Move to calculated position
    rotate(angles[i]); // Apply rotation
    
    // Draw ellipse
    fill(hue, saturation, brightness);
    noStroke();
    ellipse(0, 0, size, size * 0.6); // Slightly oval shape
    
    // Draw smaller inner ellipse with complementary color
    fill((hue + 180) % 360, saturation, brightness * 0.8);
    ellipse(0, 0, size * 0.5, size * 0.3);
    
    // Pop transformation matrix
    popMatrix();
    
    // Update particle system
    particleSystems[i].setOrigin(new PVector(x, y));
    particleSystems[i].particleColor = color((hue + 180) % 360, saturation, brightness);
    if (frameCount % 5 == 0) {
      particleSystems[i].addParticle(angles[i], size); // Pass ellipse size to particle system
    }
    particleSystems[i].update();
    particleSystems[i].display();
    
    // Update angle and noise offsets
    angles[i] += map(mouseX, 0, width, 0.01, 0.1); // Rotation speed from mouse X
    xOffsets[i] += 0.01; // Increment noise offset for smooth motion
    yOffsets[i] += 0.01;
  }
  
  // Increment time
  t += 0.02;
  
  // Save each frame with the custom filename
  saveFrame(filename + "_##.jpg");
  
  // Optional: Stop saving and exit after maxFrames
  if (frameCount >= maxFrames) {
    exit(); // Stops the sketch and saves resources
  }
}

// Optional: Reset animation on mouse click
void mousePressed() {
  t = 0;
  for (int i = 0; i < numEllipses; i++) {
    xOffsets[i] = random(1000);
    yOffsets[i] = random(1000);
    angles[i] = random(TWO_PI);
  }
}

// Particle class
class Particle {
  PVector position;
  PVector velocity;
  float lifespan;
  float maxLifespan; // Stores initial lifespan for size mapping
  float initialSize; // Stores initial size for shrinking effect
  color c;

  Particle(PVector pos, color col, PVector vel, float ellipseSize) {
    position = pos.copy();
    velocity = vel;
    maxLifespan = random(100, 255); // Random maximum lifespan
    lifespan = maxLifespan;
    initialSize = random(0.1 * ellipseSize, 0.3 * ellipseSize); // Random size based on ellipse size
    c = col;
  }

  void update() {
    position.add(velocity);
    lifespan -= 1; // Fade out over time
  }

  void display() {
    // Calculate current size based on remaining lifespan
    float currentSize = map(lifespan, 0, maxLifespan, 0, initialSize);
    fill(c, lifespan); // Alpha based on lifespan
    noStroke();
    ellipse(position.x, position.y, currentSize, currentSize);
  }

  boolean isDead() {
    return lifespan < 0;
  }
}

// ParticleSystem class
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  color particleColor;

  ParticleSystem(PVector pos, color col) {
    origin = pos.copy();
    particleColor = col;
    particles = new ArrayList<Particle>();
  }

  void addParticle(float angle, float ellipseSize) {
    // Emit particles with a slight spread in direction
    PVector vel = PVector.fromAngle(angle + random(-0.5, 0.5)).mult(random(1, 3));
    particles.add(new Particle(origin, particleColor, vel, ellipseSize));
  }

  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }

  void setOrigin(PVector pos) {
    origin = pos.copy();
  }
}
