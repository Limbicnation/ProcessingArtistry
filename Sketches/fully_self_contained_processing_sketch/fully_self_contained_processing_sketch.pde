/**
 *  Abstract Motion – Black Background & Hexagon/Custom Shape
 *  -------------------------------------------------------
 *  • 500+ particles drifting in 2‑D noise‑driven flow
 *  • Random shapes: circle, square, triangle, hexagon, custom star
 *  • Low‑alpha trails give a dreamy, glowing effect
 *  • BlendMode(ADD) makes overlapping shapes light up
 *  • Plain black background (re‑added)
 *
 *  Author: ChatGPT
 *  Date: 2025‑11‑20
 */

int NUM_PARTICLES = 500;   // Adjust for more or fewer shapes
Particle[] particles = new Particle[NUM_PARTICLES];

// ─────── Shape identifiers (unchanged) ─────────────────────────────────────
final int SHAPE_CIRCLE   = 0;
final int SHAPE_SQUARE   = 1;
final int SHAPE_TRIANGLE = 2;
final int SHAPE_HEXAGON  = 3;   // NEW
final int SHAPE_CUSTOM   = 4;   // NEW

boolean recording = false; // Flag to toggle video recording

void setup() {
  size(1080, 720, P2D);          // High‑resolution canvas
  smooth(8);                     // Anti‑aliasing (you can lower this for more CPU savings)
  frameRate(15);                 // Default; lower this if you want less CPU
  
  // Start with black background
  background(0);

  // Initialise particles with random positions and velocities
  for (int i = 0; i < NUM_PARTICLES; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  /* ----------  Fade the trails slowly  ---------- */
  // Replaces the off-screen buffer logic to prevent X11/JVM crashes.
  // We draw a semi-transparent black rect over the previous frame.
  blendMode(BLEND);
  noStroke();
  fill(0, 10);   // Very low alpha fade (controls trail length)
  rect(0, 0, width, height);

  /* ----------  Draw all particles  ---------- */
  blendMode(ADD);          // Light‑up overlapping shapes
  for (Particle p : particles) {
    p.update();
    p.display();
  }
  blendMode(BLEND);        // Restore default blend mode
  
  if (recording) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/fully_self_contained/frame_####.png");
    fill(255, 0, 0);
    ellipse(width - 20, 20, 10, 10); // Visual indicator for recording
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    recording = !recording;
    println("Recording: " + recording);
  }
}

/**
 *  Particle – holds state for each moving shape
 */
class Particle {
  PVector pos;      // Position
  PVector vel;      // Velocity
  float  size;      // Shape size
  color  col;       // Current colour
  int    shape;     // 0‑4 (circle, square, triangle, hexagon, custom)

  Particle() {
    pos  = new PVector(random(width), random(height));
    vel  = new PVector(0, 0);
    size = random(5, 25);
    col   = color(random(255), random(255), random(255), 200);
    shape = int(random(5));          // 0‑4 inclusive
  }

  void update() {
    // Use Perlin noise to create gentle, flowing motion
    float nX = noise(pos.x * 0.005, pos.y * 0.005, frameCount * 0.01);
    float nY = noise(pos.x * 0.005 + 100, pos.y * 0.005 + 100, frameCount * 0.01);

    // Map noise [0,1] → [-1,1] and scale to a velocity magnitude
    vel.x = map(nX, 0, 1, -1, 1);
    vel.y = map(nY, 0, 1, -1, 1);

    // Random jitter for extra organic feel
    vel.add(random(-0.1, 0.1), random(-0.1, 0.1));

    // Update position
    pos.add(vel);

    // Wrap around screen edges
    if (pos.x < 0) pos.x += width;
    if (pos.x > width) pos.x -= width;
    if (pos.y < 0) pos.y += height;
    if (pos.y > height) pos.y -= height;

    // Slowly change colour hue over time
    float h = hue(col);
    h += 0.5;
    if (h > 360) h -= 360;
    col = color(h, saturation(col), brightness(col), alpha(col));

    // Slightly oscillate size
    size = 10 + 10 * sin(frameCount * 0.01 + pos.x * 0.02 + pos.y * 0.02);
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(col);

    switch (shape) {
      case SHAPE_CIRCLE:
        ellipse(0, 0, size, size);
        break;

      case SHAPE_SQUARE:
        rectMode(CENTER);
        rect(0, 0, size, size);
        break;

      case SHAPE_TRIANGLE:
        triangle(-size/2, size/2, size/2, size/2, 0, -size/2);
        break;

      case SHAPE_HEXAGON:
        drawHexagon(size);
        break;

      case SHAPE_CUSTOM:
        drawCustomShape(size);
        break;
    }
    popMatrix();
  }

  /* ----------  Hexagon helper  ---------- */
  void drawHexagon(float sz) {
    float r = sz / 2.0;                // radius of circumscribed circle
    float angStep = TWO_PI / 6.0;      // 60°
    beginShape();
    for (int i = 0; i < 6; i++) {
      float a = angStep * i - PI / 6; // start at -30° so one side is flat
      vertex(cos(a) * r, sin(a) * r);
    }
    endShape(CLOSE);
  }

  /* ----------  Custom star helper  ---------- */
  void drawCustomShape(float sz) {
    int points = 5;
    float innerR = sz * 0.4;
    float outerR = sz * 0.5;
    float angStep = TWO_PI / points;
    beginShape();
    for (int i = 0; i < points * 2; i++) {
      float r = (i & 1) == 0 ? outerR : innerR;
      float ang = angStep * i - PI / 2; // start at the top
      vertex(cos(ang) * r, sin(ang) * r);
    }
    endShape(CLOSE);
  }
}
