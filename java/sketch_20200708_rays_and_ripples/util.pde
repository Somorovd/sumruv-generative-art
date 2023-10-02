class Bounds {
	float x, y, w, h;
	
	Bounds(float x, float y, float w, float h) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
}

class Circle {
	float x, y, r;
	
	Circle(float x, float y, float r) {
		this.x = x;
		this.y = y;
		this.r = r;
	}
	
	void show() {
		circle(x, y, r);
	}
}

class Range {
	float min, max;
	
	Range(float min, float max) {
		this.min = min;
		this.max = max;
	}
	
	float rand() {
		return random(min, max);
	}
	
	int rand_int() {
		return int(rand());
	}
}
