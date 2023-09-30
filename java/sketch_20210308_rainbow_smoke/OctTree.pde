class Point {
	float x, y, z;
	OctTree sub_ot;
	int dup = 1;
	
	Point(float x, float y, float z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	void setOT(OctTree ot) {
		sub_ot = ot;
	}
	
	boolean equals(Point other) {
		return(x == other.x && y == other.y && z == other.z);
	}
	
	void removeSelf() {
		sub_ot.remove();
	}
}

class OctTree {
	
	float x1, x2, y1, y2, z1, z2;
	boolean divided = false;
	OctTree parent = null;
	int contains = 0;
	
	Point point = null;
	OctTree[] children;
	
	OctTree(float x1, float x2, float y1, float y2, float z1, float z2, OctTree parent) {
		this.x1 = x1;
		this.x2 = x2;
		this.y1 = y1;
		this.y2 = y2;
		this.z1 = z1;
		this.z2 = z2;
		this.parent = parent;
	}
	
	void subdivide() {
		if (divided) return;
		
		float x_mid = (x2 + x1) / 2;
		float y_mid = (y2 + y1) / 2;
		float z_mid = (z2 + z1) / 2;
		OctTree fnw = new OctTree(x1, x_mid, y1, y_mid, z1, z_mid, this);
		OctTree fne = new OctTree(x_mid, x2, y1, y_mid, z1, z_mid, this);
		OctTree fse = new OctTree(x_mid, x2, y_mid, y2, z1, z_mid, this);
		OctTree fsw = new OctTree(x1, x_mid, y_mid, y2, z1, z_mid, this);
		OctTree bnw = new OctTree(x1, x_mid, y1, y_mid, z_mid, z2, this);
		OctTree bne = new OctTree(x_mid, x2, y1, y_mid, z_mid, z2, this);
		OctTree bse = new OctTree(x_mid, x2, y_mid, y2, z_mid, z2, this);
		OctTree bsw = new OctTree(x1, x_mid, y_mid, y2, z_mid, z2, this);
		children = new OctTree[]{fnw, fne, fse, fsw, bnw, bne, bse, bsw};
		
		divided = true;
		
		for (OctTree ot : children) {
			if (ot.insert(point)) {
				break;
			}
		}
		point = null;
	}
	
	boolean insert(Point p) {
		if (p.x < x1 || p.x >= x2 || p.y < y1 || p.y >= y2 || p.z < z1 || p.z >= z2) {
			return false;
		}
		else contains++;
		
		if (!divided) {
			if (point == null) {
				point = p;
				p.setOT(this);
			} else if (point.equals(p)) {
				point.dup++;
				p.dup = point.dup;
				p.sub_ot = point.sub_ot;
			} else {
				subdivide();
			}
		}
		
		if (children != null) {
			for (OctTree ot : children) {
				if (ot.insert(p)) break;
			}
		}
		
		return true;
	}
	
	OctTree getSubOT(Point p) {
		if (p.x < x1 || p.x >= x2 || p.y < y1 || p.y >= y2 || p.z < z1 || p.z >= z2) {
			return null;
		}
		
		if (!divided) {
			return(point != null) ? this : null;
		} else {
			for (OctTree ot : children) {
				OctTree sub_ot = ot.getSubOT(p);
				if (sub_ot != null) return sub_ot;
			}
		}
		return this;
	}
	
	void remove() {
		// remove point from current OT,
		// and collapse parent OT if necessary
		// since finding neighbors makes certain assumptions
		// about the density of the OT
		
		point.dup--;
		contains--;
		
		OctTree curr_ot = this;
		OctTree nearest_parent = null;
		
		while(curr_ot.parent != null) {
			curr_ot = curr_ot.parent;
			curr_ot.contains--;
			if (nearest_parent == null && curr_ot.contains > point.dup) {
				nearest_parent = curr_ot;
			}
		}
		
		if (nearest_parent != null) {
			curr_ot = nearest_parent;
		}
		
		if (point.dup > 0) return;
		else point = null;
		
		ArrayList<Point> found = new ArrayList<Point>();
		
		curr_ot.query(curr_ot.x1, curr_ot.x2, curr_ot.y1, curr_ot.y2, curr_ot.z1, curr_ot.z2, found);
		curr_ot.point = null;
		curr_ot.divided = false;
		curr_ot.contains = 0;
		for (Point p : found) {
			curr_ot.insert(p);
		}
	}
	
	void query(float _x1, float _x2, float _y1, float _y2, float _z1, float _z2, ArrayList<Point> found) {
		// check overlapping rects
		if (x1 > _x2 || x2  < _x1 || y1 > _y2 || y2 < _y1 || z1 > _z2 || z2 < _z1) {
			return;
		}
		
		if (children != null) {
			for (OctTree ot : children) {
				ot.query(_x1, _x2, _y1, _y2, _z1, _z2, found);
			}
		} else if (point != null) {
			if (point.x >= _x1 && point.x < _x2 && point.y >= _y1 && point.y < _y2 && point.z >= _z1 && point.z < _z2) {
				found.add(point);
			}
		}
	}
}
