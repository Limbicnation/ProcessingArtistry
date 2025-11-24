float sunX, sunY;
float angle = 0;
float declination;

void setup() {
  size(800, 800);
  background(0);
}

void draw() {
  background(0);
  
  // Calculate sun's position based on angle
  declination = sin(radians(angle)) * 23.44; // Earth's axial tilt
  sunX = width/2 + cos(radians(angle)) * 200 * cos(radians(declination));
  sunY = height/2 + sin(radians(angle)) * 200 * cos(radians(declination));
  
  // Draw the sun
  fill(255, 255, 0);
  ellipse(sunX, sunY, 20, 20);
  
  // Draw the analemma path (optional)
  stroke(255);
  noFill();
  ellipse(width/2, height/2, 400, 400);
  
  // Increment the angle
  angle += 0.1;
}
