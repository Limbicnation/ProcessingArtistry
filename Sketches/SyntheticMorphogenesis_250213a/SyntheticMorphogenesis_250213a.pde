// Synthetic Morphogenesis — Bioluminescent Fractal Organisms
// Living, breathing creatures built from recursive tentacles
// Controls:
//   +/- : Tentacle recursion depth (2-7)
//   UP/DOWN : Breath rate
//   LEFT/RIGHT : Color shift speed
//   T : Cycle tentacle count (3-12)
//   O : Cycle organism count (1-5)
//   D : Toggle drift
//   R : Reset all parameters
//   S : Toggle frame recording

float GOLDEN_ANGLE = 137.508;
float PHI = 1.6180339887;

// Parameters
int tentacleDepth = 5;
int tentacleCount = 6;
int organismCount = 3;
float breathRate = 1.0;
float colorShiftSpeed = 1.0;
float driftSpeed = 0.5;
float bodySize = 40;
float trailAlpha = 10;
float branchSpread = 0.7;

// State
float time = 0;
boolean isRecording = false;
int recordingStartFrame = 0;

// Organism arrays
int MAX_ORGANISMS = 6;
float[] orgX = new float[MAX_ORGANISMS];
float[] orgY = new float[MAX_ORGANISMS];
int[] orgSymmetry = new int[MAX_ORGANISMS];
float[] orgBaseHue = new float[MAX_ORGANISMS];
float[] orgPhase = new float[MAX_ORGANISMS];
float[] orgBodyR = new float[MAX_ORGANISMS];
float[] orgPulseFreq = new float[MAX_ORGANISMS];
float[] orgTentLen = new float[MAX_ORGANISMS];
float[] orgNoiseX = new float[MAX_ORGANISMS];
float[] orgNoiseY = new float[MAX_ORGANISMS];

void setup() {
  size(1200, 1200, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(60);
  initializeSystem();

  println("Synthetic Morphogenesis");
  println("------------------------");
  println("+/- : Tentacle depth");
  println("UP/DOWN : Breath rate");
  println("LEFT/RIGHT : Color speed");
  println("T : Tentacle count");
  println("O : Organism count");
  println("D : Toggle drift");
  println("R : Reset");
  println("S : Toggle recording");
}

void initializeSystem() {
  randomSeed(12345);
  time = 0;

  for (int i = 0; i < organismCount; i++) {
    float angle = (TWO_PI / organismCount) * i + random(-0.5, 0.5);
    float dist = random(150, 350);
    orgX[i] = width / 2.0 + cos(angle) * dist;
    orgY[i] = height / 2.0 + sin(angle) * dist;
    orgSymmetry[i] = int(random(3, tentacleCount + 1));
    orgBaseHue[i] = (i * GOLDEN_ANGLE + random(0, 60)) % 360;
    orgPhase[i] = random(0, TWO_PI);
    orgBodyR[i] = bodySize * random(0.8, 1.3);
    orgPulseFreq[i] = random(0.8, 1.5);
    orgTentLen[i] = random(60, 120);
    orgNoiseX[i] = random(0, 1000);
    orgNoiseY[i] = random(0, 1000);
  }

  background(240, 40, 4);
}

void draw() {
  // Trail overlay
  noStroke();
  fill(240, 40, 4, trailAlpha);
  rect(0, 0, width, height);

  time += 0.012;

  for (int i = 0; i < organismCount; i++) {
    updateOrganism(i);
    drawOrganism(i);
  }

  displayInfo();

  if (isRecording) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/SyntheticMorphogenesis/frame_######.png");
  }
}

void updateOrganism(int idx) {
  float nx = noise(orgNoiseX[idx] + time * 0.15 * driftSpeed);
  float ny = noise(orgNoiseY[idx] + time * 0.15 * driftSpeed);
  orgX[idx] += (nx - 0.5) * 2.0 * driftSpeed;
  orgY[idx] += (ny - 0.5) * 2.0 * driftSpeed;

  float margin = 100;
  if (orgX[idx] < -margin) orgX[idx] = width + margin;
  if (orgX[idx] > width + margin) orgX[idx] = -margin;
  if (orgY[idx] < -margin) orgY[idx] = height + margin;
  if (orgY[idx] > height + margin) orgY[idx] = -margin;
}

void drawOrganism(int idx) {
  pushMatrix();
  translate(orgX[idx], orgY[idx]);

  float breathCycle = time * breathRate * orgPulseFreq[idx] + orgPhase[idx];
  int sym = orgSymmetry[idx];
  float bR = orgBodyR[idx];

  // Draw body
  drawBody(bR, sym, breathCycle, orgBaseHue[idx]);

  // Draw tentacles
  for (int i = 0; i < sym; i++) {
    float tentAngle = (TWO_PI / sym) * i;
    tentAngle += sin(breathCycle * PHI + i) * 0.15;

    pushMatrix();
    rotate(tentAngle);
    translate(0, -bR * (0.8 + sin(breathCycle) * 0.15));
    drawTentacle(orgTentLen[idx], 0, breathCycle, i, orgBaseHue[idx]);
    popMatrix();
  }

  popMatrix();
}

