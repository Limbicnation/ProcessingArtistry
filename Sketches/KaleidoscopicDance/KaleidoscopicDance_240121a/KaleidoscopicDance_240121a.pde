// Number of shapes
int numShapes = 25;

// Arrays for properties of shapes
float[] x = new float[numShapes];
float[] y = new float[numShapes];
float[] speedX = new float[numShapes];
float[] speedY = new float[numShapes];
float[] size = new float[numShapes];
float[] angle = new float[numShapes];
color[] colors = new color[numShapes];

// Variable for controlling the image saving
boolean saveFrames = false;

void setup() {
  size(1280, 960);
  noStroke();
  frameRate(30);

  // Initializing the variables
  for (int i = 0; i < numShapes; i++) {
    x[i] = random(width);
    y[i] = random(height);
    speedX[i] = random(-5, 5);
    speedY[i] = random(-5, 5);
    size[i] = random(15, 120);
    angle[i] = random(TWO_PI);
    colors[i] = color(random(255), random(255), random(255), 100);
  }
}

void draw() {
  // Semi-transparent background for a trail effect
  fill(0, 15);
  rect(0, 0, width, height);

  for (int i = 0; i < numShapes; i++) {
    pushMatrix();
    translate(x[i], y[i]);
    rotate(angle[i]);

    // Dynamic color change
    colors[i] = color(127 + 127 * sin(frameCount * 0.01 + i), 
                      127 + 127 * sin(frameCount * 0.02 + i), 
                      127 + 127 * sin(frameCount * 0.03 + i), 
                      100);

    fill(colors[i]);

    // Shape variation
    if (i % 2 == 0) {
      ellipse(0, 0, size[i], size[i]);
    } else {
      rectMode(CENTER);
      rect(0, 0, size[i], size[i]);
    }

    popMatrix();

    // Updating position and angle
    x[i] += speedX[i];
    y[i] += speedY[i];
    angle[i] += random(-0.5, 0.5);

    // Bouncing off the edges
    if ((x[i] - size[i]/2 < 0) || (x[i] + size[i]/2 > width)) {
      speedX[i] *= -1;
    }
    if ((y[i] - size[i]/2 < 0) || (y[i] + size[i]/2 > height)) {
      speedY[i] *= -1;
    }
  }

  // Saving the frames
  if (saveFrames) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/KaleidoscopicDance/frame-####.jpg");
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrames = !saveFrames; // Toggle frame saving
  }
}
