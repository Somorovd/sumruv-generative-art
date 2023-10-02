PGraphics rays, mask;

float main_border = 30;

float ripple_width = 0.028;
int num_circs = 30;
Range circ_size_range = new Range(0.02, 0.24);
Circle[] circles = new Circle[num_circs];

Range ray_inner_range = new Range(0.02, 0.25);
Range ray_count_range = new Range(5, 45);
Range ray_gap_range = new Range(0.05, 0.30);

int grid = 3;
Bounds[] all_bounds = new Bounds[grid * grid];
float border = 0.01;
float inset = 0.12;

boolean colored_ripples = true;
boolean colored_rays = true;

int num_palettes = 2;
color[] palette = new color[5 * num_palettes];

void setup() {
	size(800, 800);
	noStroke();
	rays = createGraphics(width, height);
	mask = createGraphics(width, height);
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
		String filename = "RaysAndRipples" + Integer.toString(y) + Integer.toString(m) + Integer.toString(d) + Integer.toString(h) + Integer.toString(n) + Integer.toString(s) + ".png";
		save("Images/" + filename);
		println("Saved: " + filename);
	}
}

void draw() {
	noLoop();
	
	for (int i = 0; i < num_palettes; i++) {
		color[] pal = palettes[int(random(palettes.length))];
		for (int j = 0; j < 5; j++) {
			palette[i * 5 + j] = pal[j];
		}
	}
	
	int bg_index = int(random(palette.length));
	color bg_color = palette[bg_index];
	palette[bg_index] = palette[palette.length - 1];
	
	background(bg_color);
	
	mask.beginDraw();
	mask.noStroke();
	mask.background(0);
	mask.fill(255);
	mask.endDraw();
	
	rays.beginDraw();
	rays.background(0);
	rays.noStroke();
	rays.endDraw();
	
	float sz = (width - 2 * main_border) / grid;
	for (int j = 0; j < grid; j++) {
		for (int i = 0; i < grid; i++) {
			all_bounds[j * grid + i] = new Bounds(main_border + sz * i, main_border + sz * j, sz, sz);
		}
	}
	
	for (Bounds bounds : all_bounds) {
		for (int i = 0; i < num_circs; i++) {
			float r = circ_size_range.rand();
			float x = random(border + r / 2 , 1 - border - r / 2);
			float y = random(border + r / 2, 1 - border - r / 2);
			circles[i] = new Circle(x, y, r);
		}
		
		clip(
			bounds.x + bounds.w * inset,
			bounds.y + bounds.w * inset,
			bounds.w * (1 - 2 * inset),
			bounds.w * (1 - 2 * inset)
			);
		
		int num_ripples = int((1 - 2 * (inset)) / ripple_width) + 1;
		for (int i = 0; i < num_ripples; i++) {
			fill(
				(num_ripples - i) % 2 == 0
				? (colored_ripples ? palette[int(random(palette.length))] : 255)
				: 0
				);
			for (Circle circ : circles) {
				circle(bounds.x + bounds.w * circ.x, bounds.y + bounds.w * circ.y, bounds.w * (circ.r + ripple_width * (num_ripples - i)));
			}
		}
		
		noClip();
		
		mask.beginDraw();
		for (Circle circ : circles) {
			mask.circle(bounds.x + bounds.w * circ.x, bounds.y + bounds.w * circ.y, bounds.w * circ.r);
		}
		mask.endDraw();
		
		rays.beginDraw();
		rays.clip(bounds.x, bounds.y, bounds.w, bounds.w);
		
		if (!colored_rays) {
			rays.fill(palette[int(random(palette.length - 1))]);
		}
		
		float ray_inner = ray_inner_range.rand();
		float ray_outer = 1;
		float ray_gap = ray_gap_range.rand();
		int ray_count = ray_count_range.rand_int();
		
		float a_ray = TWO_PI / ray_count;
		float a_off = random(TWO_PI);
		
		for (int i = 0; i < ray_count; i++) {
			if (colored_rays) {
				rays.fill(palette[int(random(palette.length - 1))]);
			}
			
			rays.beginShape();
			rays.vertex(
				bounds.x + bounds.w / 2 + bounds.w * ray_inner * cos(a_off + a_ray * i),
				bounds.y + bounds.w / 2 + bounds.w * ray_inner * sin(a_off + a_ray * i)
				);
			if (a_ray > radians(15)) {
				float da = a_ray / 10;
				for (int j = 1; j < 10; j++) {
					rays.vertex(
						bounds.x + bounds.w / 2 + bounds.w * ray_inner * cos(a_off + a_ray * i + da * (1 - ray_gap) * j),
						bounds.y + bounds.w / 2 + bounds.w * ray_inner * sin(a_off + a_ray * i + da * (1 - ray_gap) * j)
						);
				}
			}
			rays.vertex(
				bounds.x + bounds.w / 2 + bounds.w * ray_inner * cos(a_off + a_ray * i + a_ray * (1 - ray_gap)),
				bounds.y + bounds.w / 2 + bounds.w * ray_inner * sin(a_off + a_ray * i + a_ray * (1 - ray_gap))
				);
			rays.vertex(
				bounds.x + bounds.w / 2 + bounds.w * ray_outer * cos(a_off + a_ray * i + a_ray * (1 - ray_gap)),
				bounds.y + bounds.w / 2 + bounds.w * ray_outer * sin(a_off + a_ray * i + a_ray * (1 - ray_gap))
				);
			rays.vertex(
				bounds.x + bounds.w / 2 + bounds.w * ray_outer * cos(a_off + a_ray * i + a_ray * (1 - ray_gap) * 0.5),
				bounds.y + bounds.w / 2 + bounds.w * ray_outer * sin(a_off + a_ray * i + a_ray * (1 - ray_gap) * 0.5)
				);
			rays.vertex(
				bounds.x + bounds.w / 2 + bounds.w * ray_outer * cos(a_off + a_ray * i),
				bounds.y + bounds.w / 2 + bounds.w * ray_outer * sin(a_off + a_ray * i)
				);
			rays.endShape(CLOSE);
		}
		rays.noClip();
		rays.endDraw();
	}
	
	PImage rays_img = rays.get();
	rays_img.mask(mask.get());
	image(rays_img, 0, 0);
}
