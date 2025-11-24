float f = 1;
float w = 256; // Try increasing this for larger wave patterns
float detail = 0.05; // Detail level for x and z increments
float rotationSpeed = 0.05; // Speed of rotation
int maxW = 800; // Canvas size

void settings() {
  size(maxW, maxW, P3D); // Define the size of the sketch
}

void setup() {
  noiseDetail(8, 0.3f);
}

void draw() {
  background(0);
  lights(); // Ensure the scene is lit
  rotateY(f * rotationSpeed);

  translate(width/2, height/2); // Center the drawing in the window

  // Iterate over a grid
  for (float x = -PI; x < PI; x += PI * detail) {
    for (float z = -PI; z < PI; z += PI * detail) {
      pushMatrix();
      float y = map(sin(x + f), -1, 1, -w, w);
      float noiseValue = noise(x * detail, z * detail, f);
      float d = map(noiseValue, 0, 2, -w/2, w/2); // Adjust range for visibility
      float r = map(cos(z + f), -1, 1, -w, w);

      translate(y, d, r);

      // Ensure sphere size is visible
      float sphereSize = map(abs(d), 0, w, 25, 50); // Adjust min and max size as needed
      sphere(sphereSize);

      popMatrix();
    }
  }
  
  f += 0.01; // Increment frame variable for animation
}
