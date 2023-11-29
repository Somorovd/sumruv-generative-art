ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<ArrayList<PVector>> shapes = new ArrayList<ArrayList<PVector>>();

void colorize() {
	loadPixels();
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			int i = (y * width + x);
			int r = pixels[i] >> 16 & 0xFF;  // red component of rgb
			
			if (r > 0 && r % 3 ==  0) {
			  pixels[i] = color(255, 0, 0);
			} else if (r > 0 && r % 3 ==  1) {
			  pixels[i] = color(0, 0, 255);
			} else if (r > 0 && r % 3 ==  2) {
			  pixels[i] = color(255, 255, 255);
			}
		}
	}
	updatePixels();
}

void setup() {
	size(600, 600);
	background(0);
}

void draw() {
	
	stroke(255);
	strokeWeight(3);
	
	if (mousePressed) {
		
		line(mouseX, mouseY, pmouseX, pmouseY);
		points.add(new PVector(mouseX, mouseY));
		
	} else if (!mousePressed && points.size() > 2) {
		
		background(0);
		fill(255, 0, 0, 1);
		noStroke();
		
		shapes.add(points);
		points = new ArrayList<PVector>();
		
		for (ArrayList < PVector > shape : shapes) {
			beginShape();
			for (PVector p : shape) {
				vertex(p.x, p.y);
			}
			endShape(CLOSE);
		}
		
		colorize();
		
	}
}
