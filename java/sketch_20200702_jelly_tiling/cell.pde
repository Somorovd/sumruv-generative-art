class Cell {
  int x, y, w, h;

  Cell(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  PVector[] getPerimPoints() {
    PVector[] points = new PVector[this.w * 4];
    int[][] dirs = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
    int[] pos = {0, 0};

    for (int j = 0; j<4; j++) {
      int[] d = dirs[j];
      for (int i = 0; i < this.w; i++) {
        int idx = (this.y + pos[1]) * (g + 1) + (this.x + pos[0]);
        PVector vec = randVecs[idx];

        points[(j * this.w) + i] = new PVector((this.x + pos[0] + vec.x) * s, (this.y + pos[1] + vec.y) * s);
        pos[0] += d[0];
        pos[1] += d[1];
      }
    }
    
    return points;
  }
}
