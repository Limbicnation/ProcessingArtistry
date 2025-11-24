// Sketch name: RotatingCubesTrace
String projectName = "RotatingCubesTrace";
String exportPath;
boolean isRecording = false;
int totalFrames = 360; // One full rotation
File exportFolder;

ArrayList<PVector> tracePoints;
float rotation = 0;
int maxTracePoints = 100;

void setup() {
  size(1600, 1200, P3D);
  background(30);
  tracePoints = new ArrayList<PVector>();
  
  // Create export directory with absolute path
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + nf(minute(), 2);
  String folderName = projectName + "_" + timestamp;
  
  // Use global output folder
  File mainExportFolder = new File("/home/gero/GitHub/Processing_Lab/Processing_Output/RotatingCubesTrace");
  if (!mainExportFolder.exists()) {
    mainExportFolder.mkdirs();
    println("Created main exports directory at: " + mainExportFolder.getAbsolutePath());
  }
  
  // Create the specific export folder
  exportFolder = new File(mainExportFolder, folderName);
  if (!exportFolder.exists()) {
    boolean success = exportFolder.mkdir();
    println("Creating export folder: " + exportFolder.getAbsolutePath());
    println("Folder creation successful: " + success);
  }
  
  exportPath = exportFolder.getAbsolutePath();
  println("Export path set to: " + exportPath);
  
  // Test write permissions
  try {
    File testFile = new File(exportFolder, "test.txt");
    if (testFile.createNewFile()) {
      println("Write permission test successful");
      testFile.delete();
    }
  } catch (Exception e) {
    println("Error testing write permissions: " + e.getMessage());
  }
}

void draw() {
  background(30);
  
  // Add fade effect for trace points
  noStroke();
  fill(30, 30);
  rect(0, 0, width, height);
  
  // Draw trace points
  beginShape(POINTS);
  stroke(0, 123, 255, 100);
  strokeWeight(8);
  for (PVector p : tracePoints) {
    point(p.x, p.y, p.z);
  }
  endShape();
  
  // Translate the origin to the center of the canvas
  translate(width / 2, height / 2);
  
  // Record trace points for outer cube corners
  if (frameCount % 5 == 0) {
    float s = 400/2;
    PVector[] corners = {
      new PVector(-s, -s, -s),
      new PVector(s, -s, -s),
      new PVector(-s, s, -s),
      new PVector(s, s, -s),
      new PVector(-s, -s, s),
      new PVector(s, -s, s),
      new PVector(-s, s, s),
      new PVector(s, s, s)
    };
    
    for (PVector corner : corners) {
      PVector rotated = rotatePoint(corner, rotation, rotation/2);
      rotated.add(new PVector(width/2, height/2, 0));
      tracePoints.add(rotated);
      
      if (tracePoints.size() > maxTracePoints) {
        tracePoints.remove(0);
      }
    }
  }
  
  // Rotate the outer cube
  rotateY(radians(rotation));
  rotateX(radians(rotation / 2));
  
  // Draw the outer cube
  pushMatrix();
  drawCube(400, color(0, 123, 255, 127), color(0, 108, 246));
  popMatrix();
  
  // Rotate the inner cube with opposite rotation
  rotateY(radians(-rotation * 1.5));
  rotateX(radians(-rotation));
  
  // Draw the inner cube
  pushMatrix();
  translate(120, 120);
  drawCube(200, color(147, 102, 255, 127), color(139, 90, 246));
  popMatrix();
  
  // Export frame if recording
  if (isRecording) {
    String framePath = exportPath + File.separator + "frame-" + nf(frameCount, 4) + ".png";
    save(framePath);
    println("Saved frame " + frameCount + " of " + totalFrames + " to: " + framePath);
    
    if (frameCount >= totalFrames) {
      println("Animation export complete!");
      println("Total frames: " + frameCount);
      println("Final export path: " + exportPath);
      exit();
    }
  }
  
  // Increment rotation
  rotation = (rotation + 1) % 360;
}

void drawCube(float size, color faceColor, color edgeColor) {
  // Draw faces
  noStroke();
  fill(faceColor);
  box(size);
  
  // Draw edges with glow effect
  for (int i = 1; i <= 3; i++) {
    stroke(red(edgeColor), green(edgeColor), blue(edgeColor), 255/i);
    strokeWeight(i * 4);
    noFill();
    box(size + i * 4);
  }
}

PVector rotatePoint(PVector p, float angleY, float angleX) {
  float radY = radians(angleY);
  float radX = radians(angleX);
  
  float x1 = p.x * cos(radY) - p.z * sin(radY);
  float z1 = p.x * sin(radY) + p.z * cos(radY);
  
  float y2 = p.y * cos(radX) - z1 * sin(radX);
  float z2 = p.y * sin(radX) + z1 * cos(radX);
  
  return new PVector(x1, y2, z2);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    isRecording = true;
    frameCount = 0;
    println("\nStarting recording...");
    println("Export folder: " + exportPath);
  }
}
