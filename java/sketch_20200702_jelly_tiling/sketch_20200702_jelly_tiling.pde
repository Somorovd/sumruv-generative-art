int[] sizes = {4, 3, 2, 1}; // make sure that 1 is in the array
int g = 25;
float s;


float[] vec_mag_range = {0.4, 0.8};
PVector[] randVecs = new PVector[(g + 1) * (g + 1)];

void setup() {
  size(800, 800);
  s = width / g;
}

void draw() {
  noLoop();
  stroke(0);
  strokeWeight(4);

  // Generate square tiling of grid.
  ArrayList<Cell> cells = tiling();

  // Initialize Random Vectors
  for (int i = 0; i < randVecs.length; i++) {
    randVecs[i] = PVector.random2D().setMag(random(vec_mag_range[0], vec_mag_range[1]));
  }

  // Display Cells
  for (Cell cell : cells) {
    // Get jagged perimeter
    PVector[] points = cell.getPerimPoints();
    // Smooth the corners
    PVector[] ch = chaikinLoop(points, 3);
    
    fill((int) random(255), (int) random(255), (int) random(255));
    beginShape();
    for (PVector p : ch) {
      vertex(p.x, p.y);
    }
    endShape(CLOSE);
  }
}
