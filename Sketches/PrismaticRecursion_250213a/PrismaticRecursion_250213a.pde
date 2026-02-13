// Prismatic Recursion — Fractal Light Decomposition
// Recursive branching structures with prismatic color cycling
// Controls:
//   +/- : Adjust recursion depth (2-7)
//   UP/DOWN : Color shift speed
//   LEFT/RIGHT : Rotation speed
//   B : Cycle branch count (2-5)
//   O : Cycle organism count (1-6)
//   R : Reset parameters
//   S : Toggle frame recording

float GOLDEN_ANGLE = 137.508; // phyllotaxis angle in degrees

// Parameters
int maxDepth = 5;
int branchCount = 3;
int organismCount = 3;
float colorSpeed = 1.0;
float rotationSpeed = 1.0;
float branchScale = 0.67;
float trailOpacity = 18;
float spreadAngle = 60; // degrees

// State
float time = 0;
boolean isRecording = false;
int recordingStartFrame = 0;

// Organism data arrays
float[] orgX, orgY, orgBaseLen, orgBaseHue, orgPhase, orgRot;

void setup() {
  size(1200, 1200, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(60);
  initializeSystem();

  println("Prismatic Recursion");
  println("-------------------");
  println("+/- : Recursion depth");
  println("UP/DOWN : Color speed");
  println("LEFT/RIGHT : Rotation speed");
  println("B : Branch count");
  println("O : Organism count");
  println("R : Reset");
  println("S : Toggle recording");
}

void initializeSystem() {
  randomSeed(12345);
  time = 0;

  orgX = new float[organismCount];
  orgY = new float[organismCount];
  orgBaseLen = new float[organismCount];
  orgBaseHue = new float[organismCount];
  orgPhase = new float[organismCount];
  orgRot = new float[organismCount];

  for (int i = 0; i < organismCount; i++) {
    float angle = (TWO_PI / organismCount) * i + random(-0.3, 0.3);
    float dist = random(80, 200);
    orgX[i] = width / 2.0 + cos(angle) * dist;
    orgY[i] = height / 2.0 + sin(angle) * dist;
    orgBaseLen[i] = random(100, 180);
    orgBaseHue[i] = (i * GOLDEN_ANGLE + random(0, 30)) % 360;
    orgPhase[i] = random(0, TWO_PI);
    orgRot[i] = random(-PI, PI);
  }

  background(0, 0, 5);
}

void draw() {
  // Semi-transparent overlay for trails
  noStroke();
  fill(0, 0, 5, trailOpacity);
  rect(0, 0, width, height);

  time += 0.008 * rotationSpeed;

  for (int i = 0; i < organismCount; i++) {
    pushMatrix();
    translate(orgX[i], orgY[i]);
    rotate(orgRot[i] + time * 0.3);

    drawBranch(orgBaseLen[i], 0, orgBaseHue[i], orgPhase[i], time);
    popMatrix();
  }

  // HUD
  displayInfo();

  // Recording
  if (isRecording) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/PrismaticRecursion/frame_######.png");
  }
}

void drawBranch(float len, int depth, float hue, float phase, float t) {
  if (depth >= maxDepth || len < 2) return;

  // Oscillating angle offset per depth
  float breathe = sin(t * 1.7 + phase + depth * 0.8) * 0.3;
  float lenMod = len * (1.0 + sin(t * 0.9 + phase + depth * 1.1) * 0.08);

  // Prismatic color decomposition via golden angle
  float h = (hue + depth * GOLDEN_ANGLE * colorSpeed + t * 25 * colorSpeed) % 360;
  float s = map(depth, 0, maxDepth, 60, 95);
  float b = map(depth, 0, maxDepth, 100, 70);
  float a = map(depth, 0, maxDepth, 90, 40);

  // Stroke weight thins with depth
  float sw = map(depth, 0, maxDepth, 4.5, 0.6);
  strokeWeight(sw);
  stroke(h, s, b, a);

  // Draw branch segment
  line(0, 0, 0, -lenMod);

  // Move to branch tip
  translate(0, -lenMod);

  // Split into children
  float spreadRad = radians(spreadAngle);
  float totalSpread = spreadRad * (1.0 + breathe * 0.4);

  for (int i = 0; i < branchCount; i++) {
    float frac = branchCount == 1 ? 0 : (float(i) / (branchCount - 1)) - 0.5;
    float childAngle = frac * totalSpread;

    // Noise perturbation
    float nVal = noise(depth * 0.5 + i * 10 + t * 0.3 + phase);
    childAngle += (nVal - 0.5) * 0.4;

    pushMatrix();
    rotate(childAngle + breathe * 0.2);
    drawBranch(lenMod * branchScale, depth + 1, h, phase + i * 0.5, t);
    popMatrix();
  }
}

void displayInfo() {
  // 2D overlay
  pushStyle();
  fill(0, 0, 100);
  noStroke();
  textAlign(LEFT, TOP);
  textSize(14);
  text("FPS: " + nf(frameRate, 0, 1), 10, 10);
  text("Depth: " + maxDepth, 10, 30);
  text("Branches: " + branchCount, 10, 50);
  text("Organisms: " + organismCount, 10, 70);
  text("Color Speed: " + nf(colorSpeed, 0, 1), 10, 90);
  text("Rotation Speed: " + nf(rotationSpeed, 0, 1), 10, 110);

  if (isRecording) {
    fill(0, 100, 100);
    ellipse(width - 20, 20, 15, 15);
    fill(0, 0, 100);
    textAlign(RIGHT, TOP);
    text("REC " + (frameCount - recordingStartFrame), width - 35, 13);
  }
  popStyle();
}

void keyPressed() {
  if (key == '+' || key == '=') {
    maxDepth = min(maxDepth + 1, 7);
    println("Depth: " + maxDepth);
  } else if (key == '-' || key == '_') {
    maxDepth = max(maxDepth - 1, 2);
    println("Depth: " + maxDepth);
  } else if (key == 'b' || key == 'B') {
    branchCount = (branchCount % 4) + 2; // cycles 2-5
    println("Branches: " + branchCount);
  } else if (key == 'o' || key == 'O') {
    organismCount = (organismCount % 6) + 1; // cycles 1-6
    initializeSystem();
    println("Organisms: " + organismCount);
  } else if (key == 'r' || key == 'R') {
    maxDepth = 5;
    branchCount = 3;
    organismCount = 3;
    colorSpeed = 1.0;
    rotationSpeed = 1.0;
    branchScale = 0.67;
    trailOpacity = 18;
    spreadAngle = 60;
    initializeSystem();
    println("Reset to defaults");
  } else if (key == 's' || key == 'S') {
    isRecording = !isRecording;
    if (isRecording) {
      recordingStartFrame = frameCount;
      println("Recording started");
    } else {
      println("Recording stopped - " + (frameCount - recordingStartFrame) + " frames");
    }
  } else if (key == CODED) {
    if (keyCode == UP) {
      colorSpeed = min(colorSpeed + 0.1, 3.0);
      println("Color speed: " + nf(colorSpeed, 0, 1));
    } else if (keyCode == DOWN) {
      colorSpeed = max(colorSpeed - 0.1, 0.1);
      println("Color speed: " + nf(colorSpeed, 0, 1));
    } else if (keyCode == RIGHT) {
      rotationSpeed = min(rotationSpeed + 0.1, 3.0);
      println("Rotation speed: " + nf(rotationSpeed, 0, 1));
    } else if (keyCode == LEFT) {
      rotationSpeed = max(rotationSpeed - 0.1, 0.1);
      println("Rotation speed: " + nf(rotationSpeed, 0, 1));
    }
  }
}
