// Global variables for rotation
float rotX = 0;
float rotY = 0;
float targetRotX = 0;
float targetRotY = 0;
float easing = 0.05; // Smoothing factor for rotation

// Fractal parameters
int maxLevel = 3;      // Maximum recursion depth (controls complexity, adjustable: +/-)
float baseSize = 150;  // Size of the initial cube
float scaleFactor = 0.5; // How much smaller the cubes get at each level

// Animation control variables
float time = 0;             // Simulation time variable for animation progression
boolean autoAnimate = true; // Flag to control automatic animation (toggle with 'A')
float pausedTime = 0;       // To store simulation time when animation is paused
float animSpeed = 1.0;      // Animation speed multiplier (adjustable: UP/DOWN)
float lastMillis = 0;       // For delta time calculation

// Recording variables
boolean isRecording = false;      // Flag to control recording state (toggle with 'S')
String recordingPrefix = "fractal_sequence_"; // Prefix for recorded files
int recordingStartFrame = 0;      // Store the starting frame number for recording info

void setup() {
  // Use P3D renderer for 3D graphics
  size(1024, 768, P3D);
  // Set color mode to HSB for easier color cycling
  // Hue (0-360), Saturation (0-100), Brightness (0-100)
  colorMode(HSB, 360, 100, 100);

  // Set a consistent frame rate for smoother animation and recording
  frameRate(60);

  // Initialize time variables for delta time calculation
  lastMillis = millis();
  time = 0; // Start simulation time at 0
  pausedTime = time; // Initialize pausedTime

  println("Instructions:");
  println("- Move mouse to rotate.");
  println("- Press 'A' to toggle automatic animation.");
  println("- Press 'S' to toggle frame sequence recording.");
  println("- Use UP/DOWN arrows to change animation speed.");
  println("- Use '+/-' keys to increase/decrease fractal complexity.");
  println("- Press 'R' to reset parameters.");
  println("--------------------------------------------------");
}

void draw() {
  // --- Delta Time Calculation ---
  float currentMillis = millis();
  // Calculate time elapsed since last frame (adjust multiplier for desired time scale, e.g., 0.001 for seconds)
  float deltaTime = (currentMillis - lastMillis) * 0.001;
  lastMillis = currentMillis;

  // --- Update Simulation Time ---
  if (autoAnimate) {
    // Only advance simulation time if animating, scaled by animSpeed
    time += deltaTime * animSpeed;
  }
  // 'time' now always represents the correct simulation time, whether paused or running.

  // --- Update Rotation ---
  // Smoothly update rotation towards the target rotation based on mouse position
  targetRotX = map(mouseY, 0, height, -PI, PI);
  targetRotY = map(mouseX, 0, width, -PI, PI);
  rotX += (targetRotX - rotX) * easing;
  rotY += (targetRotY - rotY) * easing;

  // --- Rendering ---
  // Set background color with subtle gradient based on simulation time
  background(200 + sin(time) * 20, 10, 10); // Dark background with subtle hue shift

  // Improved lighting setup
  ambientLight(100, 0, 60); // Darker ambient light
  pointLight(360, 0, 100, 0, 0, 300); // White point light from front
  // Color-shifting directional light based on simulation time
  directionalLight(time * 20 % 360, 80, 80, 0.5, 0.5, -1);

  // --- Transformations ---
  // Center the coordinate system
  translate(width / 2, height / 2, 0);

  // Apply global rotation based on smoothed mouse input
  rotateX(rotX);
  rotateY(rotY);

  // Apply a slow, continuous Z-axis rotation using the simulation time
  rotateZ(time * 0.5);

  // --- Draw Fractal ---
  // Start the recursive drawing process, passing the simulation time
  drawFractal(0, 0, 0, baseSize, 0, time);

  // --- Display Overlay ---
  // Display recording indicator and information overlay
  displayInfo(frameRate, time); // Pass current frameRate and simulation time

  // --- Save Frame (if recording) ---
  if (isRecording) {
    // Use ###### for 6-digit padding in filename
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/InteractiveCubeFractal/" + recordingPrefix + "######.png");
  }
}

