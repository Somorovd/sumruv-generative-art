class Bounds {
	float x, y, w, h;
	
	Bounds(float x, float y, float w, float h) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	
	Bounds getScaled(float pct) {
		float scaled_w = w * pct;
		float scaled_h = h * pct;
		return new Bounds(
			x + (w - scaled_w) / 2,
			y + (h - scaled_h) / 2,
			scaled_w,
			scaled_h
			);
	}
	
	void show() {
		rect(x, y, w, h);
	}
}


class Game {
	Bounds bounds;
	int dim;
	
	Box[] boxes;
	int[] valid_idx;
	int remaining;
	ArrayList<Line> lines = new ArrayList<Line>();
	
	color c1, c2;
	
	Game(Bounds bounds, int dim, float gap_pct) {
		this.bounds = bounds;
		this.dim = dim;
		
		boxes = new Box[(dim - 1) * (dim - 1)];
		valid_idx = new int[(dim - 1) * (dim - 1)];
		remaining = boxes.length;
		getBoxes();
	}
	
	void getBoxes() {
		float w = bounds.w / (dim - 1);
		float h = bounds.h / (dim - 1);
		for (int j = 0; j < dim - 1; j++) {
			float y = bounds.y + bounds.h / (dim - 1) * j;
			for (int i = 0; i < dim - 1; i++) {
				float x = bounds.x + bounds.w / (dim - 1) * i;
				int idx = j * (dim - 1) + i;
				boxes[idx] = new Box(new Bounds(x, y, w, h));
				valid_idx[idx] = idx;
			}
		}
	}
	
	void playGame(float pct) {
		int num_edges = 2 * dim * (dim - 1);
		int steps = int(pct * num_edges);
		
		for (int i = 0; i < steps; i++) {
			int idx_idx = (int)random(remaining);
			int idx = valid_idx[idx_idx];
			Box box = boxes[idx];
			
			if (box.getSum() == 0) {
				// if box is completed, move it out of choosing range
				int temp = valid_idx[remaining - 1];
				valid_idx[remaining - 1] = valid_idx[idx_idx];
				valid_idx[idx_idx] = temp;
				remaining--;
				i--;
				continue;
			} else {
				// choose a side to draw a line on
				int side = box.getNotChosen();
				lines.add(box.sides[side]);
				
				// indicate choice on both boxes that share the edge
				box.not_chosen[side] = 0;
				
				int x = idx % (dim - 1);
				int y = idx / (dim - 1);
				
				int n_idx = -1;
				if (side == 0 && y > 0) {
					n_idx = idx - (dim - 1);
				} else if (side == 2 && y < (dim - 2)) {
					n_idx = idx + (dim - 1);
				} else if (side == 1 && x < (dim - 2)) {
					n_idx = idx + 1;
				} else if (side == 3 && x > 0) {
					n_idx = idx - 1;
				}
				
				if (n_idx >= 0) {
					Box neighbor = boxes[n_idx];
					neighbor.not_chosen[(side + 2) % 4] = 0;
				}
			}
		}
	}
	
	void showBoxes() {
		noStroke();
		for (Box box : boxes) {
			if (box.getSum() == 0) {
				color c = palette[(int)random(palette.length)];
				float scale_factor = 1 - random(0.15, 0.5);
				
				fill(DARK);
				box.bounds.show();
				
				fill(c);
				box.bounds.getScaled(scale_factor).show();
			}
		}
	}
	
	void showLines() {
		int weight = int(bounds.w / (dim - 1) * (1 - game_gap_pct));
		stroke(DARK);
		strokeWeight(weight);
		for (Line ln : lines) {
			ln.show();
		}
	}
}

class Line {
	PVector p1, p2;
	Line(PVector p1, PVector p2) {
		this.p1 = p1;
		this.p2 = p2;
	}
	
	void show() {
		line(p1.x, p1.y, p2.x, p2.y);
	}
}

class Box {
	Bounds bounds;
	Line[] sides = new Line[4];
	int[] not_chosen = {1, 1, 1, 1};
	
	Box(Bounds bounds) {
		this.bounds = bounds;
		
		PVector tl = new PVector(bounds.x, bounds.y);
		PVector tr = new PVector(bounds.x + bounds.w, bounds.y);
		PVector br = new PVector(bounds.x + bounds.w, bounds.y + bounds.h);
		PVector bl = new PVector(bounds.x, bounds.y + bounds.h);
		
		sides[0] = new Line(tl, tr);
		sides[1] = new Line(tr, br);
		sides[2] = new Line(br, bl);
		sides[3] = new Line(bl, tl);
	}
	
	int getNotChosen() {
		ArrayList<Integer> arr = new ArrayList<Integer>();
		for (int i = 0; i < 4; i++) {
			if (not_chosen[i] == 1) {
				arr.add(i);
			}
		}
		return arr.get((int)random(arr.size()));
	}
	
	int getSum() {
		int sum = 0;
		for (int i = 0; i < 4; i++) {
			sum += not_chosen[i];
		}
		return sum;
	}
}
