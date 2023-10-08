PVector[] points;

void setup() {
	size(600, 600);
	PVector center = new PVector(width / 2, height / 2 + height / 8);
	PVector dir = new PVector(0, -280);
	PVector p1 = PVector.add(center, dir);
	PVector p2 = PVector.add(center, dir.rotate(radians(120)));
	PVector p3 = PVector.add(center, dir.rotate(radians(120)));
	points = new PVector[]{p1, p2, p3};
}

void draw() {
	noLoop();
	background(255);
	stroke(0);
	strokeWeight(2);
	
	boolean[] order1 = {true, false};
	boolean[] order2 = {false, true, true, false, false};
	boolean[][] orders = {order1, order2};
	int n = 40;
	
	for (int j = 0; j < points.length; j++) {
		PVector p2 = points[(j + 1) % points.length];
		PVector p3 = points[(j + 2) % points.length];
		PVector dir = PVector.sub(p3, p2).mult(1.0 / n);
		
		for (int i = 0; i < n; i++) {
			PVector p1 = lerpVector(points[j], points[(j + 1) % points.length], float(i + 1) / n);
			
			boolean[] order = orders[i % orders.length];
			int oidx = (int)random(order.length);
			
			for (int it = 0; it < i + 1; it++) {
				PVector step = PVector.add(p1, dir);
				if (order[oidx]) line(p1.x, p1.y, step.x, step.y);
				oidx = (oidx + 1) % order.length;
				p1 = step;
			}
		}
	}
}

void keyPressed() {
	if (key == ' ') loop();
}

PVector lerpVector(PVector p1, PVector p2, float pct) {
	return new PVector(lerp(p1.x, p2.x, pct), lerp(p1.y, p2.y, pct));
}