// Display information overlay (2D)
void displayInfo(float fps, float currentSimTime) {
  // Temporarily switch to 2D drawing mode for the overlay
  camera(); // Reset camera to default 2D perspective
  hint(DISABLE_DEPTH_TEST); // Disable depth testing for 2D overlay
  noLights(); // Disable lights for 2D overlay

  // Style for text
  fill(360, 0, 100); // White text
  textAlign(LEFT, TOP);
  textSize(14);

  // Display information
  text("FPS: " + nf(fps, 0, 1), 10, 10);
  text("Animation speed: " + nf(animSpeed, 0, 2) + "x", 10, 30);
  text("Fractal depth: " + maxLevel, 10, 50);
  text("Time: " + nf(currentSimTime, 0, 2), 10, 70); // Display simulation time

  // Recording indicator
  if (isRecording) {
    fill(0, 100, 100); // Red color for recording indicator
    ellipse(width - 20, 20, 15, 15); // Draw red circle
    fill(360, 0, 100); // Switch back to white for text
    textAlign(RIGHT, TOP); // Align text to the right
    text("RECORDING", width - 40, 15);
    text("Frames: " + (frameCount - recordingStartFrame), width - 40, 35);
  }

  // Restore 3D settings
  hint(ENABLE_DEPTH_TEST); // Re-enable depth testing
}

// Recursive function to draw the fractal (using simulation time)
void drawFractal(float x, float y, float z, float size, int level, float currentSimTime) {
  // Base case: Stop recursion if max level is reached
  if (level > maxLevel) {
    return;
  }

  // Save the current transformation matrix
  pushMatrix();
  // Move to the position of this cube
  translate(x, y, z);

  // Enhanced rotation for more dynamic movement, scaled by level
  float levelFactor = map(level, 0, maxLevel, 1.0, 0.3);
  rotateX(sin(currentSimTime * 2 + level * 0.5) * 0.1 * levelFactor);
  rotateY(cos(currentSimTime * 2 - level * 0.5) * 0.1 * levelFactor);
  rotateZ(sin(currentSimTime + level) * 0.05 * levelFactor);

  // --- Improved visual styling ---
  // Calculate color with better contrast between levels
  float hue = (currentSimTime * 50 + level * 60) % 360; // Wider hue separation
  float saturation = 80 + sin(currentSimTime * 3 + level) * 20;
  float brightness = 70 + sin(currentSimTime * 4 - level * 0.8) * 30; // More variation

  // Alpha transparency based on level with pulsing effect
  float pulseFactor = sin(currentSimTime * 3 + level * 2) * 0.2 + 0.8; // 0.6-1.0 range
  float alpha = map(level, 0, maxLevel, 255, 100) * pulseFactor;

  fill(hue, saturation, brightness, alpha * 0.8);

  // More pronounced stroke for better definition
  strokeWeight(map(level, 0, maxLevel, 2.5, 0.5));
  stroke((hue + 180) % 360, 70, 100, alpha); // Complementary color

  // Draw the cube with slight random variations for a more organic look
  if (level == 0) {
    // Main cube is always a perfect box
    box(size);
  } else {
    // Slightly distort child cubes using deterministic randomness based on position/time
    float jitterSeed = x * 0.1 + y * 0.2 + z * 0.3 + currentSimTime + level;
    float jitter = map(level, 1, maxLevel, 0.02, 0.1);
    // Use noise() for smoother jitter if preferred over random()
    // float sizeX = size * (1 + (noise(jitterSeed) - 0.5) * 2 * jitter);
    // float sizeY = size * (1 + (noise(jitterSeed + 10) - 0.5) * 2 * jitter);
    // float sizeZ = size * (1 + (noise(jitterSeed + 20) - 0.5) * 2 * jitter);
    float sizeX = size * (1 + random(-jitter, jitter)); // Original random jitter
    float sizeY = size * (1 + random(-jitter, jitter));
    float sizeZ = size * (1 + random(-jitter, jitter));
    box(sizeX, sizeY, sizeZ);
  }

  // --- Recursive calls with improved branching logic ---
  float newSize = size * scaleFactor;
  float offset = (size / 2.0) + (newSize / 2.0);

  // Define the 6 directions with slight variations (turbulence)
  float turbulence = map(level, 0, maxLevel, 0.0, 0.1) * sin(currentSimTime + level);
  float[][] directions = {
    {offset * (1 + turbulence), 0, 0},
    {-offset * (1 - turbulence), 0, 0},
    {0, offset * (1 + turbulence), 0},
    {0, -offset * (1 - turbulence), 0},
    {0, 0, offset * (1 + turbulence)},
    {0, 0, -offset * (1 - turbulence)}
  };

  // Adaptive probability based on level
  float probability = map(level, 0, maxLevel, 0.9, 0.6);

  // Use deterministic randomization based on position and time for consistent patterns
  for (int i = 0; i < 6; i++) {
    // Create a predictable but varying seed for randomization
    // Using sin() for pseudo-randomness based on state
    float seed = sin(x + y + z + i + currentSimTime * 0.5 + level * 10) * 0.5 + 0.5; // Range 0.0 to 1.0
    if (seed < probability) {
      drawFractal(directions[i][0], directions[i][1], directions[i][2], newSize, level + 1, currentSimTime);
    }
  }

  popMatrix(); // Restore the previous transformation matrix
}

