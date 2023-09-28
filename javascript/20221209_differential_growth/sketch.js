const num_points = 30;
const border = 100;
const d_scl = 1 / 10;
const split_dist = 15;
let qt, qt_bounds;
let qt_count = 3;
let bounds, points;
let nbr_d_max = 100;
let nbr_d_min = 40;
let d_time = 20;

let IS_PAUSED = false;

function setup() {
	createCanvas(800, 800);
	pixelDensity(1);
	bounds = new Bounds(border, border, width - 2 * border, height - 2 * border);
	qt_bounds = new Bounds(0, 0, width, height);
	INIT();
	noFill();
	stroke(0);
	strokeWeight(1);
}

function keyPressed() {
	if (key == " ") INIT();
	if (key == "s") save();
	if (key == "p") pause();
}

function pause() {
	IS_PAUSED = !IS_PAUSED;
	if (IS_PAUSED) loop();
	else noLoop();
}

function INIT() {
	loop();
	qt = new Quadtree(qt_bounds, qt_count);
	points = [];

	let point_spacing = (width - 2 * border) / (num_points - 1);
	for (let i = 0; i < num_points; i++) {
		let p = createVector(
			border + point_spacing * i + random(-20, 20),
			height / 2 + random(-30, 30)
		);
		points.push(p);
		qt.addPoint(p);
	}
}

function draw() {
	console.log(frameRate());
	background(255);

	let bounds = new Bounds(
		border,
		border,
		width - 2 * border,
		height - 2 * border
	);
	bounds.show();

	let nbr_d = map(millis(), 0, d_time * 1000, nbr_d_max, nbr_d_min);

	let movements = new Array(points.length);
	for (let i = 0; i < points.length; i++) {
		let p1 = points[i];
		movements[i] = createVector(0, 0);
		let nbrs = qt.findNeighbors(p1, nbr_d);
		for (let j = 0; j < nbrs.length; j++) {
			let p2 = nbrs[j];

			let dir = p5.Vector.sub(p1, p2).normalize();
			let d = p1.dist(p2);

			if (d > 200) continue;

			let mag = 1 / sq(d * d_scl);

			movements[i].add(dir.setMag(mag));
		}
	}

	for (let i = 0; i < points.length; i++)
		if (bounds.contains(points[i])) points[i].add(movements[i].limit(10));

	let new_points = [];
	for (let i = 0; i < points.length - 1; i++) {
		let p = points[i];
		let p_next = points[i + 1];
		let d = p.dist(p_next);

		new_points.push(p);
		if (d > split_dist) new_points.push(lerpVector(p, p_next, 0.5));
	}
	new_points.push(points[points.length - 1]);
	points = new_points;

	connectPoints(points);

	qt = new Quadtree(qt_bounds, qt_count);
	for (let i = 0; i < points.length; i++) qt.addPoint(points[i]);
}

function connectPoints(points) {
	beginShape();
	points.forEach((p) => vertex(p.x, p.y));
	endShape();
}

function lerpVector(v1, v2, pct) {
	return createVector(lerp(v1.x, v2.x, pct), lerp(v1.y, v2.y, pct));
}
