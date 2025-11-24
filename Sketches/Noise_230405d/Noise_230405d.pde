float noiseOffset = 0;

void setup() {
  size(600, 600);
  background(0);
  noStroke();
  smooth();
}

void draw() {
  background(0);
  noiseOffset += 0.01;
  
  for (int x = 0; x < width; x += 10) {
    for (int y = 0; y < height; y += 10) {
      float cellColor = getColor(x, y);
      fill(cellColor);
      rect(x, y, 10, 10);
    }
  }
}

float getColor(int x, int y) {
  float minDist = dist(width, height, 0, 0);
  float nearestX = 0;
  float nearestY = 0;
  
  for (int i = 0; i < 10; i++) {
    float px = random(width);
    float py = random(height);
    float d = dist(x, y, px, py);
    
    if (d < minDist) {
      minDist = d;
      nearestX = px;
      nearestY = py;
    }
  }
  
  float cellColor = noise(noiseOffset + nearestX / 100, noiseOffset + nearestY / 100) * 255;
  return cellColor;
}
