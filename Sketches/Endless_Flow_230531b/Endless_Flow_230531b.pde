float angle = 0;
float radius = 300;

void setup() {
  size(800, 800, P3D);
  frameRate(30);
  background(0);
  noStroke();
}

void draw() {
  background(0);
  
  // Animate the angle and radius
  angle += 0.01;
  radius += random(-1, 1);
  
  // Calculate the center position of the canvas
  float centerX = width / 2;
  float centerY = height / 2;
  
  // Duplicate the animation 10 times with Z offset
  for (int j = 0; j < 15; j++) {
    float zOffset = j * 75; // Adjust the Z offset value as needed
    
    // Draw the intricate details
    for (int i = 0; i < 100; i++) {
      float x = centerX + cos(angle + i * 0.1) * radius;
      float y = centerY + sin(angle + i * 0.1) * radius;
      float z = zOffset;
      
      // Calculate the size and color based on noise
      float size = noise(x * 0.01, y * 0.01, (frameCount + zOffset) * 0.01) * 300;
      float hue = map(x, 0, width, 0, 255);
      float saturation = map(y, 0, height, 100, 200);
      
      // Set the fill color
      fill(hue, saturation, 255);
      
      // Draw the intricate shape with 3D coordinates
      pushMatrix();
      translate(x, y, z);
      ellipse(0, 0, size, size);
      popMatrix();
    }
  }
  
  // Save frames as PNG images
  //saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/Endless_Flow/frame_" + nf(frameCount, 4) + ".png");
}
