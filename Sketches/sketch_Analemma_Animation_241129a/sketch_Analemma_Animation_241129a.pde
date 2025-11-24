// sketch_Analemma_Animation_241129a.pde

import java.util.Date;
import java.util.concurrent.atomic.AtomicBoolean;

PFont font;
ArrayList<PVector> analemmaPoints;
float rotationAngle = 0;
AtomicBoolean isRunning = new AtomicBoolean(true);

// Function to calculate the position of the Sun on a given date
float[] sunPosition(Date date) {
    // Constants
    final float siderealYear = 365.242190419f; // Tropical year in days
    final float earthTilt = radians(23.44f);   // Earth's axial tilt in radians
    
    // Calculate day number since J2000
    float daysSinceJ2000 = date.getTime() / (24.0f * 60.0f * 60.0f * 1000.0f);
    
    // Mean solar longitude
    float L = radians(280.460f + 0.9856474f * daysSinceJ2000);
    
    // Equation of time components (simplified)
    float eqFactor = tan(earthTilt/2.0f) * tan(earthTilt/2.0f);
    float eqTime = eqFactor * sin(2*L) - 2.0f * 0.0167f * sin(L);
    
    // Solar declination
    float delta = asin(sin(earthTilt) * sin(L));
    
    // Convert to screen coordinates
    float x = 120 * eqTime;                // Scale the equation of time
    float y = 120 * sin(delta);           // Scale the declination
    
    return new float[] {x, y};
}

void setup() {
    size(800, 600, P3D);
    hint(DISABLE_DEPTH_TEST);
    font = createFont("Arial", 12);
    textFont(font);
    background(0);
    frameRate(60);
    smooth();
    
    // Initialize the analemma points
    analemmaPoints = new ArrayList<PVector>();
    
    // Calculate points for a full year
    Date baseDate = new Date();
    for (int day = 0; day < 365; day++) {
        Date date = new Date(baseDate.getTime() + day * 24L * 60L * 60L * 1000L);
        float[] pos = sunPosition(date);
        analemmaPoints.add(new PVector(pos[0], pos[1]));
    }
    
    // Register a shutdown hook
    Runtime.getRuntime().addShutdownHook(new Thread(() -> {
        isRunning.set(false);
        try {
            Thread.sleep(100); // Give time for cleanup
        } catch (InterruptedException e) {
            // Ignore
        }
    }));
}

void draw() {
    if (!isRunning.get()) {
        exit();
        return;
    }
    
    background(0);
    
    pushMatrix();
    translate(width/2, height/2, 0);
    rotateY(rotationAngle);
    
    // Draw the analemma path
    stroke(255, 100);
    noFill();
    beginShape();
    for (PVector p : analemmaPoints) {
        vertex(p.x, p.y);
    }
    endShape();
    
    // Draw current sun position
    int currentDay = frameCount % 365;
    PVector currentPos = analemmaPoints.get(currentDay);
    fill(255, 255, 0);
    noStroke();
    pushMatrix();
    translate(currentPos.x, currentPos.y, 0);
    sphere(8);
    popMatrix();
    
    // Draw reference circle
    stroke(50, 100, 255, 100);
    noFill();
    ellipse(0, 0, 300, 300);
    
    popMatrix();
    
    // Update rotation
    rotationAngle += 0.005;
    
    // Draw text information
    fill(255);
    noStroke();
    text("Day of Year: " + (currentDay + 1), 10, height - 10);
}

void keyPressed() {
    if (key == ESC) {
        cleanupAndExit();
    }
}

void cleanupAndExit() {
    isRunning.set(false);
    dispose();
    exit();
}

void dispose() {
    if (font != null) {
        font = null;
    }
    if (analemmaPoints != null) {
        analemmaPoints.clear();
        analemmaPoints = null;
    }
    noLoop();
}
