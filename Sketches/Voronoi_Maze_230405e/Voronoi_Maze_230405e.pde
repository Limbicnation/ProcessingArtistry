float[] x, y;
int num_cells = 100;
float max_dist;
PVector[] centroids;
int[] colors;

void setup() {
  size(600, 600);
  x = new float[num_cells];
  y = new float[num_cells];
  centroids = new PVector[num_cells];
  colors = new int[num_cells];
  max_dist = dist(0, 0, width, height);
  
  for (int i = 0; i < num_cells; i++) {
    x[i] = noise(i * 0.1) * width;
    y[i] = noise(i * 0.1 + 100) * height;
    centroids[i] = new PVector(x[i], y[i]);
    colors[i] = color(random(255), random(255), random(255), 100);
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      PVector pixel = new PVector(i, j);
      float min_dist = max_dist;
      int cell_index = 0;
      for (int k = 0; k < num_cells; k++) {
        float d = dist(pixel.x, pixel.y, centroids[k].x, centroids[k].y);
        if (d < min_dist) {
          min_dist = d;
          cell_index = k;
        }
      }
      stroke(colors[cell_index]);
      point(i, j);
    }
  }
}
