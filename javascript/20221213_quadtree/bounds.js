class Bounds {
	constructor(x, y, w, h) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	contains(point) {
		return (
			point.x > this.x &&
			point.x <= this.x + this.w &&
			point.y > this.y &&
			point.y <= this.y + this.h
		);
	}

	intersects(bounds) {
		return (
			this.contains(createVector(bounds.x, bounds.y)) ||
			this.contains(createVector(bounds.x + bounds.w, bounds.y)) ||
			this.contains(createVector(bounds.x + bounds.w, bounds.y + bounds.h)) ||
			this.contains(createVector(bounds.x, bounds.y + bounds.h)) ||
			bounds.contains(createVector(this.x, this.y)) ||
			bounds.contains(createVector(this.x + this.w, this.y)) ||
			bounds.contains(createVector(this.x + this.w, this.y + this.h)) ||
			bounds.contains(createVector(this.x, this.y + this.h))
		);
	}

	show() {
		rect(this.x, this.y, this.w, this.h);
	}
}
