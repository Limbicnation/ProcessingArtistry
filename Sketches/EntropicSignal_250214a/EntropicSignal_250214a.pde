/**
 *  Entropic Signal — Procedural Glitch Aesthetics
 *  ------------------------------------------------
 *  Refactored from fully_self_contained_processing_sketch.pde
 *  with three glitch corruption layers:
 *    1. RGB Channel Split (temporal chromatic displacement)
 *    2. Pixel Sorting (brightness-bounded scanline sorting)
 *    3. Scanline Displacement (horizontal slice jitter)
 *
 *  All glitch parameters are modulated by internal oscillators
 *  (sin/noise) to maintain rhythmic, synchronized visual flow.
 *
 *  Controls:
 *    R       : Toggle frame recording
 *    1       : Toggle RGB split
 *    2       : Toggle pixel sorting
 *    3       : Toggle scanline displacement
 *    UP/DOWN : Glitch intensity
 *    +/-     : Particle count
 *    SPACE   : Reset glitch phase
 */

// ─────── Configuration ─────────────────────────────────────────────
int NUM_PARTICLES = 500;
Particle[] particles;

// Glitch parameters
boolean enableRGBSplit = true;
boolean enablePixelSort = true;
boolean enableScanlines = true;
float glitchIntensity = 1.0;     // Master intensity multiplier
float rgbSplitMax = 12.0;       // Max RGB displacement in pixels
float sortThreshLow = 25;        // Brightness threshold (dark bound)
float sortThreshHigh = 200;      // Brightness threshold (bright bound)
float sortPercentage = 0.4;      // Fraction of rows to sort per frame
float scanlineJitterMax = 15;    // Max horizontal pixel displacement

// Shape identifiers
final int SHAPE_CIRCLE   = 0;
final int SHAPE_SQUARE   = 1;
final int SHAPE_TRIANGLE = 2;
final int SHAPE_HEXAGON  = 3;
final int SHAPE_CUSTOM   = 4;

// Recording
boolean recording = false;
int recordStartFrame = 0;

// Internal time (oscillator phase)
float time = 0;

void setup() {
  size(1080, 720, P2D);
  smooth(4);
  frameRate(30);
  colorMode(HSB, 360, 100, 100, 100);
  background(0);

  particles = new Particle[NUM_PARTICLES];
  for (int i = 0; i < NUM_PARTICLES; i++) {
    particles[i] = new Particle();
  }

  println("Entropic Signal");
  println("─────────────────");
  println("R     : Toggle recording");
  println("1/2/3 : Toggle RGB split / Pixel sort / Scanlines");
  println("UP/DN : Glitch intensity");
  println("+/-   : Particle count");
  println("SPACE : Reset phase");
}

void draw() {
  time += 0.01;

  // ── Fade trails ──
  blendMode(BLEND);
  noStroke();
  fill(0, 0, 0, 12);
  rect(0, 0, width, height);

  // ── Draw particle substrate ──
  blendMode(ADD);
  for (Particle p : particles) {
    p.update(time);
    p.display();
  }
  blendMode(BLEND);

  // ── GLITCH LAYER 1: RGB Channel Split ──
  if (enableRGBSplit) {
    applyRGBSplit(time);
  }

  // ── GLITCH LAYER 2: Pixel Sorting ──
  if (enablePixelSort) {
    applyPixelSort(time);
  }

  // ── GLITCH LAYER 3: Scanline Displacement ──
  if (enableScanlines) {
    applyScanlineDisplacement(time);
  }

  // ── HUD ──
  displayHUD();

  // ── Recording ──
  if (recording) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/EntropicSignal/frame_######.png");
  }
}

// ═══════════════════════════════════════════════════════════════════
// GLITCH MODULE 1: RGB Channel Split
// Displaces R and B channels using oscillating offset vectors.
// The displacement amplitude breathes via sin() at irrational
// frequency ratios, ensuring non-repeating chromatic fracture.
// ═══════════════════════════════════════════════════════════════════
void applyRGBSplit(float t) {
  float maxShift = rgbSplitMax * glitchIntensity;

  // Irrational frequency ratios for non-repeating patterns
  float dxR = sin(t * 1.7) * maxShift;
  float dyR = cos(t * 2.3) * maxShift * 0.5;
  float dxB = sin(t * 1.3 + 2) * maxShift;
  float dyB = cos(t * 1.9 + 2) * maxShift * 0.5;

  loadPixels();
  int[] src = pixels.clone();

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int idx = y * width + x;

      // Red channel: displaced
      int rx = constrain(int(x + dxR), 0, width - 1);
      int ry = constrain(int(y + dyR), 0, height - 1);
      int rSrc = src[ry * width + rx];

      // Blue channel: displaced opposite
      int bx = constrain(int(x + dxB), 0, width - 1);
      int by = constrain(int(y + dyB), 0, height - 1);
      int bSrc = src[by * width + bx];

      // Green stays in place
      int gSrc = src[idx];

      // Reconstruct pixel: R from displaced, G from original, B from displaced
      int r = (rSrc >> 16) & 0xFF;
      int g = (gSrc >> 8) & 0xFF;
      int b = bSrc & 0xFF;
      int a = (gSrc >> 24) & 0xFF;

      pixels[idx] = (a << 24) | (r << 16) | (g << 8) | b;
    }
  }
  updatePixels();
}

