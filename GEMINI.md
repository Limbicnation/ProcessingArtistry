# ProcessingArtistry

## Project Overview
ProcessingArtistry is a collection of creative coding experiments and generative art sketches built using **Processing**. The repository explores various visual concepts including fractal geometry, particle systems, noise-based landscapes, and 3D animations.

## Technology Stack
*   **Processing (Java Mode):** The core language for most sketches (`.pde` files).
*   **Processing.py (Python Mode):** Python-based sketches (`.pyde` files).
*   **Rendering:** Uses standard 2D renderers and `P3D` (OpenGL) for 3D graphics.

## Directory Structure
The repository is organized into individual sketch folders, primarily located within the `Sketches/` directory.

*   **`Sketches/`**: The main directory containing source code for different projects.
    *   Each sketch usually resides in its own folder (e.g., `Sketches/Cosmic_Choreography/`).
    *   The main file inside usually matches the folder name (e.g., `Cosmic_Choreography.pde`).
*   **`FloatingCube/`**: Contains example output frames from the floating cube animation.

## Key Files & patterns
*   **`.pde` Files:** Java-mode source files.
    *   Typical structure: `void settings()`, `void setup()`, `void draw()`.
*   **`.pyde` Files:** Python-mode source files.
    *   Typical structure: `def setup():`, `def draw():`.
*   **`sketch.properties`:** Configuration file for sketches, often defining the mode (e.g., `mode=python`).

## Usage
### Running a Sketch
These sketches are designed to be run using the **Processing IDE**.

1.  **Open Processing:** Launch the Processing application.
2.  **Load Sketch:** `File > Open...` and select the `.pde` or `.pyde` file within its folder.
3.  **Run:** Click the "Run" button (Play icon) or press `Ctrl+R`.

### Exporting Frames
Some sketches (e.g., `FloatingCube`) are configured to export animation frames automatically.
*   Look for `saveFrame("frames/...")` calls in the `draw()` loop.
*   Frames are typically saved to a `frames/` subdirectory within the sketch folder.

## Development Conventions
*   **Canvas Size:** Often defined in `settings()` using `size()`.
*   **Animation:** Logic usually relies on `draw()` looping and incrementing variables (e.g., `angle`, `frameCount`).
*   **3D Sketches:** Use `P3D` renderer and standard transformations (`translate`, `rotate`).
