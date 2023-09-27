let qt;
let nbrs = [];
let d = 60;

function setup() {
	createCanvas(800, 800);
	qt = new Quadtree(new Bounds(0, 0, width, height), 4);
}

function keyPressed() {
	if (key == " ") loop();
	if (key == "s") save();
	if (key == "q") findClosest();
}

function mousePressed() {
	let p = createVector(mouseX, mouseY);
	qt.addPoint(p);
}

function findClosest() {
	let p = createVector(mouseX, mouseY);
	nbrs = qt.findNeighbors(p, d);
}

function draw() {
	noFill();
	background(255);
	qt.show();

	circle(mouseX, mouseY, 2 * d);

	fill(255, 0, 0);
	nbrs.forEach((n) => circle(n.x, n.y, 5));
}
