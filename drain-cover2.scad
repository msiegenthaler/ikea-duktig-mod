outer_d = 48;
outer_h = 8;

lower_d = outer_d*0.85;
grid_depth = 3;

side_wall = 1.6;
bottom_wall = 2;

no_rings = 3;
ring_thickness = 1.8;

no_strips = 12;
strip_width = 1.6;
strip_thickness = 1;

middle_ring_d = 10;
ring_middle_offset = middle_ring_d*1.5;
middle_ring_holes = 12;
middle_ring_hole_d = 0.8;

no_side_holes = 32;
no_side_holes_rows = 3;
side_hole_d = 1.2;

module body() {
  difference() {
    cylinder(d1=lower_d, d2=outer_d, h=outer_h, $fa=0.5, $fs=0.5);
    translate([0,0,-0.01])
      cylinder(d1=lower_d-side_wall*2,
              d2=outer_d-side_wall*2,
              h=outer_h+0.02,
              $fa=0.5, $fs=0.5);
    for (j = [1:no_side_holes_rows]) {
      z_offset = (j+0.8)*outer_h/(no_side_holes_rows+2);
      for (i = [0:no_side_holes]) {
        rotate([0,0,i*(360/no_side_holes)])
          translate([0,outer_d/2+side_wall*2,z_offset]) rotate([90,0,0])
          cylinder(d=side_hole_d, h=outer_d/2, $fa=0.5, $fs=0.2);
      }
    }
  }
}

module rings() {
  d = lower_d - 2*side_wall - ring_middle_offset;
  b = d / no_rings;
  z = grid_depth / (no_rings+1);
  for (i = [0:no_rings]) {
    translate([0,0,-z*(no_rings-i)])
    difference() {
      cylinder(d=i*b+ring_thickness+ring_middle_offset, h=bottom_wall, $fa=0.5, $fs=0.5);
      translate([0,0,-0.01])
        cylinder(d=i*b-ring_thickness+ring_middle_offset, h=bottom_wall+0.02, $fa=0.5, $fs=0.5);
    };
  }
}

module strips() {
  deg = 360 / no_strips;
  l = sqrt(pow(lower_d/2, 2) + pow(grid_depth, 2));
  k = atan(grid_depth/l);
  intersection() {
    translate([0,0,-grid_depth]) difference() {
      for (i = [0:no_strips]) {
        rotate([0,-k,deg*i]) translate([0,-strip_width/2,0])
          cube([lower_d/2+10,strip_width,strip_thickness]);
      }
      cylinder(d=middle_ring_d, h=100);
    }
    translate([0,0,-50]) cylinder(d=lower_d, h=100, $fa=0.5, $fs=0.5);
  }
}

module middle_ring() {
  deg = 360 / middle_ring_holes;
  translate([0,0,-grid_depth]) difference() {
    cylinder(d=middle_ring_d, h=bottom_wall);
    for (i = [0:middle_ring_holes]) {
      rotate([0,0,deg*i]) translate([0,middle_ring_d/3.5,-0.01])
        cylinder(d=middle_ring_hole_d,h=bottom_wall+0.02, $fa=2, $fs=0.2);
    }
    translate([0,0,-0.01])
      cylinder(d=middle_ring_hole_d,h=bottom_wall+0.02, $fa=2, $fs=0.2);
  }
}

body();
rings();
strips();
middle_ring();