float angle = 0; // Rotation angle for animation
float time = 0; // Time variable for smooth changes

void setup() {
    size(800, 600); // Set canvas size
    background(0);   // Black background for contrast
    frameRate(60);   // Smooth animation
}

void draw() {
    background(0, 20); // Slight fade for trails

    translate(width / 2, height / 2); // Center the animation

    // Loop to create multiple "elves"
    for (int i = 0; i < 12; i++) {
        float offset = TWO_PI / 12 * i; // Space them in a circle
        
        float x = cos(offset + angle) * 150;
        float y = sin(offset + angle) * 150;

        pushMatrix();
        translate(x, y);
        rotate(angle + offset);

        // Dynamic color based on time and position
        float r = map(sin(time + offset), -1, 1, 100, 255);
        float g = map(cos(time + offset), -1, 1, 100, 255);
        float b = map(sin(time + offset * 2), -1, 1, 100, 255);

        // Draw a morphing shape (elf body)
        float size = 30 + sin(time + offset) * 10; // Pulsing size
        ellipse(0, 0, size, size * 1.5); // Tall, oval shape

        // Add fractal-like "arms" or details using stroke instead of fill
        stroke(255 - r, 255 - g, 255 - b);
        noFill();

        for (int j = 0; j < 3; j++) {
            float armAngle = angle + j * PI / 3;
            float armX = cos(armAngle) * size;
            float armY = sin(armAngle) * size;

            // Draw lines instead of filled ellipses
            line(-armX, -armY, armX, armY);
        }

        popMatrix();
    }

    // Update animation variables
    angle += 0.05;   // Rotate slowly
    time += 0.1;     // Advance time for color/size shifts
}
