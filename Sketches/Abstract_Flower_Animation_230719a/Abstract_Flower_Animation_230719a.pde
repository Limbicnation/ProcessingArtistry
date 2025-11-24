float angle = 0;
float growthSpeed = 2;
float flowerInterval = 20; // Distance between each flower instance
ArrayList<Flower> flowers; // ArrayList to store flower instances

void setup() {
  size(800, 800);
  background(0);
  noStroke();
  smooth();
  frameRate(30); // Set the animation speed to 30 fps

  flowers = new ArrayList<Flower>();
}

void draw() {
  background(0);

  // Check if it's time to create a new flower instance
  if (frameCount % flowerInterval == 0) {
    flowers.add(new Flower(width / 2, height / 2));
  }

  // Draw and update existing flower instances
  for (int i = flowers.size() - 1; i >= 0; i--) {
    Flower flower = flowers.get(i);
    flower.update();
    flower.display();

    // Remove flower instances that have left the screen
    if (flower.isOffscreen()) {
      flowers.remove(i);
    }
  }
  
  // Save the frame as a PNG image
  if (frameCount % 2 == 0) {
    saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/Abstract_Flower_Animation/Abstract_Flower_Animation_" + nf(frameCount, 4) + ".png");
  }
}

class Flower {
  float x, y;
  float radius;
  float angleOffset;
  color petalColor;

  Flower(float x, float y) {
    this.x = x;
    this.y = y;
    this.radius = 10;
    this.angleOffset = random(TWO_PI); // Randomize the starting angle
    this.petalColor = color(random(255), random(255), random(255)); // Randomize the petal color
  }

  void update() {
    radius += growthSpeed;
  }

  void display() {
    for (int i = 0; i < 10; i++) {
      float angleStep = TWO_PI / 10;
      float petalAngle = i * angleStep + angle + angleOffset;

      float petalX = x + cos(petalAngle) * radius;
      float petalY = y + sin(petalAngle) * radius;

      pushMatrix();
      translate(petalX, petalY);
      rotate(petalAngle);

      fill(petalColor);
      drawPetal();

      popMatrix();
    }
  }

  boolean isOffscreen() {
    return (x - radius > width || x + radius < 0 || y - radius > height || y + radius < 0);
  }
}

void drawPetal() {
  float petalWidth = 50;
  float petalHeight = 150;
  float petalCurve = 30;

  beginShape();
  vertex(-petalWidth / 2, 0);
  bezierVertex(-petalWidth / 2, -petalHeight / 2, petalCurve, -petalHeight / 2, 0, -petalHeight);
  bezierVertex(-petalCurve, -petalHeight / 2, petalWidth / 2, -petalHeight / 2, petalWidth / 2, 0);
  endShape(CLOSE);
}
