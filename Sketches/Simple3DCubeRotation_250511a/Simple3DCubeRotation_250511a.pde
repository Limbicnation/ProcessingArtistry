void setup() {
  size(800, 600, P3D); // Set the size of the window and use P3D for 3D rendering
  smooth(); // Enable anti-aliasing for smoother edges
}

void draw() {
  background(255); // Clear the screen with white color
  lights(); // Add default lighting to the scene

  float time = millis() * 0.001; // Get the current time in seconds and slow down the rotation

  translate(width / 2, height / 2); // Move the origin to the center of the window

  rotateX(time); // Rotate around the X-axis
  rotateY(time); // Rotate around the Y-axis

  fill(255 * sin(time), 100, 255 * cos(time)); // Change color based on time

  box(100); // Draw a cube with side length 100
}
