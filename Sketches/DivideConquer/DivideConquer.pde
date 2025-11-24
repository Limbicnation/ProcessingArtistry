// Depth sorting example originally by Jakub Valtar 
// https://github.com/JakubValtar

// Modified and hacked by Gero Doll aka (limbicnation)
// https://github.com/limbicnation

void setup() {
  size(640, 720, P3D);
  colorMode(HSB, 360, 100, 100, 100); // Set color mode to HSB
  frameRate(60);
}

void draw() {
  if (!mousePressed) {
    hint(ENABLE_DEPTH_SORT);
  } else {
    hint(DISABLE_DEPTH_SORT);
  }
  
  background(0);
  noStroke();
  
  translate(width/2, height/2, -300);
  scale(2);
  
  int rot = frameCount;
  int scaleVal = frameCount;
  float trans = radians(frameCount * 25);
  
  rotateZ(radians(90));
  rotateX(radians(rot/60.0 * 10));
  rotateY(radians(rot/60.0 / 30));
  
  scale(radians(scaleVal/60.0 * 30));
  
  translate(0, 0, trans);
 
  blendMode(ADD); // Set blend mode to "Divide"
    
  for (int i = 0; i < 100; i++) {
    fill(map(i % 10, 0, 10, 0, 100), 100, 100, 30);
 
    beginShape(TRIANGLES);
    vertex(200, 50, -50);
    vertex(100, 100, 50);
    vertex(100, 0, 20);
    endShape();
 
    rotateY(radians(270.0/100));
  }
  
  if (frameCount % 30 == 0) {
    println(frameRate);
  }
}
