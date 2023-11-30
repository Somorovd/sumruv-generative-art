PVector[] chaikinLoop(PVector[] points, int n) {
  PVector[] prev;
  PVector[] ch = points;

  for (int it = 0; it < n; it++) {
    prev = ch;
    ch = new PVector[2 * prev.length];
    for (int i = 0; i < prev.length; i++) {
      PVector p1 = prev[i];
      PVector p2 = prev[(i + 1) % prev.length];
      PVector d = PVector.sub(p2, p1);

      ch[2 * i] = d.copy().mult(0.25).add(p1);
      ch[2 * i + 1] = d.copy().mult(0.75).add(p1);
    }
  }

  return ch;
}
