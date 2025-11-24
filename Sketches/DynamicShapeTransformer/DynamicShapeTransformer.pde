import java.io.File;

String outputFolder = "/home/gero/GitHub/Processing_Lab/Processing_Output/DynamicShapeTransformerNoGradient";
int frameCountMax = 400; // Maximum number of frames to save

// Number of shapes to generate
int numShapes = 100;

// Array to store shape properties: (x, y, radius/size, colorR, colorG, colorB, velocityX, velocityY, shapeType)
float[][] shapes = new float[numShapes][9];

// Define a cool dark background color (e.g., deep blue)
color backgroundColor = color(0, 25, 51); // RGB values for a deep blue

void setup() {
  size(1024, 800);
  frameRate(25); // Set the frame rate to 25 FPS
  
  // Ensure output folder exists
  File dir = new File(outputFolder);
  if (!dir.exists()) {
    boolean success = dir.mkdirs();
    if (success) {
      println("Directory created successfully");
    } else {
      println("Failed to create directory");
    }
  }

  // Initialize shapes with random properties
  for (int i = 0; i < numShapes; i++) {
    shapes[i] = new float[] {
      random(width),       // x
      random(height),      // y
      random(25, 128),     // radius/size (min: 20, max: 100)
      random(255),         // colorR
      random(255),         // colorG
      random(255),         // colorB
      random(-3, 3),       // velocityX
      random(-3, 3),       // velocityY
      int(random(0, 3))    // shapeType (0: circle, 1: square, 2: triangle)
    };
  }
}

void draw() {
  background(backgroundColor); // Set solid dark background

  // Update shapes' properties
  updateShapes();

  // Draw lines between connected shapes
  drawConnections();

  // Draw shapes on the frame
  drawShapes();
  
  // Save frames to the output folder
  if (frameCount <= frameCountMax) {
    saveFrame(outputFolder + "/frame-####.png");
  } else {
    noLoop();  // Stop after saving all frames
  }
}

void backgroundGradient() {
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.noStroke();
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    int c = lerpColor(color(255, 100, 100), color(100, 100, 255), inter);
    pg.fill(c);
    pg.rect(0, y, width, 1);
  }
  pg.endDraw();
  image(pg, 0, 0);
}

void drawShapes() {
  noStroke();  // No stroke for shapes
  for (float[] shape : shapes) {
    float x = shape[0];
    float y = shape[1];
    float size = shape[2];
    int colorR = (int)shape[3];
    int colorG = (int)shape[4];
    int colorB = (int)shape[5];
    int shapeType = (int)shape[8];

    fill(colorR, colorG, colorB);
    switch (shapeType) {
      case 0:  // Circle
        ellipse(x, y, size, size);
        break;
      case 1:  // Square
        rectMode(CENTER);
        rect(x, y, size, size);
        break;
      case 2:  // Triangle
        float halfSize = size / 2;
        triangle(
          x, y - halfSize * sqrt(3), 
          x + halfSize, y + halfSize * (1 - sqrt(3) / 3),
          x - halfSize, y + halfSize * (1 - sqrt(3) / 3)
        );
        break;
    }
  }
}

void drawConnections() {
  strokeWeight(1.75); // Increase line thickness

  for (int i = 0; i < numShapes; i++) {
    float x1 = shapes[i][0];
    float y1 = shapes[i][1];
    float colorR1 = shapes[i][3];
    float colorG1 = shapes[i][4];
    float colorB1 = shapes[i][5];

    for (int j = i + 1; j < numShapes; j++) {
      float x2 = shapes[j][0];
      float y2 = shapes[j][1];
      
      float distance = dist(x1, y1, x2, y2);
      
      // Draw a line if the distance is within a certain threshold
      if (distance < 128) {  // You can adjust this threshold value
        float colorR2 = shapes[j][3];
        float colorG2 = shapes[j][4];
        float colorB2 = shapes[j][5];

        // Calculate direction vector and step size for interpolation
        float dx = x2 - x1;
        float dy = y2 - y1;
        int numSteps = 50; // Number of steps to interpolate colors smoothly

        beginShape();
        noFill();

        for (int step = 0; step <= numSteps; step++) {
          float t = map(step, 0, numSteps, 0, 1);
          float interpolatedR = lerp(colorR1, colorR2, t);
          float interpolatedG = lerp(colorG1, colorG2, t);
          float interpolatedB = lerp(colorB1, colorB2, t);

          stroke(interpolatedR, interpolatedG, interpolatedB);
          vertex(x1 + dx * t, y1 + dy * t);
        }

        endShape();
      }
    }
  }
}

void updateShapes() {
  for (float[] shape : shapes) {
    float x = shape[0];
    float y = shape[1];
    float velocityX = shape[6];
    float velocityY = shape[7];

    // Update position
    shape[0] += velocityX;
    shape[1] += velocityY;

    // Bounce off edges
    if (shape[0] <= 0 || shape[0] >= width) {
      shape[6] = -velocityX;  // Reverse velocityX
    }
    if (shape[1] <= 0 || shape[1] >= height) {
      shape[7] = -velocityY;  // Reverse velocityY
    }

    // Randomly change color and switch shape type
    if (random(100) < 1) {  // 1% chance to change color and shape type
      shape[3] = random(255);  // new colorR
      shape[4] = random(255);  // new colorG
      shape[5] = random(255);  // new colorB
      shape[8] = int(random(0, 3));  // new shapeType (0: circle, 1: square, 2: triangle)
    }
  }
}
