void setup() {
  size(800, 600);
  smooth();
  noStroke();
  frameRate(25); // Set frame rate to 25 FPS
}

float time = 0;
boolean saveFrames = true; // Flag to enable or disable frame saving

void draw() {
  background(0);

  // Loop through colors
  float r = sin(frameCount * 0.01) * 128 + 128;
  float g = sin(frameCount * 0.02 + PI / 2) * 128 + 128;
  float b = sin(frameCount * 0.03 + PI) * 128 + 128;

  // Draw shapes with increased size
  fill(r, g, b);
  beginShape();
  for (int i = 0; i < 100; i++) {
    float x = map(i, 0, 99, 0, width);
    float y = sin(frameCount * 0.001 + map(i, 0, 99, 0, TWO_PI)) * (height / 1.5);
    vertex(x, y + height / 2);
  }
  endShape();

  float noiseVal = noise(frameCount * 0.01) * 10;
  for (int i = 0; i < 20; i++) {
    float x = width / 2 + cos(frameCount * 0.001 + map(i, 0, 19, 0, TWO_PI)) * width / 5;
    float y = height / 2 - sin(frameCount * 0.001 + map(i, 0, 19, 0, PI)) * height / 10 + noiseVal;

    // Use noise function for smooth size variation
    float noiseOffset = noise(frameCount * 0.001 + i) * 256;
    float size = 24 + noiseOffset; // Range from 32 to 96
    ellipse(x, y, size, size);
  }

  // Save frames if enabled
  if (saveFrames) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/NoiseWaveAnim_20240801a/NoiseParticleAnimation_20240801a-####.png");
  }

  time += 0.001;
}
