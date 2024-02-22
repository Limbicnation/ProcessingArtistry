float x = 0, y = 0, z = 0;         // Initialize variables to store position coordinates
float rx = 0, ry = 0, rz = 0;      // Initialize variables to store rotation angles
int size = 150;                    // Size of the cube

void setup() {
  size(640, 640, P3D);             // Set up window dimensions with 3D rendering
  colorMode(HSB, 255);             // Set color mode to HSB with a max value of 255 for H, S, and B
  strokeWeight(2);                 // Set thickness of edges
}

void draw() {
  background(0);                   // Clear screen with black color
  translate(width / 2, height / 2);// Move origin to center of screen
  pushMatrix();                    // Save the current transformation matrix
  rotateY(ry);                     // Rotate around Y-axis
  rotateX(rx);                     // Rotate around X-axis
  fill(map(sin(frameCount * 0.01), -1, 1, 0, 255), 255, 255); // Color based on sin wave
  box(size);                       // Display cube
  popMatrix();                     // Restore the original transformation matrix

  rx += 0.01;                      // Increment rotation angle around X-axis
  ry += 0.01;                      // Increment rotation angle around Y-axis
}
