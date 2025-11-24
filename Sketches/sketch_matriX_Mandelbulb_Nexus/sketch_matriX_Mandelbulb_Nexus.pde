int maxIterations = 20;
float power = 8.0;
float zoom = 2.5;
float angleX = 0;
float angleY = 0;
int pointDensity = 5; // Reduced point density
boolean recordFrames = false; // Toggle for recording frames

// For more dramatic size effects
float minDotSize = 8;
float maxDotSize = 32; // Increased maximum size
float noiseAmplitude = 6.5; // Increased noise amplitude

// Color scheme selection (0-4)
// 0: Blue-to-purple gradient (default)
// 1: Cool tones only (cyans, blues, purples)
// 2: Custom complementary colors (blue-green to magenta)
// 3: Monochromatic blue with depth variation
// 4: Psychedelic gradient with no reds
int colorScheme = 0;

void setup() {
  size(1024, 1024, P3D);
  colorMode(HSB, 360, 100, 100); // Set color mode to HSB for gradient
  // Create export directory
  if (recordFrames) {
    println("Recording frames enabled");
  }
}

void draw() {
  background(0);
  lights();
  translate(width / 2, height / 2, 0);
  rotateX(angleX);
  rotateY(angleY);
  
  // Time-based animation for noise
  float time = frameCount * 0.02;
  
  for (int i = -pointDensity; i <= pointDensity; i++) {
    for (int j = -pointDensity; j <= pointDensity; j++) {
      for (int k = -pointDensity; k <= pointDensity; k++) {
        float x = map(i, -pointDensity, pointDensity, -zoom, zoom);
        float y = map(j, -pointDensity, pointDensity, -zoom, zoom);
        float z = map(k, -pointDensity, pointDensity, -zoom, zoom);
        
        int iterations = mandelbulb(x, y, z);
        if (iterations < maxIterations) {
          // Calculate distance from center
          float distanceFromCenter = sqrt(x*x + y*y + z*z);
          float normalizedDistance = distanceFromCenter / zoom;
          
          // Color calculation based on selected scheme
          float hue = 0, saturation = 0, brightness = 0;
          
          switch(colorScheme) {
            case 0:
              // Blue-to-purple gradient (no red)
              hue = map(distanceFromCenter, 0, zoom, 180, 300);
              saturation = map(iterations, 0, maxIterations, 85, 100);
              brightness = map(normalizedDistance, 0, 1, 100, 90); // Added depth variation
              break;
              
            case 1:
              // Cool tones only (cyans, blues, purples)
              hue = map(iterations, 0, maxIterations, 180, 270);
              saturation = map(normalizedDistance, 0, 1, 70, 100);
              brightness = map(normalizedDistance, 0, 1, 100, 85);
              break;
              
            case 2:
              // Custom complementary colors (blue-green to magenta)
              hue = map(sin(normalizedDistance * PI), -1, 1, 165, 300);
              saturation = 90 + sin(iterations * 0.5) * 10;
              brightness = 100 - (normalizedDistance * 15);
              break;
              
            case 3:
              // Monochromatic blue with depth variation
              hue = 220; // Fixed blue hue
              saturation = map(iterations, 0, maxIterations, 50, 100);
              brightness = map(normalizedDistance, 0, 1, 100, 60); // More dramatic depth
              break;
              
            case 4:
              // Psychedelic gradient with no reds
              float angle = atan2(y, x);
              hue = map(angle, -PI, PI, 120, 300);
              saturation = 80 + sin(iterations * 0.7) * 20;
              brightness = 90 + cos(normalizedDistance * PI * 2) * 10;
              break;
          }
          
          // ENHANCED RANDOM SIZING:
          
          // 1. Base size now varies more dramatically with distance from center
          float baseDotSize = map(normalizedDistance, 0, 1, maxDotSize, minDotSize);
          
          // 2. Stronger noise influence near center with unique seed per coordinate
          float noiseInfluence = pow(1.0 - normalizedDistance, 2) * 2.0; // Exponential falloff
          
          // 3. Use multiple noise sources with different scales for more organic feel
          float noiseValue1 = noise(x * 0.5, y * 0.5, z * 0.5 + time);
          float noiseValue2 = noise(x * 1.2, y * 1.2, z * 1.2 - time * 0.7);
          float combinedNoise = (noiseValue1 * 0.7 + noiseValue2 * 0.3);
          
          // 4. More dramatic size variation
          float sizeVariation = map(combinedNoise, 0, 1, -noiseAmplitude, noiseAmplitude) * noiseInfluence;
          
          // 5. Add iteration-based scaling factor to give structure
          float iterationFactor = map(iterations, 0, maxIterations, 1.2, 0.8);
          
          // Final dot size with multiple influences
          float dotSize = constrain(baseDotSize * iterationFactor + sizeVariation, minDotSize, maxDotSize);
          
          // Set the color and size for the point
          stroke(hue, saturation, brightness);
          strokeWeight(dotSize);
          
          // Draw the point
          point(x * 100, y * 100, z * 100);
        }
      }
    }
  }
  
  angleX += 0.01;
  angleY += 0.015;
  
  // Export frame if recording is enabled
  if (recordFrames) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/sketch_matriX_Mandelbulb_Nexus/matriX_Mandelbulb_Nexus-######.jpg");
  }
}

// Press 'r' to toggle recording
// Press 'c' to cycle through color schemes
void keyPressed() {
  if (key == 'r' || key == 'R') {
    recordFrames = !recordFrames;
    if (recordFrames) {
      println("Recording started");
    } else {
      println("Recording stopped");
    }
  }
  else if (key == 'c' || key == 'C') {
    // Cycle through color schemes
    colorScheme = (colorScheme + 1) % 5;
    println("Color scheme changed to: " + colorScheme);
  }
}

int mandelbulb(float x, float y, float z) {
  float cx = x;
  float cy = y;
  float cz = z;
  int iterations = 0;
  
  while (iterations < maxIterations) {
    float r = sqrt(cx * cx + cy * cy + cz * cz);
    if (r > 2.0) {
      break;
    }
    
    float theta = atan2(sqrt(cx * cx + cy * cy), cz);
    float phi = atan2(cy, cx);
    
    float zr = pow(r, power);
    float ztheta = theta * power;
    float zphi = phi * power;
    
    cx = zr * sin(ztheta) * cos(zphi) + x;
    cy = zr * sin(ztheta) * sin(zphi) + y;
    cz = zr * cos(ztheta) + z;
    
    iterations++;
  }
  
  return iterations;
}
