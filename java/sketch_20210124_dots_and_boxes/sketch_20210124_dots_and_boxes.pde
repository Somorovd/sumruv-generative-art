/*

Genuary Days 23-25
23: #264653 #2a9d8f #e9c46a #f4a261 #e76f51, no gradients
24: 500 lines (ive since dropped that constraint)
25: make a grid of permutations of something

*/

color DARK = color(38, 70, 83);
color[] palette = {color(42, 157, 143), color(233, 196, 106), color(244, 162, 97), color(231, 111, 81)};

float border = 75;
int main_grid = 3;
float main_gap_pct = 0.35;
int game_grid = 10;
float game_gap_pct = 0.22;

void setup() {
	size(800, 800);
	strokeCap(PROJECT);
}

void draw() {
	noLoop();
	background(255);
	
	float w = width - 2 * border;
	w /= main_grid + (main_grid - 1) * main_gap_pct;
	float h = height - 2 * border;
	h /= main_grid + (main_grid - 1) * main_gap_pct;
	
	Game[] games = new Game[main_grid * main_grid];
	
	for (int i = 0; i < main_grid; i++) {
		for (int j = 0; j < main_grid; j++) {
			float x = border + w * (1 + main_gap_pct) * i;
			float y = border + h * (1 + main_gap_pct) * j;
			Bounds game_bounds = new Bounds(x, y, w, h);
			games[j * main_grid + i] = new Game(game_bounds, game_grid, game_gap_pct);
		}
	}
	
	for (int i = 0; i < games.length; i++) {
		Game g = games[i];
		int row = i / main_grid;
		int col = i % main_grid;
		
		g.playGame(0.6);
		g.showLines();
		g.showBoxes();
		
		if (row % 2 == col % 2) {
			stroke(DARK);
			strokeWeight(2);
			noFill();
			g.bounds.getScaled(1 + main_gap_pct * 2 / 3).show();
		}
	}
}

void keyPressed() {
	if (key == ' ') {
		loop();
	}
	if (key == 's' || key == 'S') {
		int y = year();
		int m = month();
		int d = day();
		int h = hour();
		int n = minute();
		int s = second();
		String filename = "DotsBoxes" + Integer.toString(y) + Integer.toString(m) + Integer.toString(d) + Integer.toString(h) + Integer.toString(n) + Integer.toString(s) + ".png";
		save("Images/" + filename);
		println("Saved: " + filename);
	}
}
