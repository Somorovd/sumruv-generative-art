void setup() {
	size(600, 600);
	strokeJoin(MITER);
}

void draw() {
	noLoop();
	background(255);
	
	int num_arcs = 31;
	int num_additions = 20;
	float min_angle = radians(5);
	float max_angle = radians(35);
	float[] parts = partition(0, 2 * PI, num_arcs, num_additions, min_angle, max_angle);
	
	float a_off = random(0, PI);
	float a_gap = radians(0.25);
	float r = 0.25 * height;
	float arclength = r * radians(5);
	float dr_min = 2 * arclength;
	float dr_max = 100 * (800 / 600);
	
	
	Arc[] arcs = new Arc[num_arcs];
	Arc[] offset_arcs = new Arc[2 * num_arcs];
	
	
	for (int i = 0; i < parts.length - 1; i++) {
		float a1 = a_off + parts[i] + a_gap;
		float a2 = a_off + parts[i + 1] - a_gap;
		
		float r_off = random(dr_min, dr_max);
		float r2 = r + r_off;
		float r1 = (random(1)<0.5) ? 0 : random(r * 0.6, r - 1.5 * arclength);
		
		arcs[i] = new Arc(a1, a2, r1, r2);
		
		offset_arcs[2 * i] = new Arc(a2 + a_gap, a2 + a_gap + radians(5), r - arclength, r);
		offset_arcs[2 * i + 1] = new Arc(a1 - a_gap - radians(5), a1 - a_gap, r, r + arclength);
	}
	
	stroke(255);
	strokeWeight(4);
	
	for (Arc arc : arcs) {
		arc.makePoints();
		arc.show();
	}
	
	stroke(255);
	strokeWeight(2);
	
	for (Arc arc : offset_arcs) {
		arc.makePoints();
		arc.show();
	}
}

void keyPressed() {
	if (key == ' ') {
		loop();
	}
}
