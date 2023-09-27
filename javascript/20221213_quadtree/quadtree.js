class Quadtree {
	constructor(bounds, max_count) {
		this.bounds = bounds;
		this.max_count = max_count;
		this.points = [];
		this.children = [];
	}

	addPoint(point) {
		if (!this.bounds.contains(point)) return false;
		if (this.children.length) return this.addPointToChildren(point);

		this.points.push(point);
		if (this.points.length > this.max_count) this.subdivide();
		return true;
	}

	addPointToChildren(point) {
		for (let i = 0; i < this.children.length; i++) {
			if (this.children[i].addPoint(point)) break;
		}
		return true;
	}

	findNeighbors(point, d) {
		let b = new Bounds(point.x - d, point.y - d, 2 * d, 2 * d);
		if (!this.bounds.intersects(b)) return [];

		if (this.children.length == 0)
			return this.points.filter((p) => {
				return p.dist(point) < d;
			});

		let neighbors = [];
		this.children.forEach((c) => neighbors.push(...c.findNeighbors(point, d)));
		return neighbors;
	}

	subdivide() {
		let w = this.bounds.w / 2;
		let h = this.bounds.h / 2;
		this.children = [
			new Quadtree(
				new Bounds(this.bounds.x, this.bounds.y, w, h),
				this.max_count
			),
			new Quadtree(
				new Bounds(this.bounds.x + w, this.bounds.y, w, h),
				this.max_count
			),
			new Quadtree(
				new Bounds(this.bounds.x, this.bounds.y + h, w, h),
				this.max_count
			),
			new Quadtree(
				new Bounds(this.bounds.x + w, this.bounds.y + h, w, h),
				this.max_count
			),
		];
		this.points.forEach((p) => this.addPoint(p));
		this.points = [];
	}

	show() {
		this.bounds.show();
		this.points.forEach((p) => circle(p.x, p.y, 5));
		this.children.forEach((c) => c.show());
	}
}
