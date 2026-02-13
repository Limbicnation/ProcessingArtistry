# ProcessingArtistry - AI Agent Guide

## Project Overview

ProcessingArtistry is a creative coding repository containing generative art sketches and visual experiments built using [Processing](https://processing.org/). The project explores various visual concepts including:

- Fractal geometry and recursive patterns
- Particle systems and flow fields
- Noise-based landscapes and animations
- 3D graphics and animations
- Mathematical visualizations
- Interactive visual experiences

The repository serves as both a personal collection of artistic experiments and a reference for creative coding techniques.

## Technology Stack

| Component | Technology | File Extension |
|-----------|------------|----------------|
| Primary Language | Processing (Java Mode) | `.pde` |
| Secondary Language | Processing.py (Python Mode) | `.pyde` |
| 3D Rendering | P3D (OpenGL-based) | - |
| 2D Rendering | Default/Java2D | - |
| Development Environment | Processing IDE | - |

### Processing Modes

- **Java Mode**: Standard Processing syntax using Java. Files use `.pde` extension.
- **Python Mode**: Python syntax for Processing. Files use `.pyde` extension.

## Directory Structure

```
ProcessingArtistry/
├── Sketches/                          # Main sketches directory
│   ├── <SketchName>/                  # Individual sketch folder
│   │   └── <SketchName>.pde           # Main sketch file
│   ├── modes/                         # Processing modes installation
│   │   └── PythonMode/                # Python mode for Processing
│   │       └── examples/              # Python mode examples (200+)
│   ├── libraries/                     # Processing libraries
│   ├── templates/                     # Sketch templates (empty)
│   ├── tools/                         # Processing tools (empty)
│   └── examples/                      # Additional examples (empty)
├── FloatingCube/                      # Sample output frames
│   └── frames/                        # Exported animation frames
├── .gitattributes                     # Git LFS configuration
├── .gitignore                         # Git ignore rules
├── LICENSE                            # Apache 2.0 License
├── README.md                          # Project readme
└── GEMINI.md                          # Existing documentation
```

## Sketch Organization

Each sketch resides in its own folder under `Sketches/` with the following conventions:

### Naming Conventions

- **Folders**: Descriptive names with optional date suffix (e.g., `Cosmic_Choreography`, `NoiseWaveAnim_20240801a`)
- **Java Mode Files**: Match folder name with `.pde` extension
- **Python Mode Files**: Match folder name with `.pyde` extension
- **Date Suffix Format**: `_YYMMDD[a-z]` for versioning (e.g., `_230719a`)

### Sketch Structure (Java Mode)

```java
// Optional: Import statements
import processing.opengl.*;

// Global variables
float angle;

void settings() {
  size(800, 600, P3D);  // Canvas size with optional renderer
}

void setup() {
  // Initialization code
  background(0);
  smooth();
}

void draw() {
  // Animation loop - called every frame
  // Update and render graphics
}

// Optional: Event handlers
void keyPressed() {
  // Handle keyboard input
}

void mousePressed() {
  // Handle mouse input
}
```

### Sketch Structure (Python Mode)

```python
def setup():
    size(800, 600)
    background('#004477')
    noFill()

def draw():
    # Animation loop
    pass

def keyPressed():
    # Handle keyboard input
    pass
```

## Configuration Files

### sketch.properties

Some sketches include a `sketch.properties` file to specify the main file:

```properties
main=sketch_floating_cube_230204a.pde
```

This is useful when the main file name differs from the folder name.

## Running Sketches

### Prerequisites

1. Install [Processing IDE](https://processing.org/download)
2. For Python Mode: Install Python Mode via Processing IDE (Tools > Add Tool > Modes)

### Execution Steps

1. **Open Processing IDE**
2. **Load Sketch**: `File > Open...` and select the sketch folder
3. **Run**: Click the Play button or press `Ctrl+R` (Windows/Linux) / `Cmd+R` (Mac)

### Exporting Frames

Many sketches are configured to export animation frames:

```java
// In draw() function
saveFrame("/home/gero/GitHub/Processing_Lab/Processing_Output/<SketchName>/frame_####.png");
```

Toggle recording with a key press:
```java
void keyPressed() {
  if (key == 'r' || key == 'R') {
    recording = !recording;
  }
}
```

## Common Patterns

### Canvas Setup

```java
// 2D canvas
size(800, 600);

// 3D canvas with OpenGL
size(800, 600, P3D);

// High-DPI support
pixelDensity(displayDensity());
```

### Animation Variables

```java
float time = 0;
float angle = 0;
int frameCount = 0;

void draw() {
  time += 0.001;
  angle += 0.03;
  frameCount++;
}
```

### Perlin Noise

```java
float noiseValue = noise(x * scale, y * scale, time);
float mappedValue = map(noiseValue, 0, 1, minVal, maxVal);
```

### Matrix Transformations (3D)

```java
pushMatrix();
translate(x, y, z);
rotateX(angle);
rotateY(angle * 1.3);
box(size);
popMatrix();
```

## Git Configuration

### .gitignore

The project excludes:
- Compiled Java files (`*.class`)
- Log files (`*.log`)
- Output images (`*.jpg`, frames/)
- Archive files (`.jar`, `.zip`)
- Processing sketch outputs (`output/`, `frames/`)
- Installed modes (`Sketches/modes/` - though currently tracked)

### .gitattributes

- Uses Git LFS for binary files (images: `.jpg`, `.png`, `.gif`, etc.)
- Treats `.pde` and `.md` files as text

## Development Guidelines

### Code Style

1. **Indentation**: 2 spaces (Processing IDE default)
2. **Comments**: Use Javadoc-style for class documentation
3. **Naming**: camelCase for variables/functions, PascalCase for classes
4. **Constants**: UPPER_SNAKE_CASE for constants

### Performance Considerations

1. Use `P2D` or `P3D` renderer for better performance with many shapes
2. Limit frame rate with `frameRate(30)` if needed
3. Use `noSmooth()` for better performance on large canvases
4. Consider `blendMode()` for visual effects but be aware of performance impact

### Output Paths

The project uses a consistent output directory structure:
```
/home/gero/GitHub/Processing_Lab/Processing_Output/<SketchName>/
```

When creating new sketches with frame export, maintain this convention.

## Testing

There is no automated test suite. Testing is done by:

1. Running the sketch in Processing IDE
2. Visual inspection of output
3. Checking exported frames for animation sequences

## Dependencies

### Standard Libraries

Processing core libraries (included with IDE):
- `processing.core.*`
- `processing.opengl.*` (for P3D)

### Optional Libraries

Some sketches may use contributed libraries (check individual sketches):
- OpenCV for Processing
- PeasyCam
- ControlP5
- beads (audio)

## License

Apache License 2.0 - See LICENSE file for details.

## Notes for AI Agents

1. **Creating New Sketches**: Create a new folder under `Sketches/` with a descriptive name
2. **File Extensions**: Use `.pde` for Java mode, `.pyde` for Python mode
3. **Frame Export**: When adding animation export, use the established output path pattern
4. **Git LFS**: Binary files (exported frames, images) should use Git LFS
5. **No Build System**: This project has no build system (no Maven, Gradle, etc.). It relies on the Processing IDE.
6. **No Package Management**: No npm, pip, or similar package managers are used for the main project.
