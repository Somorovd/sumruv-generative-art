PVector[] arcSeg(float x, float y, int n, float a1, float a2, float r1, float r2) {
	
	PVector c = new PVector(x, y);
	float da = (a2 - a1) / n;
	PVector[] points = new PVector[2 * (n + 1)];
	PVector dir = new PVector(1, 0).rotate(a1);
	for (int i = 0; i <=  n; i++) {
		points[i] = PVector.mult(dir, r1).add(c);
		points[points.length - i - 1] = PVector.mult(dir, r2).add(c);
		dir.rotate(da);
	}
	
	return points;
}

void connect(PVector[] points) {
	beginShape();
	for (PVector p : points) {
		vertex(p.x, p.y);
	}
	endShape(CLOSE);
}


float[] partition(float x1, float x2, int num_bins, int num_additions, float min_size, float max_size) {
	/*
	Split the range x1 - x2 into num_bins number of bins, each initialized with a size min.
	Whatever range remains if added incrementally to a random bin.
	*/
	float[] bins = new float[num_bins];
	float[] ends = new float[num_bins + 1];
	ArrayList<Integer> valid = new ArrayList<Integer>();
	float add_size = ((x2 - x1) - min_size * num_bins) / num_additions;
	
	for (int i = 0; i < num_bins; i++) {
		bins[i] = min_size;
		valid.add(i);
	}
	
	for (int i = 0; i < num_additions; i++) {
		int v_idx = int(random(valid.size()));
		int j = valid.get(v_idx);
		bins[j] += add_size;
		if (bins[j] > max_size - add_size) {
			valid.remove(v_idx);
		}
	}
	
	ends[0] = x1;
	ends[num_bins] = x2;
	for (int i = 1; i < num_bins; i++) {
		ends[i] = ends[i - 1] + bins[i];
	}
	
	return ends;
}
