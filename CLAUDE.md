# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ProcessingArtistry is a collection of generative art sketches built with [Processing](https://processing.org/) (Java Mode, `.pde` files). There is no build system, package manager, or test suite — sketches run exclusively in the Processing IDE.

## Running Sketches

- Open a `.pde` file in the Processing IDE and press `Ctrl+R`
- There is no CLI build/run command — the Processing IDE is required
- No automated tests; validation is visual inspection only

## Repository Structure

- `Sketches/` — all sketch source code, one folder per sketch
- Each sketch folder contains a `.pde` file matching the folder name
- `FloatingCube/` — sample exported animation frames
- Frame export output path convention: `/home/gero/GitHub/Processing_Lab/Processing_Output/<SketchName>/`

## Sketch Conventions

**Naming:** Folder names use `DescriptiveName` or `DescriptiveName_YYMMDD[a-z]` for versioned sketches (e.g., `NoiseWaveAnim_20240801a`). The `.pde` file inside must match the folder name.

**Standard structure:**
```java
void setup() {
  size(width, height);       // or size(w, h, P3D) for 3D
}

void draw() {
  // animation loop
}

void keyPressed() {
  // interactivity
}
```

**Common patterns across sketches:**
- `P3D` renderer for 3D sketches with `pushMatrix()`/`popMatrix()` transforms
- Perlin noise via `noise()` for organic motion
- `colorMode(HSB, 360, 100, 100)` for color cycling
- Frame recording toggled by key press (`'r'` or `'s'`), saving to `Processing_Output/`
- Delta-time animation using `millis()` for frame-rate-independent motion

## Code Style

- 2-space indentation (Processing IDE default)
- camelCase for variables/functions
- `UPPER_SNAKE_CASE` for constants

## Git Notes

- Git LFS is configured for binary files (images)
- `.gitignore` excludes `*.class`, `*.jpg`, `frames/`, `output/`, `Sketches/modes/`
- License: Apache 2.0