void drawBody(float r, int lobes, float breathCycle, float baseHue) {
  float pulse = 1.0 + sin(breathCycle) * 0.12;
  float rr = r * pulse;
  float hShift = (time * 10 * colorShiftSpeed + baseHue) % 360;

  noStroke();

  // Glow halos
  for (int g = 3; g >= 0; g--) {
    float glowR = rr * (1.5 + g * 0.5);
    float alpha = map(g, 0, 3, 15, 3);
    fill((180 + hShift) % 360, 50, 80, alpha);
    beginShape();
    for (float a = 0; a <= TWO_PI; a += 0.05) {
      float lobeWobble = sin(a * lobes + breathCycle) * 0.25 + 1.0;
      vertex(cos(a) * glowR * lobeWobble, sin(a) * glowR * lobeWobble);
    }
    endShape(CLOSE);
  }

  // Body layers
  for (int layer = 2; layer >= 0; layer--) {
    float layerR = rr * (0.4 + layer * 0.3);
    float alpha = map(layer, 0, 2, 80, 25);
    float sat = map(layer, 0, 2, 70, 90);
    fill((180 + hShift + layer * 20) % 360, sat, 90, alpha);
    beginShape();
    for (float a = 0; a <= TWO_PI; a += 0.05) {
      float lobeWobble = sin(a * lobes + breathCycle + layer * 0.3) * 0.2 + 1.0;
      vertex(cos(a) * layerR * lobeWobble, sin(a) * layerR * lobeWobble);
    }
    endShape(CLOSE);
  }

  // Core
  fill((180 + hShift) % 360, 30, 100, 60);
  ellipse(0, 0, rr * 0.3, rr * 0.3);
}

void drawTentacle(float len, int depth, float breathCycle, int tentIndex, float baseHue) {
  if (depth >= tentacleDepth || len < 3) return;

  float wave = sin(breathCycle * PHI + depth * 0.9 + tentIndex * 0.7) * branchSpread * 0.5;
  float segLen = len * (0.9 + sin(breathCycle + depth * 1.3) * 0.08);

  // Color
  float h = (baseHue + depth * GOLDEN_ANGLE * colorShiftSpeed + time * 20 * colorShiftSpeed) % 360;
  float s = map(depth, 0, tentacleDepth, 80, 95);
  float b = map(depth, 0, tentacleDepth, 100, 55);
  float a = map(depth, 0, tentacleDepth, 70, 15);

  float sw = map(depth, 0, tentacleDepth, 3.5, 0.4);
  strokeWeight(sw);
  stroke(h, s, b, a);
  noFill();

  // Curved segment
  float endX = sin(wave) * segLen * 0.3;
  float endY = -segLen;
  float ctrlX = sin(wave + breathCycle * 0.3) * segLen * 0.5;
  float ctrlY = -segLen * 0.5;

  beginShape();
  vertex(0, 0);
  quadraticVertex(ctrlX, ctrlY, endX, endY);
  endShape();

  // Joint glow
  if (depth < 3) {
    noStroke();
    float nodeAlpha = map(depth, 0, 2, 40, 15);
    fill(h, s * 0.6, 100, nodeAlpha);
    ellipse(endX, endY, sw * 3, sw * 3);
  }

  // Recurse
  pushMatrix();
  translate(endX, endY);

  // Primary continuation
  float contAngle = wave * 0.6;
  pushMatrix();
  rotate(contAngle);
  drawTentacle(segLen * 0.72, depth + 1, breathCycle, tentIndex, baseHue);
  popMatrix();

  // Secondary branch
  if (depth < tentacleDepth - 1) {
    float bAngle = branchSpread * (depth % 2 == 0 ? 1 : -1);
    bAngle += sin(breathCycle + depth * 2) * 0.2;
    pushMatrix();
    rotate(bAngle);
    drawTentacle(segLen * 0.55, depth + 1, breathCycle + 0.5, tentIndex, baseHue);
    popMatrix();
  }

  popMatrix();
}

void displayInfo() {
  pushStyle();
  fill(0, 0, 100);
  noStroke();
  textAlign(LEFT, TOP);
  textSize(14);
  text("FPS: " + nf(frameRate, 0, 1), 10, 10);
  text("Depth: " + tentacleDepth, 10, 30);
  text("Tentacles: " + tentacleCount, 10, 50);
  text("Organisms: " + organismCount, 10, 70);
  text("Breath: " + nf(breathRate, 0, 1), 10, 90);

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
    tentacleDepth = min(tentacleDepth + 1, 7);
    println("Depth: " + tentacleDepth);
  } else if (key == '-' || key == '_') {
    tentacleDepth = max(tentacleDepth - 1, 2);
    println("Depth: " + tentacleDepth);
  } else if (key == 't' || key == 'T') {
    tentacleCount = (tentacleCount - 3 + 1) % 10 + 3; // cycles 3-12
    initializeSystem();
    println("Tentacles: " + tentacleCount);
  } else if (key == 'o' || key == 'O') {
    organismCount = (organismCount % 5) + 1;
    initializeSystem();
    println("Organisms: " + organismCount);
  } else if (key == 'd' || key == 'D') {
    driftSpeed = driftSpeed > 0 ? 0 : 0.5;
    println("Drift: " + (driftSpeed > 0 ? "ON" : "OFF"));
  } else if (key == 'r' || key == 'R') {
    tentacleDepth = 5;
    tentacleCount = 6;
    organismCount = 3;
    breathRate = 1.0;
    colorShiftSpeed = 1.0;
    driftSpeed = 0.5;
    bodySize = 40;
    trailAlpha = 10;
    branchSpread = 0.7;
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
      breathRate = min(breathRate + 0.1, 3.0);
      println("Breath rate: " + nf(breathRate, 0, 1));
    } else if (keyCode == DOWN) {
      breathRate = max(breathRate - 0.1, 0.2);
      println("Breath rate: " + nf(breathRate, 0, 1));
    } else if (keyCode == RIGHT) {
      colorShiftSpeed = min(colorShiftSpeed + 0.1, 3.0);
      println("Color speed: " + nf(colorShiftSpeed, 0, 1));
    } else if (keyCode == LEFT) {
      colorShiftSpeed = max(colorShiftSpeed - 0.1, 0.1);
      println("Color speed: " + nf(colorShiftSpeed, 0, 1));
    }
  }
}
