float angle = 0;

void setup() {
  size(600, 600, P3D);
  background(0);
  stroke(255);
  noFill();
}

void draw() {
  background(0);
  lights();
  
  angle *= 0.01;
  
  draw_cube(200, angle, 0,0,0);
 
  
  translate(width/2, height/2, 0);
  rotateX(frameCount * 0.01);
  rotateY(frameCount * 0.02);
  box(200);

  translate(-100, -100, -100);
  drawFractal(100, 4);
}

void drawFractal(float size, int depth) {
  if (depth == 0) {
    return;
  }
  box(size);
  translate(size/2, size/2, size/2);
  drawFractal(size/2, depth-1);
  translate(-size/2, -size/2, -size/2);
  box(size);
  translate(size/2, -size/2, size/2);
  drawFractal(size/2, depth-1);
  translate(-size/2, size/2, -size/2);
  box(size);
  translate(size/2, -size/2, -size/2);
  drawFractal(size/2, depth-1);
  translate(-size/2, size/2, size/2);
  box(size);
  translate(-size/2, -size/2, size/2);
  drawFractal(size/2, depth-1);
  translate(size/2, size/2, -size/2);
  box(size);
  translate(-size/2, -size/2, -size/2);
  drawFractal(size/2, depth-1);
  translate(size/2, -size/2, -size/2);
  box(size);
  translate(-size/2, size/2, size/2);
  drawFractal(size/2, depth-1);
}

void draw_cube(float size, float angle, float x, float y, float z) {
  pushMatrix();
  translate(x, y, z);
  rotateX(angle);
  rotateY(angle);
  rotateZ(angle);

  box(size);

  if (size > 20) {
    float new_size = size / 2;
    draw_cube(new_size, angle * 2, -new_size, -new_size, -new_size);
    draw_cube(new_size, angle * 2, -new_size, -new_size, new_size);
    draw_cube(new_size, angle * 2, -new_size, new_size, -new_size);
    draw_cube(new_size, angle * 2, -new_size, new_size, new_size);
    draw_cube(new_size, angle * 2, new_size, -new_size, -new_size);
    draw_cube(new_size, angle * 2, new_size, -new_size, new_size);
    draw_cube(new_size, angle * 2, new_size, new_size, -new_size);
    draw_cube(new_size, angle * 2, new_size, new_size, new_size);
  }

  popMatrix();
}
