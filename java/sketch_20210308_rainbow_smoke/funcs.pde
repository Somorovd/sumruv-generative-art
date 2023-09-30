Point calculateNeighborAverage(Cell cell) {
	Point avg = new Point(0, 0, 0);
	int n = 0;
	for (int i : cell.getNeighborIndicies(color_dist, g)) {
		Cell n_cell = cells[i];
		if (n_cell.filled) {
			n++;
			avg.x += n_cell.p.x;
			avg.y += n_cell.p.y;
			avg.z += n_cell.p.z;
		}
	}
	avg.x /= n;
	avg.y /= n;
	avg.z /= n;
	return avg;
}


Cell[] createCellGrid(int g, float w, float h) {
	Cell[] cells = new Cell[g * g];
	for (int j = 0; j < g; j++) {
		float y = h * j;
		for (int i = 0; i < g; i++) {
			float x = w * i;
			cells[j * g + i] = new Cell(j * g + i, x, y, w, h);
		}
	}
	return cells;
}

Point getNearest(OctTree sub_ot, Point p) {
	//  /*
	//   Since each OT splits if there is more than 1 point,
	//   it means that there are at least two points in the parent.
	//   Furthest they can be is in opposite corners
	//   so we check that distance in all directions;
	//   */
	
	float dx = (sub_ot.x2 - sub_ot.x1) * sqrt(3);
	float dy = (sub_ot.y2 - sub_ot.y1) * sqrt(3);
	float dz = (sub_ot.z2 - sub_ot.z1) * sqrt(3);
	
	ArrayList<Point> found = new ArrayList<Point>();
	main_ot.query(p.x - dx, p.x + dx, p.y - dy, p.y + dy, p.z - dz, p.z + dz, found);
	
	float min_dist = sq(dx) + sq(dy) + sq(dz);
	Point nearest = null;
	
	for (Point _p : found) {
		float d = dist(p.x, p.y, p.z, _p.x, _p.y, _p.z);
		if (d < min_dist) {
			min_dist = d;
			nearest = _p;
		}
	}
	return nearest;
}

void fillCell(Cell cell, Point point) {
	cell.p = point;
	point.removeSelf();
	
	// Add cells within the adding distance
	for (int i : cell.getNeighborIndicies(add_dist, g)) {
		if (cells[i].filled) continue;
		
		if (!cells[i].in_array) {
			fillable_cells.add(cells[i]);
			cells[i].in_array = true;
			weight_total += cells[i].weight;
		}
	}
	
	// Update the neighbor weight for cells within the weight distnce
	for (int i : cell.getNeighborIndicies(weight_distance, g)) {
		if (cells[i].filled) continue;
		
		cells[i].filled_neighbors++;
		weight_total -= cells[i].weight;
		cells[i].weight = 1 + cells[i].filled_neighbors * surrounded_weight;
		weight_total += cells[i].weight;
	}
}

OctTree imagePixelsToOctTree(PImage img, int g) {
	OctTree ot = new OctTree( -1, 256, -1, 256, -1, 256, null);
	for (int j = 0; j < g; j++) {
		int y = int(img.height * float(j) / g);
		for (int i = 0; i < g; i++) {
			int x = int(img.width * float(i) / g);
			color c = img.pixels[y * img.width + x];
			ot.insert(new Point(red(c), green(c), blue(c)));
		}
	}
	return ot;
}
