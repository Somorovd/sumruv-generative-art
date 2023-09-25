/*

 For GENUARY 2021 : Day 8
 Prompt : Curves Only
 
 */

void setup() {
  size(1200, 800);
  fill(0);
  noStroke();
}

void draw() {
  noLoop();
  background(255);

  int partition_size = 70;
  int num_bins = 10;
  int min = 3;
  int max = 15;
  float add_factor = 0.8; // 0 -> 1  chaotic -> uniform
  int num_additions = int(add_factor * (partition_size - num_bins * min));

  float border = -40;
  float w = (width - 2 * border) / (partition_size);
  float h = 50;

  int num_main_rows = 4;
  int main_row_circ = 8;
  int main_row_points = 80;
  int[] lerp_rows_range = {7, 25};
  int lerp_row_circ = 3;
  int[] points_per_row_range = {60, 300};


  PVector[][] all_points = new PVector[num_main_rows][num_bins + 1];

  for (int j = 0; j < num_main_rows; j++) {
    float row_offset = 2 * h * (j - int(num_main_rows / 2));
    float row_h = height / 2 + row_offset;

    PVector[] points = new PVector[num_bins + 1];
    float[] parts = partition(0, partition_size, num_bins, num_additions, min, max);
    for (int i = 0; i < points.length; i++) {
      float x = border + parts[i] * w;
      float y = row_h + h * (i % 2 == 0 ? 1 : - 1);
      points[i] = new PVector(x, y);
    }
    all_points[j] = points;
  }

  PVector[] lerp_row_points = new PVector[all_points[0].length];	

  for (int i = 0; i < all_points.length - 1; i++) {		
    int num_lerp_rows = int(random(lerp_rows_range[0], lerp_rows_range[1]));
    int points_per_row = int(random(points_per_row_range[0], points_per_row_range[1]));

    for (int k = 0; k < num_lerp_rows; k++) {
      float pct = k / float(num_lerp_rows);

      for (int j = 0; j < lerp_row_points.length; j++) {
        lerp_row_points[j] = lerpVector(all_points[i][j], all_points[i + 1][j], pct);
      }

      PVector[] ch = chaikin(lerp_row_points, 3);
      PVector[] lerp_row = spaceEvenly(ch, points_per_row);

      for (PVector p : lerp_row) {
        circle(p.x, p.y, lerp_row_circ);
      }

      int k_mod = k % num_lerp_rows;
      if (k_mod == 0 || (i == all_points.length - 2 && k_mod == num_lerp_rows - 1)) {
        PVector[] main_row = spaceEvenly(ch, main_row_points);
        for (PVector p : main_row) {
          circle(p.x, p.y, main_row_circ);
        }
      }
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
    String filename = "CurvesOnly" + Integer.toString(y) + Integer.toString(m) + Integer.toString(d) + Integer.toString(h) + Integer.toString(n) + Integer.toString(s) + ".png";
    save("Images/" + filename);
    println("Saved: " + filename);
  }
}