// ═══════════════════════════════════════════════════════════════════
// GLITCH MODULE 2: Pixel Sorting
// Sorts horizontal spans of pixels by brightness, but only within
// a threshold band. Thresholds oscillate sinusoidally, making the
// sorted regions breathe in and out. Rows are selected via Perlin
// noise for organic distribution.
// ═══════════════════════════════════════════════════════════════════
void applyPixelSort(float t) {
  // Breathing threshold modulation
  float breathe = sin(t * 0.8) * 0.3 + 0.7;
  float tLow = sortThreshLow * breathe * glitchIntensity;
  float tHigh = sortThreshHigh * breathe;

  int rowsToSort = int(height * sortPercentage * glitchIntensity);
  rowsToSort = min(rowsToSort, height);

  loadPixels();

  for (int i = 0; i < rowsToSort; i++) {
    // Noise-selected row for organic distribution
    int y = int(noise(i * 0.1 + t) * height);
    y = constrain(y, 0, height - 1);

    // Extract row brightness values and find sortable spans
    int rowStart = y * width;

    // Find spans within threshold and sort
    int spanStart = -1;
    for (int x = 0; x <= width; x++) {
      float br = 0;
      if (x < width) {
        int c = pixels[rowStart + x];
        br = ((c >> 16 & 0xFF) + (c >> 8 & 0xFF) + (c & 0xFF)) / 3.0;
      }

      boolean inRange = x < width && br > tLow && br < tHigh;

      if (inRange && spanStart == -1) {
        spanStart = x;
      } else if (!inRange && spanStart != -1) {
        // Sort this span by brightness (insertion sort for small spans)
        sortPixelSpan(rowStart + spanStart, x - spanStart);
        spanStart = -1;
      }
    }
  }
  updatePixels();
}

// Insertion sort for a span of pixels by brightness
void sortPixelSpan(int start, int len) {
  for (int i = 1; i < len; i++) {
    int key = pixels[start + i];
    float keyBr = pixelBrightness(key);
    int j = i - 1;
    while (j >= 0 && pixelBrightness(pixels[start + j]) > keyBr) {
      pixels[start + j + 1] = pixels[start + j];
      j--;
    }
    pixels[start + j + 1] = key;
  }
}

float pixelBrightness(int c) {
  return ((c >> 16 & 0xFF) + (c >> 8 & 0xFF) + (c & 0xFF)) / 3.0;
}

// ═══════════════════════════════════════════════════════════════════
// GLITCH MODULE 3: Scanline Displacement
// Slices the image into horizontal bands and jitters them
// horizontally using noise-driven offsets. Band height and jitter
// amplitude oscillate at different frequencies for polyrhythmic
// visual interference. Evokes CRT signal disruption.
// ═══════════════════════════════════════════════════════════════════
void applyScanlineDisplacement(float t) {
  float maxJitter = scanlineJitterMax * glitchIntensity;

  // Oscillating band height
  int bandH = int(8 + sin(t * 1.1) * 6);
  bandH = max(2, bandH);

  loadPixels();
  int[] src = pixels.clone();

  for (int y = 0; y < height; y++) {
    int band = y / bandH;

    // Noise-driven jitter per band
    float jitterF = (noise(band * 0.3 + t * 0.5) - 0.5) * 2 * maxJitter;

    // Probabilistic activation per band
    float prob = sin(t * 2.7 + band * 0.2) * 0.5 + 0.5;
    int jitter = 0;
    if (random(1) < prob * 0.6) {
      jitter = int(jitterF);
    }

    for (int x = 0; x < width; x++) {
      int srcX = ((x + jitter) % width + width) % width;
      pixels[y * width + x] = src[y * width + srcX];
    }
  }
  updatePixels();
}

// ═══════════════════════════════════════════════════════════════════
// HUD OVERLAY
// ═══════════════════════════════════════════════════════════════════
void displayHUD() {
  pushStyle();
  colorMode(RGB, 255);
  fill(255);
  noStroke();
  textAlign(LEFT, TOP);
  textSize(12);
  text("FPS: " + nf(frameRate, 0, 1), 10, 10);
  text("Particles: " + NUM_PARTICLES, 10, 26);
  text("Intensity: " + nf(glitchIntensity, 0, 1), 10, 42);
  text("RGB:" + (enableRGBSplit ? "ON" : "off") +
       "  Sort:" + (enablePixelSort ? "ON" : "off") +
       "  Scan:" + (enableScanlines ? "ON" : "off"), 10, 58);

  if (recording) {
    fill(255, 40, 40);
    ellipse(width - 20, 20, 12, 12);
    fill(255);
    textAlign(RIGHT, TOP);
    text("REC " + (frameCount - recordStartFrame), width - 32, 14);
  }
  popStyle();
}

