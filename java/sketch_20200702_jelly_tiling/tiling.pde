int[] generateShuffledIndicies(int count) {
  int[] values = new int[count];
  int[] indicies = new int[count];
  int[] shuffled = new int[count];

  for (int i = 0; i < count; i++) {
    indicies[i] = i;
    values[i] = i;
  }

  int end = indicies.length;
  for (int i = 0; i < count; i++) {
    int idx_idx = (int) random(0, end);
    int idx = indicies[idx_idx];
    shuffled[i] = values[idx];

    indicies[idx_idx] = indicies[end - 1];
    end -= 1;
  }

  return shuffled;
}

ArrayList<Cell> tiling() {
  ArrayList<Cell> cells = new ArrayList<Cell>();
  int[] shuffledIndicies = generateShuffledIndicies(g * g);
  int[] maxSizes = new int[g * g];

  for (int i = 0; i < g * g; i++) {
    int x = i % g;
    int y = floor(i / g);

    maxSizes[i] = min(
      sizes[0],
      g - x,
      g - y
      );
  }

  for (int size : sizes) {
    for (int idx : shuffledIndicies) {
      if (maxSizes[idx] < size) continue;

      int x = idx % g;
      int y = floor(idx / g);

      cells.add(new Cell(x, y, size, size));

      for (int _x = max(0, x - size); _x < min(g, x + size); _x++) {
        for (int _y = max(0, y - size); _y < min(g, y + size); _y++) {
          int _idx = _y * g + _x;
          maxSizes[_idx] = min(
            maxSizes[_idx],
            constrain(max(x - _x, y - _y), 0, sizes[0])
            );
        }
      }
    }
  }

  return cells;
}
