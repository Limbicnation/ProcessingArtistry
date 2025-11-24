String outputPath = "/home/gero/GitHub/Processing_Lab/Processing_Output/RainShower/frame-#####.png";  // Replace with your output path
float desiredFrameRate = 60;  // Desired frame rate
float t = 0;
float s, j, i, u, v, e;

void setup() {
    size(1024, 1024);
    colorMode(HSB, 360, 100, 100);
    frameRate(desiredFrameRate);  // Set the frame rate
}

void draw() {
    background(0);
    s = PI / 30;
    
    for (j = (t += s / 10) / 4 % s; j < 7; j += s) {
        for (i = 0; i < TWO_PI; i += s * 2) {
            float hueValue = (j * 50) % 360;
            stroke(hueValue, 100, 100);
            beginShape(QUADS);
            
            float scaleFactor = 128;
            u = i + s * random(0.5, 1.5); v = j + s * random(0.5, 1.5); e = pow(v, 3) * scaleFactor + random(100);
            vertex(e * cos(u + j) + e / v * sin(v * 3 - t) + 360, 360 + e / v * cos(v * 3 - t) - e * sin(u + j));
            u = i + s * random(0.5, 1.5); v = j + s * random(0.5, 1.5);
            vertex(e * cos(u + j) + e / v * sin(v * 3 - t) + 360, 360 + e / v * cos(v * 3 - t) - e * sin(u + j));
            u = i + s * random(0.5, 1.5); v = j + s * random(0.5, 1.5);
            vertex(e * cos(u + j) + e / v * sin(v * 3 - t) + 360, 360 + e / v * cos(v * 3 - t) - e * sin(u + j));
            u = i + s * random(0.5, 1.5); v = j + s * random(0.5, 1.5);
            vertex(e * cos(u + j) + e / v * sin(v * 3 - t) + 360, 360 + e / v * cos(v * 3 - t) - e * sin(u + j));
            
            endShape();
        }
    }

    // Save each frame until frame 600
    if (frameCount <= 600) {
        saveFrame(outputPath);
    }
}