// ═══════════════════════════════════════════════════════════════════
// INPUT HANDLING
// ═══════════════════════════════════════════════════════════════════
void keyPressed() {
  if (key == 'r' || key == 'R') {
    recording = !recording;
    if (recording) {
      recordStartFrame = frameCount;
      println("Recording started");
    } else {
      println("Recording stopped - " + (frameCount - recordStartFrame) + " frames");
    }
  } else if (key == '1') {
    enableRGBSplit = !enableRGBSplit;
    println("RGB Split: " + (enableRGBSplit ? "ON" : "OFF"));
  } else if (key == '2') {
    enablePixelSort = !enablePixelSort;
    println("Pixel Sort: " + (enablePixelSort ? "ON" : "OFF"));
  } else if (key == '3') {
    enableScanlines = !enableScanlines;
    println("Scanlines: " + (enableScanlines ? "ON" : "OFF"));
  } else if (key == '+' || key == '=') {
    NUM_PARTICLES = min(NUM_PARTICLES + 50, 1000);
    rebuildParticles();
    println("Particles: " + NUM_PARTICLES);
  } else if (key == '-' || key == '_') {
    NUM_PARTICLES = max(NUM_PARTICLES - 50, 50);
    rebuildParticles();
    println("Particles: " + NUM_PARTICLES);
  } else if (key == ' ') {
    time = 0;
    println("Phase reset");
  } else if (key == CODED) {
    if (keyCode == UP) {
      glitchIntensity = min(glitchIntensity + 0.1, 3.0);
      println("Intensity: " + nf(glitchIntensity, 0, 1));
    } else if (keyCode == DOWN) {
      glitchIntensity = max(glitchIntensity - 0.1, 0.0);
      println("Intensity: " + nf(glitchIntensity, 0, 1));
    }
  }
}

void rebuildParticles() {
  Particle[] newP = new Particle[NUM_PARTICLES];
  for (int i = 0; i < NUM_PARTICLES; i++) {
    if (i < particles.length) {
      newP[i] = particles[i];
    } else {
      newP[i] = new Particle();
    }
  }
  particles = newP;
}

// ═══════════════════════════════════════════════════════════════════
// PARTICLE CLASS — the substrate signal
// ═══════════════════════════════════════════════════════════════════
class Particle {
  PVector pos;
  PVector vel;
  float sz;
  float hue;
  int shapeType;

  Particle() {
    pos = new PVector(random(width), random(height));
    vel = new PVector(0, 0);
    sz = random(4, 20);
    hue = random(360);
    shapeType = int(random(5));
  }

  void update(float t) {
    float nX = noise(pos.x * 0.005, pos.y * 0.005, t * 0.3);
    float nY = noise(pos.x * 0.005 + 100, pos.y * 0.005 + 100, t * 0.3);
    vel.x = map(nX, 0, 1, -1.5, 1.5);
    vel.y = map(nY, 0, 1, -1.5, 1.5);
    vel.add(random(-0.1, 0.1), random(-0.1, 0.1));
    pos.add(vel);

    if (pos.x < 0) pos.x += width;
    if (pos.x > width) pos.x -= width;
    if (pos.y < 0) pos.y += height;
    if (pos.y > height) pos.y -= height;

    hue = (hue + 0.5) % 360;
    sz = 10 + 8 * sin(t * 2 + pos.x * 0.02 + pos.y * 0.02);
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(hue, 80, 95, 60);

    switch (shapeType) {
      case SHAPE_CIRCLE:
        ellipse(0, 0, sz, sz);
        break;
      case SHAPE_SQUARE:
        rectMode(CENTER);
        rect(0, 0, sz, sz);
        break;
      case SHAPE_TRIANGLE:
        triangle(-sz/2, sz/2, sz/2, sz/2, 0, -sz/2);
        break;
      case SHAPE_HEXAGON:
        drawHexagon(sz);
        break;
      case SHAPE_CUSTOM:
        drawStar(sz);
        break;
    }
    popMatrix();
  }

  void drawHexagon(float s) {
    float r = s / 2.0;
    beginShape();
    for (int i = 0; i < 6; i++) {
      float a = TWO_PI / 6 * i - PI / 6;
      vertex(cos(a) * r, sin(a) * r);
    }
    endShape(CLOSE);
  }

  void drawStar(float s) {
    float inner = s * 0.4;
    float outer = s * 0.5;
    beginShape();
    for (int i = 0; i < 10; i++) {
      float r = (i % 2 == 0) ? outer : inner;
      float a = TWO_PI / 5 * i - HALF_PI;
      vertex(cos(a) * r, sin(a) * r);
    }
    endShape(CLOSE);
  }
}
