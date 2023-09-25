PVector[] chaikin(PVector[] points, int iter) {
	for (int it = 0; it < iter; it++) {
		int num_next = 2 * points.length;
		PVector[] next_points = new PVector[num_next];
		next_points[0] = points[0];
		next_points[next_points.length - 1] = points[points.length - 1];
		for (int i = 0; i < points.length - 1; i++) {
			PVector p1 = points[i];
			PVector p2 = points[i + 1];
			PVector d = PVector.sub(p2, p1);
			next_points[2 * i + 1] = PVector.add(p1, PVector.mult(d, 0.25));
			next_points[2 * i + 2] = PVector.add(p1, PVector.mult(d, 0.75));
		}
		points = next_points;
	}
	return points;
}


void connect(PVector[] points, boolean close) {
	beginShape();
	for (PVector p : points) {
	  vertex(p.x, p.y);
	}
	if (close) {
	  endShape(CLOSE);
	} else {
	  endShape();
	}
}


PVector[] spaceEvenly(PVector[] points, int num_points) {
	float total_length = 0;

	for (int i = 0; i < points.length - 1; i++) {
	  total_length += PVector.dist(points[i], points[i + 1]);
	}
	
	float spacing = total_length / (num_points - 1);
	
	PVector[] spaced_points = new PVector[num_points];
	spaced_points[0] = points[0];
	
	int idx = 0;
	PVector p1 = points[0];
	PVector p2 = points[1];
	PVector prev = p1;
	
	for (int i = 0; i < num_points - 1; i++) {
	  float d1 = 0;
	  float d2 = 0;
	  p1 = prev;
	  while(d2<spacing) {
	    d1 = d2;
	    d2 += PVector.dist(p1, p2);
	    if (d2 < spacing && idx + 1 < points.length - 1) {
	      idx++;
	      p1 = points[idx];
	      p2 = points[idx + 1];
	    }
	  }

	  float pct = (spacing - d1) / (d2 - d1);
	  prev = PVector.lerp(p1, p2, pct);
	  spaced_points[i + 1] = prev;
	}
	
	spaced_points[spaced_points.length - 1] = points[points.length - 1];
	return spaced_points;
}


PVector lerpVector (PVector vec1, PVector vec2, float pct) {
  return new PVector(
    lerp(vec1.x, vec2.x, pct),
    lerp(vec1.y, vec2.y, pct)
  );
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
