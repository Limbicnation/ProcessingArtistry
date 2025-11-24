// AbstractGeometryAnimator.pde
// Press 's' to save frame, 'r' to randomize parameters, 'n' to randomize noise
int numShapes = 8;
float angleStep = 0.02;
float[] baseSize = new float[numShapes];
float[] sizeVariation = new float[numShapes];
float[] shapeSpeeds = new float[numShapes];
float[] noiseScales = new float[numShapes];  // Individual noise scale for each shape
float[] noiseAmplitudes = new float[numShapes];  // Individual noise amplitude for each shape
color[] shapeColors = new color[numShapes];
float globalHue = 0;
float pulse = 0;
float pulseSpeed = 0.075;

// Global noise parameter ranges
float MIN_NOISE_SCALE = 0.1;
float MAX_NOISE_SCALE = 1.0;
float MIN_NOISE_AMPLITUDE = 5;
float MAX_NOISE_AMPLITUDE = 256;

// Size parameter ranges
float MIN_BASE_SIZE = 15;
float MAX_BASE_SIZE = 35;
float MIN_SIZE_VARIATION = 2;
float MAX_SIZE_VARIATION = 256;

void setup() {
  size(800, 800, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  smooth();
  noStroke();
  blendMode(NORMAL);
  initializeShapes();
}

void draw() {
  background(0);
  
  // Update global parameters
  globalHue = (globalHue + 0.5) % 360;
  pulse = sin(frameCount * pulseSpeed) * 50;
  
  translate(width/2, height/2);
  
  for (int i = 0; i < numShapes; i++) {
    pushMatrix();
    float angle = frameCount * angleStep + i * TWO_PI/numShapes;
    float radius = 150 + pulse + i * 2;
    
    // Calculate dynamic properties
    float currentSize = baseSize[i] + sizeVariation[i] * abs(sin(frameCount * 0.02 + i));
    PVector position = calculatePosition(angle, radius, currentSize, i);
    
    translate(position.x, position.y);
    rotate(frameCount * shapeSpeeds[i]);
    updateColor(i);
    createShape(i % 3, currentSize, noiseScales[i], noiseAmplitudes[i]);
    
    popMatrix();
  }
  
  // Save frame after everything is drawn
  if (isRecording) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/DynamicNoiseGeometry/abstract-######.jpg");
  }
}

void initializeShapes() {
  for (int i = 0; i < numShapes; i++) {
    baseSize[i] = random(MIN_BASE_SIZE, MAX_BASE_SIZE);
    sizeVariation[i] = random(MIN_SIZE_VARIATION, MAX_SIZE_VARIATION);
    shapeSpeeds[i] = random(-0.02, 0.07);
    shapeColors[i] = color(random(128), 80, 90, 50);
    randomizeNoiseParams(i);
  }
}

void randomizeNoiseParams(int index) {
  noiseScales[index] = random(MIN_NOISE_SCALE, MAX_NOISE_SCALE);
  noiseAmplitudes[index] = random(MIN_NOISE_AMPLITUDE, MAX_NOISE_AMPLITUDE);
}

PVector calculatePosition(float angle, float radius, float size, int index) {
  float x = radius * cos(angle);
  float y = radius * sin(angle);
  float wobbleX = cos(frameCount * 0.01 + index) * (size * 0.5);
  float wobbleY = sin(frameCount * 0.01 + index) * (size * 0.5);
  return new PVector(x + wobbleX, y + wobbleY);
}

void updateColor(int index) {
  fill((hue(shapeColors[index]) + globalHue) % 360, 
       saturation(shapeColors[index]), 
       brightness(shapeColors[index]), 
       alpha(shapeColors[index]));
}

