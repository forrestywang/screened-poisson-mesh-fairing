# Screened Poisson Mesh Fairing

An end-to-end MATLAB simulation pipeline for 3D surface mesh fairing. This project parses `.ply` geometry files, computes discrete differential operators (Laplace-Beltrami and mass matrices), and solves the Screened Poisson equation to perform parameter-controlled surface smoothing.

For the complete mathematical background, refer to the following [report](docs/theory.pdf).

## Repository Structure

```
screened-poisson-mesh-fairing/
├── src/
│   ├── laplacian.m             % Computes Laplace-Beltrami and mass matrices
│   ├── load_mesh.m             % Parser for 3D .ply polygon models
│   └── poisson_smooth.m        % Screened Poisson mesh smoothing solver
├── docs/
│   ├── theory.pdf              % Compiled LaTeX technical report detailing discrete differential operators and Screened Poisson formulation
│   └── theory.tex              % LaTeX source code
├── simulations/                % Rendered MP4 smoothing animations
│   ├── armadillo_smooth.mp4
│   ├── buddha_smooth.mp4
│   ├── bunny_smooth.mp4
│   └── dragon_smooth.mp4
├── LICENSE                     % MIT License
└── README.md
```

## Benchmarks & Performance

Evaluated across four Stanford 3D models using logarithmically spaced smoothing parameters to generate 60 FPS, 5-second smoothing animations:

* **High-Resolution Models ^:** Smooths the Happy Buddha model (543,652 vertices, 1,087,716 triangles) in 30 minutes total execution time.
* **Feature Preservation:** Eliminates high-frequency surface noise while retaining macro-scale shape structures without structural collapse.

## Getting Started

### Prerequisites

* MATLAB R2021a or newer.

### Running the Code

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/screened-poisson-mesh-fairing.git
   cd screened-poisson-mesh-fairing
   ```

2. Download `.ply` models from the [Stanford 3D Scanning Repository](https://graphics.stanford.edu/data/3Dscanrep/) and place them into your local path.

3. Open MATLAB and run `poisson_smooth.m` with your chosen model:

   ```matlab
   poisson_smooth(filename, output, fps, secs);
   ```

## Models

The test models (Bunny, Armadillo, Dragon, and Happy Buddha) are available directly from the official [Stanford 3D Scanning Repository](https://github.com/jvm-graphics-labs/awesome-3d-meshes/tree/master/Stanford%203D%20Scanning%20Repository).

## License

Distributed under the [MIT License](LICENSE).
