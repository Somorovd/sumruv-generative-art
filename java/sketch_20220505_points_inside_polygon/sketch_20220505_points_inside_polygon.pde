// Thanks to chronondecay (ays#5013) on Discord

void setup() {
  size(800, 800);
}

void draw() {
  background(255);

  PVector[] points = {
    new PVector(20, 20),
    new PVector(250, 50),
    new PVector(100, 100),
    new PVector(200, 400),
    new PVector(500, 100),
    new PVector(400, 300),
    new PVector(700, 400),
    new PVector(450, 500),
    new PVector(600, 700),
    new PVector(300, 500),
    new PVector(200, 550),
    new PVector(100, 500),
    new PVector(100, 450),
  };

  PVector mouse = new PVector(mouseX, mouseY);

  float a_sum = 0;

  for (int i = 0; i < points.length; i++)
    a_sum += signedAngle(
      points[i],
      mouse,
      points[(i + 1) % points.length]
      );

  fill(abs(a_sum - TWO_PI) < 1 ? color(255, 0, 0) : color(0));

  beginShape();
  for (PVector p : points) {
    vertex(p.x, p.y);
  }
  endShape(CLOSE);

  fill(255);
  circle(mouse.x, mouse.y, 10);
}

float signedAngle(PVector p1, PVector p2, PVector p3) {
  // Angle Measured sweeping about p2 from p1 to p3
  PVector v1 = PVector.sub(p1, p2).normalize();
  PVector v2 = PVector.sub(p3, p2).normalize();
  return acos(PVector.dot(v1, v2)) * sideOf(p2, p1, p3);
}

int sideOf(PVector p1, PVector p2, PVector p3) {
  // Which side of line p1-p2 p3 is on
  PVector v1 = PVector.sub(p2, p1);
  PVector v2 = PVector.sub(p3, p1).normalize();
  PVector dir = v1.copy().rotate(HALF_PI).normalize();
  return v2.dot(dir) > 0 ? 1 : - 1;
}
