class Arc {
	
	float a1, a2, r1, r2;
	color c;
	
	PVector[] points;
	
	Arc(float a1, float a2, float r1, float r2) {
		this.a1 = a1;
		this.a2 = a2;
		this.r1 = r1;
		this.r2 = r2;
		this.c = color(random(255), random(255), random(255));
	}
	
	void makePoints() {
		float da = radians(10);
		int num_points = int((a2 - a1) / da) + 1;
		points = arcSeg(width / 2, height / 2, num_points, a1, a2, r1, r2);
	}
	
	void show() {
		fill(c);
		connect(points);
	}
}
