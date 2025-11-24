float noiseScale = 0.01;
float noiseSpeed = 0.02;
float time = 0;

void setup() {
  size(800, 600);
  background(0);
  noStroke();
  colorMode(HSB, 360, 100, 100, 1);
}

void draw() {
  // Semi-transparent overlay for trail effect
  fill(0, 0.05);
  rect(0, 0, width, height);
  
  time = frameCount * 0.01;
  
  // Combine trigonometric and noise functions for complex motion
  for (int i = 0; i < 120; i++) {
    // Base trigonometric position
    float baseAngle = time * 0.5 + i * 0.1;
    float baseRadius = 100 + sin(time * 0.3 + i * 0.05) * 50;
    
    // Add noise perturbation to position
    float noiseX = noise(i * noiseScale + time * noiseSpeed) * 200 - 100;
    float noiseY = noise(i * noiseScale + time * noiseSpeed + 1000) * 200 - 100;
    
    // Combine trigonometric and noise for final position
    float x = width/2 + cos(baseAngle) * baseRadius + noiseX;
    float y = height/2 + sin(baseAngle) * baseRadius + noiseY;
    
    // Use noise for size modulation
    float size = 8 + noise(i * noiseScale + time * noiseSpeed + 2000) * 25;
    
    // Use trigonometric functions for color variation
    float hue = (time * 20 + i * 3 + 
                sin(time * 0.5 + i * 0.1) * 100 + 
                noise(i * noiseScale + time * noiseSpeed + 3000) * 100) % 360;
    
    float saturation = 80 + sin(time + i * 0.1) * 20;
    float brightness = 70 + noise(i * noiseScale + time * noiseSpeed + 4000) * 30;
    
    fill(hue, saturation, brightness, 0.8);
    
    // Add shape variation (circle vs ellipse)
    if (i % 3 == 0) {
      ellipse(x, y, size, size);
    } else if (i % 3 == 1) {
      float ellipseWidth = size * (0.5 + noise(i * noiseScale + time * noiseSpeed + 5000) * 0.5);
      float ellipseHeight = size * (0.5 + noise(i * noiseScale + time * noiseSpeed + 6000) * 0.5);
      ellipse(x, y, ellipseWidth, ellipseHeight);
    } else {
      // Triangle shapes
      pushMatrix();
      translate(x, y);
      rotate(time + i * 0.1);
      triangle(0, -size/2, -size/2, size/2, size/2, size/2);
      popMatrix();
    }
  }
  
  // Add noise-based orbital patterns with trigonometric influence
  for (int i = 0; i < 30; i++) {
    // Trigonometric base orbit
    float orbitAngle = time * 0.3 + i * TWO_PI / 30;
    float orbitRadius = 300 + sin(time * 0.2 + i) * 100;
    
    // Noise perturbation to orbit
    float noisePerturb = noise(orbitAngle * 2 + time * noiseSpeed * 5) * 50;
    orbitRadius += noisePerturb;
    
    // Trigonometric variation to position
    float x = width/2 + cos(orbitAngle) * orbitRadius;
    float y = height/2 + sin(orbitAngle) * orbitRadius;
    
    // Add noise to position for organic feel
    x += noise(i * noiseScale + time * noiseSpeed + 7000) * 30;
    y += noise(i * noiseScale + time * noiseSpeed + 8000) * 30;
    
    float size = 5 + sin(time * 2 + i) * 5 + noise(i * noiseScale + time * noiseSpeed + 9000) * 10;
    
    // Color based on position and time
    float hue = (time * 15 + i * 12) % 360;
    float sat = 60 + noise(i * noiseScale + time * noiseSpeed + 10000) * 40;
    
    fill(hue, sat, 80, 0.9);
    ellipse(x, y, size, size);
  }
  
  // Central noise-trigonometric orb
  float centerX = width/2 + 
                  sin(time) * 30 + 
                  noise(time * noiseSpeed + 1500) * 40;
  
  float centerY = height/2 + 
                  cos(time * 0.7) * 30 + 
                  noise(time * noiseSpeed + 2500) * 40;
  
  float orbSize = 30 + 
                  sin(time * 2) * 15 + 
                  noise(time * noiseSpeed + 3500) * 20;
  
  float hue = (time * 25) % 360;
  fill(hue, 80, 90, 0.95);
  ellipse(centerX, centerY, orbSize, orbSize);
  
  // Add some text with noise influence
  float textX = width/2 + noise(time * noiseSpeed + 4000) * 100;
  float textY = 50 + noise(time * noiseSpeed + 5000) * 20;
  
  fill(255, 0.8);
  textSize(18);
  textAlign(CENTER);
  text("Trig + Noise Animation", textX, textY);
}
