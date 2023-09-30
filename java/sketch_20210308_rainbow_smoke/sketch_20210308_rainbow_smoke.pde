// PARAMETERS
int g = 250;
int num_seeds = 1;
int color_dist = 2;
int add_dist = 2;  // n_dist must be <= color_dist
float surrounded_weight = 4; // weight scale for having filled neighbors
int weight_distance = 1;

// GLOBALS
PImage img;
OctTree main_ot;
Cell[] cells;
ArrayList<Cell> fillable_cells = new ArrayList<Cell>();
float weight_total;

void setup() {
	size(800, 800);
	noStroke();
	
	// Images must be stored in a folder named Data
	img = loadImage("img1.jpg");
	img.loadPixels();
	INIT();
}

void INIT() {
	float w = float(width) / g;
	float h = float(height) / g;
	
	main_ot = imagePixelsToOctTree(img, g);
	cells = createCellGrid(g, w, h);
	fillable_cells = new ArrayList<Cell>();
	weight_total = 0;
}

void draw() {
	noLoop();
	background(255, 0, 255);
	
	float t1 = millis();
	
	for (int i = 0; i < num_seeds; i++) {
		int rand_idx = (int) random(g * g);
		Cell seed_cell = cells[rand_idx];
		
		if (seed_cell.filled) continue;
		else seed_cell.filled = true;
		
		Point rand_point = new Point((int)random(255),(int)random(255),(int)random(255));
		OctTree sub_ot = main_ot.getSubOT(rand_point);
		Point seed_point = getNearest(sub_ot, rand_point);
		
		fillCell(seed_cell, seed_point);
	}
	
	for (int it = 0; it < (g * g) - num_seeds; it++) {
		Cell cell = new Cell(0, 0, 0, 0, 0);
		
		float rand = random(weight_total);
		for (int i = 0; i < fillable_cells.size(); i++) {
			cell = fillable_cells.get(i);
			rand -= cell.weight;
			if (rand < 0) {
				Cell last = fillable_cells.get(fillable_cells.size() - 1);
				fillable_cells.set(i, last);
				fillable_cells.remove(fillable_cells.size() - 1);
				break;
			}
		}
		
		cell.filled = true;
		weight_total -= cell.weight;
		
		Point avg = calculateNeighborAverage(cell);
		OctTree avg_ot = main_ot.getSubOT(avg);
		Point nearest = getNearest(avg_ot, avg);
		fillCell(cell, nearest);
	}
	
	float t2 = millis();
	float dt = t2 - t1;
	println("Time: ", dt);
	
	for (Cell cell : cells) {
		cell.show();
	}
}

void keyPressed() {
	if (key == ' ') {
		loop();
		INIT();
	}
	
	if (key == 's' || key == 'S') {
		int y = year();
		int m = month();
		int d = day();
		int h = hour();
		int n = minute();
		int s = second();
		String filename = "RainbowSmoke_" + Integer.toString(y) + Integer.toString(m) + Integer.toString(d) + Integer.toString(h) + Integer.toString(n) + Integer.toString(s) + ".png";
		save("Images/" + filename);
		println("Saved: " + filename);
	}
}
