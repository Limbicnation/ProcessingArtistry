// Global variables for animation control
float noiseScale = 0.02; // TWEAK: Increased from 0.01 for finer, more detailed swirls
float time = 0;          // The "time" variable to animate the noise
float hueValue = 0;      // The current hue for color cycling
int step = 10;           // TWEAK: Decreased from 20 to 10 for a denser grid

void setup() {
  // Set the canvas size
  size(800, 800);
  
  // Set the color mode to HSB (Hue, Saturation, Brightness)
  colorMode(HSB, 360, 100, 100); 
  
  // Set the frame rate for a smoother, more controlled animation
  frameRate(60);
  
  // We will use lines, so we disable filling shapes
  noFill();
}

void draw() {
  // 1. Create a Stronger Trail/Feedback Effect
  // Draw a semi-transparent black rectangle. Alpha is increased to 20.
  fill(0, 0, 0, 20); // TWEAK: Increased opacity for a stronger, longer trail
  rect(0, 0, width, height);
  
  // 2. Animate the Hue (Color Cycling)
  // Increment the hue value and wrap it around 360.
  hueValue = (hueValue + 0.7) % 360; // TWEAK: Slightly faster color cycle
  
  // 3. Draw the Flow Field (The "Weave")
  // Use nested loops with the new, smaller 'step'
  for (int x = 0; x < width; x += step) {
    for (int y = 0; y < height; y += step) {
      
      // Calculate Perlin Noise value for the current (x, y) position and 'time'
      float noiseValue = noise(x * noiseScale, y * noiseScale, time);
      
      // Map the noise value (0.0 to 1.0) to an angle (0 to TWO_PI)
      // The angle determines the direction of the line.
      float angle = map(noiseValue, 0, 1, 0, TWO_PI * 4);
      
      // Calculate the offset for the line's endpoint
      float lineLength = 15; // Length of the line segment
      float offsetX = cos(angle) * lineLength;
      float offsetY = sin(angle) * lineLength;
      
      // --- TWEAK: Dynamic Color based on Direction ---
      // 1. Calculate the base hue, offset by the noise value for swirling colors.
      float currentHue = (hueValue + noiseValue * 100) % 360;
      
      // 2. Map the sine of the angle to the Brightness (50 to 100).
      // This makes lines pointing in certain directions brighter, creating a pulsing effect.
      float dynamicBrightness = map(sin(angle), -1, 1, 50, 100);
      
      // Set the stroke color
      stroke(currentHue, 100, dynamicBrightness);
      
      // Draw a line from the grid point (x, y) to the displaced point
      line(x, y, x + offsetX, y + offsetY);
    }
  }
  
  // 4. Advance the "Time"
  // Increment the time variable to move through the 3D Perlin noise space.
  time += 0.01; // TWEAK: Increased from 0.005 for faster, more energetic flow
}
