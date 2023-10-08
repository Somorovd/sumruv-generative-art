void setup() {
	size(600, 600);
}

void draw() {
	noLoop();
	background(220);
	stroke(50);
	
	float rmax = 260;
	int num_points = 100000;
	int num_bins = 3;
	float dr = rmax / num_bins;
	
	float[] weights = new float[num_bins];
	
	float weight_sum = 0;
	for (int i = 0; i < num_bins; i++) {
		float v = float(i + 1) / num_bins;
		weights[i] = v;
		weight_sum += v;
	}
	
	for (int i = 0; i < num_points; i++) {
		float rand =  random(weight_sum);
		float ws = weight_sum;
		for (int j = 0; j < weights.length; j++) {
		  if (rand < weights[j]) {
		    float r = rmax - random(dr * j, dr * (j + 1));
		    float a = random(2 * PI);
		    point(width / 2 + r * sin(a), height / 2 + r * cos(a));
		    break;
		  } else {
		    rand -= weights[j];
		    ws -= weights[j];
		  }
		}
	}
}