void createShape(int type, float size, float noiseScale, float noiseAmplitude) {
  switch(type) {
    case 0: // Circle with noisy edges
      beginShape();
      int numPoints = 32;
      for (int i = 0; i < numPoints + 1; i++) {
        float angle = map(i, 0, numPoints, 0, TWO_PI);
        float radius = size/2 + noise(cos(angle) * noiseScale, 
                                    sin(angle) * noiseScale, 
                                    frameCount * 0.02) * noiseAmplitude;
        float x = cos(angle) * radius;
        float y = sin(angle) * radius;
        vertex(x, y);
      }
      endShape(CLOSE);
      break;
      
    case 1: // Rectangle with noisy edges
      beginShape();
      for (int i = 0; i < 4; i++) {
        float angle = i * HALF_PI;
        int steps = 8; // Points per side
        for (int j = 0; j < steps; j++) {
          float t = j / float(steps);
          float nextAngle = (i + 1) * HALF_PI;
          float currX = lerp(cos(angle), cos(nextAngle), t) * size/2;
          float currY = lerp(sin(angle), sin(nextAngle), t) * size/2;
          
          float noise = noise(currX * noiseScale, 
                            currY * noiseScale, 
                            frameCount * 0.02) * noiseAmplitude;
          float nx = currX + cos(angle + HALF_PI) * noise;
          float ny = currY + sin(angle + HALF_PI) * noise;
          vertex(nx, ny);
        }
      }
      endShape(CLOSE);
      break;
      
    case 2: // Triangle with smoother noisy edges
      beginShape();
      float triSize = size * 1.25;
      PVector[] triPoints = {
        new PVector(-triSize/2, triSize/2),
        new PVector(triSize/2, triSize/2),
        new PVector(0, -triSize/2)
      };
      
      int steps = 32; // Increased number of steps for smoother edges
      float timeScale = 0.01; // Slower time scale for noise
      
      for (int i = 0; i < 3; i++) {
        PVector curr = triPoints[i];
        PVector next = triPoints[(i + 1) % 3];
        
        for (int j = 0; j < steps; j++) {
          float t = j / float(steps);
          // Use smoothstep interpolation for smoother transition
          float smoothT = t * t * (3 - 2 * t);
          float x = lerp(curr.x, next.x, smoothT);
          float y = lerp(curr.y, next.y, smoothT);
          
          float angle = atan2(next.y - curr.y, next.x - curr.x) + HALF_PI;
          
          // Modified noise calculation for smoother effect
          float noiseVal = noise(
            x * noiseScale * 0.5, 
            y * noiseScale * 0.5, 
            frameCount * timeScale
          );
          // Smooth the noise using curve
          float smoothNoise = noiseVal * noiseVal * (3 - 2 * noiseVal);
          float displacement = smoothNoise * noiseAmplitude * 0.75;
          
          x += cos(angle) * displacement;
          y += sin(angle) * displacement;
          vertex(x, y);
        }
      }
      endShape(CLOSE);
      break;
  }
}

// Keyboard controls for adjusting parameters
// Add recording state variable at the top with other globals
boolean isRecording = false;

void keyPressed() {
  if (key == 's') {
    isRecording = !isRecording; // Toggle recording state
    if (isRecording) {
      println("Started recording frames...");
    } else {
      println("Stopped recording frames.");
    }
  }
  if (key == 'r') initializeShapes();
  if (key == 'n') {
    // Randomize noise parameters for all shapes
    for (int i = 0; i < numShapes; i++) {
      randomizeNoiseParams(i);
    }
  }
  // Noise scale controls
  if (key == '[') {
    MIN_NOISE_SCALE = constrain(MIN_NOISE_SCALE - 0.1, 0.1, MAX_NOISE_SCALE);
    MAX_NOISE_SCALE = constrain(MAX_NOISE_SCALE - 0.1, MIN_NOISE_SCALE, 2.0);
  }
  if (key == ']') {
    MAX_NOISE_SCALE = constrain(MAX_NOISE_SCALE + 0.1, MIN_NOISE_SCALE, 2.0);
    MIN_NOISE_SCALE = constrain(MIN_NOISE_SCALE + 0.1, 0.1, MAX_NOISE_SCALE);
  }
  // Noise amplitude controls
  if (key == '-') {
    MIN_NOISE_AMPLITUDE = constrain(MIN_NOISE_AMPLITUDE - 2, 1, MAX_NOISE_AMPLITUDE);
    MAX_NOISE_AMPLITUDE = constrain(MAX_NOISE_AMPLITUDE - 2, MIN_NOISE_AMPLITUDE, 50);
  }
  if (key == '=') {
    MAX_NOISE_AMPLITUDE = constrain(MAX_NOISE_AMPLITUDE + 2, MIN_NOISE_AMPLITUDE, 50);
    MIN_NOISE_AMPLITUDE = constrain(MIN_NOISE_AMPLITUDE + 2, 1, MAX_NOISE_AMPLITUDE);
  }
  // Base size controls
  if (key == 'q') {
    MIN_BASE_SIZE = constrain(MIN_BASE_SIZE - 5, 5, MAX_BASE_SIZE);
    MAX_BASE_SIZE = constrain(MAX_BASE_SIZE - 5, MIN_BASE_SIZE, 100);
    initializeShapes();
  }
  if (key == 'w') {
    MAX_BASE_SIZE = constrain(MAX_BASE_SIZE + 5, MIN_BASE_SIZE, 100);
    MIN_BASE_SIZE = constrain(MIN_BASE_SIZE + 5, 5, MAX_BASE_SIZE);
    initializeShapes();
  }
  // Size variation controls
  if (key == 'a') {
    MIN_SIZE_VARIATION = constrain(MIN_SIZE_VARIATION - 10, 0, MAX_SIZE_VARIATION);
    MAX_SIZE_VARIATION = constrain(MAX_SIZE_VARIATION - 10, MIN_SIZE_VARIATION, 500);
    initializeShapes();
  }
  if (key == 'd') { // Changed from 's' to 'd' to avoid conflict with save function
    MAX_SIZE_VARIATION = constrain(MAX_SIZE_VARIATION + 10, MIN_SIZE_VARIATION, 500);
    MIN_SIZE_VARIATION = constrain(MIN_SIZE_VARIATION + 10, 0, MAX_SIZE_VARIATION);
    initializeShapes();
  }
}