// Enhanced key handling function
void keyPressed() {
  // Toggle automatic animation
  if (key == 'a' || key == 'A') {
    autoAnimate = !autoAnimate; // Flip the state
    if (!autoAnimate) {
      // Store the current simulation time when pausing
      pausedTime = time;
      println("Animation Paused at time: " + nf(pausedTime, 0, 2));
    } else {
      // When resuming, the delta time calculation in draw() will handle continuing correctly.
      // We might want to adjust lastMillis here to avoid a potential time jump caused by
      // the time taken to process the pause itself, but often it's negligible.
      // lastMillis = millis(); // Optional adjustment
      println("Animation Resumed at time: " + nf(time, 0, 2));
    }
  }

  // Toggle recording mode
  else if (key == 's' || key == 'S') {
    isRecording = !isRecording; // Flip the state
    if (isRecording) {
      recordingStartFrame = frameCount; // Store frame number when recording starts
      println("Recording started - saving to " + recordingPrefix + "######.png");
    } else {
      int framesRecorded = frameCount - recordingStartFrame; // Calculate frames saved
      println("Recording stopped - " + framesRecorded + " frames saved.");
    }
  }

  // Adjust animation speed
  else if (key == CODED) {
    if (keyCode == UP) {
      animSpeed = min(animSpeed + 0.1, 3.0); // Increase speed, max 3.0x
      println("Animation speed: " + nf(animSpeed, 0, 1) + "x");
    } else if (keyCode == DOWN) {
      animSpeed = max(animSpeed - 0.1, 0.1); // Decrease speed, min 0.1x
      println("Animation speed: " + nf(animSpeed, 0, 1) + "x");
    }
  }

  // Adjust fractal complexity
  else if (key == '+' || key == '=') { // Handle '+' key (often requires shift)
    maxLevel = min(maxLevel + 1, 5); // Increase depth, limit max level for performance
    println("Fractal depth increased to: " + maxLevel);
  } else if (key == '-' || key == '_') { // Handle '-' key
    maxLevel = max(maxLevel - 1, 1); // Decrease depth, minimum level of 1
    println("Fractal depth decreased to: " + maxLevel);
  }

  // Reset to default values
  else if (key == 'r' || key == 'R') {
    maxLevel = 3;
    animSpeed = 1.0;
    // Reset other parameters if desired (e.g., baseSize, scaleFactor)
    // baseSize = 150;
    // scaleFactor = 0.5;
    time = 0; // Reset simulation time
    pausedTime = time;
    rotX = 0; // Reset rotation
    rotY = 0;
    println("Reset to default values (Depth, Speed, Time, Rotation)");
  }
}
