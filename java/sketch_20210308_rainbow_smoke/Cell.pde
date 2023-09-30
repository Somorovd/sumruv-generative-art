class Cell {
	
	int i;
	float x, y, w, h;
	
	Point p;
	boolean filled = false;
	boolean in_array = false;
	int filled_neighbors = 0;
	float weight = 1;
	
	Cell(int i, float x, float y, float w, float h) {
	  this.i = i;
	  this.x = x;
	  this.y = y;
	  this.w = w;
	  this.h = h;
	}
	
	ArrayList<Integer> getNeighborIndicies(int n, int g) {
	  ArrayList<Integer> arr = new ArrayList<Integer>();
	  int row = i / g;
	  int col = i % g;
		
	  for (int dx = -n; dx <= n; dx++) {
	    for (int dy = -n; dy <= n; dy++) {
	      if (dx == 0 && dy == 0) {
	  	     continue;
	  	   } else if (row + dy < 0 || row + dy >= g || col + dx < 0 || col + dx >= g) {
	  	     continue;
	  	   } else {
	  	     arr.add((row + dy) * g + (col + dx));
	  	   }
	    }
	  }
	  return arr;
	}
	
	void show() {
	  color c = (p != null) ? color(p.x, p.y, p.z) : color(255, 0, 255);
	  fill(c);
		stroke(c);
	  rect(x, y, w, h);
	}
}
