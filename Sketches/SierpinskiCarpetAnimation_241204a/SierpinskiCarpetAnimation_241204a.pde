// SierpinskiCarpetAnimation.pde
// Save this file in a folder named 'SierpinskiCarpetAnimation'

import java.io.File;

float order = 0;      // Current fractional order
float targetOrder = 0; // Target integer order
int maxOrder = 5;     // Maximum order
float animationSpeed = 0.05; // Speed of transition
boolean recording = false;   // Toggle for recording frames
int totalFrames = 300;      // Total number of frames for animation
int currentFrame = 0;       // Current frame counter
File framesFolder;

void setup() {
  size(800, 800);
  frameRate(30);
  
  // Create frames directory if it doesn't exist
  framesFolder = new File("/home/gero/GitHub/Processing_Lab/Processing_Output/SierpinskiCarpetAnimation");
  if (!framesFolder.exists()) {
    framesFolder.mkdirs();
    println("Created frames directory");
  }
  
  // Uncomment the next line to start recording immediately
  // recording = true;
}

void draw() {
  background(255);
  
  // Calculate progress through animation
  if (recording) {
    float progress = float(currentFrame) / totalFrames;
    order = (progress * (maxOrder + 1)) % (maxOrder + 1);
    targetOrder = ceil(order);
  } else {
    // Interactive animation logic
    if (order < targetOrder) {
      order = min(order + animationSpeed, targetOrder);
    }
    
    // Automatically increment target order when current order reaches target
    if (order >= targetOrder && frameCount % 60 == 0) {
      targetOrder = (targetOrder + 1) % (maxOrder + 1);
    }
  }
  
  // Draw from the center of the screen
  float size = width * 0.8; // 80% of screen width
  float x = (width - size) / 2;
  float y = (height - size) / 2;
  
  drawSierpinskiCarpet(x, y, size, order);
  
  // Save frames if recording is enabled
  if (recording) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/SierpinskiCarpetAnimation/sierpinski_####.png");
    currentFrame++;
    if (currentFrame >= totalFrames) {
      println("Recording complete! " + totalFrames + " frames saved in: " + framesFolder.getAbsolutePath());
      println("Convert to GIF using: ffmpeg -i sierpinski_%04d.png -vf 'scale=800:800' output.gif");
      exit();
    }
  }
}

void drawSierpinskiCarpet(float x, float y, float size, float level) {
  if (level <= 0) {
    // For fractional levels, interpolate the color
    float fraction = 1 - (level < 0 ? 0 : level);
    fill(lerp(255, 0, fraction));
    noStroke();
    rect(x, y, size, size);
  } else {
    float newSize = size / 3.0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (i != 1 || j != 1) { // Skip the center square
          drawSierpinskiCarpet(x + i * newSize, y + j * newSize, newSize, level - 1);
        }
      }
    }
  }
}

void mousePressed() {
  // Manual control: Click to advance to next order
  targetOrder = (targetOrder + 1) % (maxOrder + 1);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    // Start recording when 'R' is pressed
    recording = true;
    currentFrame = 0;
    println("Recording started... Saving frames to: " + framesFolder.getAbsolutePath());
  }
}
