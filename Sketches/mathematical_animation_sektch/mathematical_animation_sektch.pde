void setup() {
  size(800, 600);
  background(0);
  noStroke();
}

void draw() {
  // Fade background
  fill(0, 15);
  rect(0, 0, width, height);
  
  // Advanced mathematical patterns
  for (int i = 0; i < 70; i++) {
    // Polar coordinate functions
    float angle = frameCount * 0.02 + i * 0.3;
    float radius = 70 + sin(frameCount * 0.01 + i * 0.1) * 40;
    
    // Add complex mathematical functions
    float complexRadius = radius + sin(frameCount * 0.03 + i * 0.2) * 20;
    complexRadius += cos(frameCount * 0.02 + i * 0.15) * 15;
    complexRadius += tan(frameCount * 0.015 + i * 0.1) * 10;
    
    float x = width/2 + cos(angle) * complexRadius;
    float y = height/2 + sin(angle) * complexRadius;
    
    // Advanced wave patterns
    float size = 20 + sin(frameCount * 0.03 + i) * 15;
    size += cos(frameCount * 0.02 + i * 0.5) * 8;
    size += sin(frameCount * 0.04 + i * 0.3) * 12;
    
    // Color based on mathematical functions
    float hue = (frameCount * 2 + i * 10 + sin(frameCount * 0.01 + i) * 100) % 360;
    
    fill(hue, 200, 255, 150);
    ellipse(x, y, size, size);
  }
  
  // Fractal-like patterns using recursive math
  for (int i = 0; i < 30; i++) {
    float t = frameCount * 0.01 + i * 0.2;
    
    // Logistic map pattern
    float logistic = 0.5;
    for (int j = 0; j < 5; j++) {
      logistic = 3.8 * logistic * (1 - logistic);
    }
    
    float x = width/2 + cos(t * 3) * (100 + logistic * 50);
    float y = height/2 + sin(t * 2) * (100 + logistic * 50);
    
    float size = 12 + sin(frameCount * 0.02 + i) * 8;
    size += abs(logistic - 0.5) * 20;
    
    fill(255, 150, 200, 180);
    ellipse(x, y, size, size);
  }
  
  // Fourier series approximation
  for (int i = 0; i < 25; i++) {
    float angle = frameCount * 0.015 + i * 0.4;
    
    // Add harmonic series
    float radius = 50 + sin(frameCount * 0.005 + i * 0.2) * 30;
    radius += sin(frameCount * 0.01 + i * 0.3) * 15;
    radius += cos(frameCount * 0.008 + i * 0.25) * 10;
    
    float x = width/2 + cos(angle) * radius;
    float y = height/2 + sin(angle) * radius;
    
    float size = 18 + sin(frameCount * 0.04 + i * 0.3) * 12;
    size += cos(frameCount * 0.03 + i * 0.2) * 8;
    
    fill(100, 255, 200, 160);
    ellipse(x, y, size, size);
  }
  
  // Central complex orb with mathematical functions
  float complexSize = 50 + sin(frameCount * 0.07) * 20;
  complexSize += cos(frameCount * 0.05) * 15;
  complexSize += tan(frameCount * 0.03) * 10;
  
  fill(255, 255, 100, 150);
  ellipse(width/2, height/2, complexSize, complexSize);
  
  // Text prompt
  fill(255);
  textSize(20);
  text("Advanced Mathematical Animation", 20, 30);
}
