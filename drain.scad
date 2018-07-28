include <hose-connector.scad>

// The cutout in the original ikea drain
drain_cutout_d = 63.7;
cutout_depth = 1.9;


drain_hole_diameter = 50;
drain_hole_depth = 11;

barb_count = 2;
wall_strength = 0.6;

rotate([0,180,0])
  drain();


module attachment() {
  margin_d = 40;
  depth = 1.4;
  translate([0,0,-depth-cutout_depth]) {
    color("green") cylinder(d=drain_cutout_d+margin_d, h=depth, $fa=0.5, $fs = 0.5);
    translate([0,0,-0.001])
      cylinder(d=drain_cutout_d, h=cutout_depth+depth, $fa=0.5, $fs = 0.5);
  }
}

module deco() {
  deco_count = 12;
  deco_d = 2.3;
  for (i = [0:deco_count-1]) {
    rotate([0,0,360/deco_count*i])
      translate([drain_cutout_d/2 - (drain_cutout_d-drain_hole_diameter)/4,0,-deco_d*0.65])
        sphere(deco_d, $fa=0.5, $fs = 0.5);
  }
}

module drain() {
  s_z = drain_hole_depth+wall_strength;
  difference() {
    union() {
      attachment();
      translate([0,0,-s_z])
        cylinder(d=drain_hole_diameter+2*wall_strength, h=s_z, $fa=0.5, $fs = 0.5);
      translate([0,0,-hose_size*barb_count*0.95 - s_z])
        barb(hose_size, barb_count);
    }
    translate([0,0,-drain_hole_depth+0.01])
      cylinder(d=drain_hole_diameter, h=drain_hole_depth, $fa=0.5, $fs = 0.5);
    translate([0,0,-s_z-barb_count*hose_size])
      cylinder(d=hose_size*0.75, h=s_z+barb_count*hose_size,  $fa=0.5, $fs = 0.5);
  }
  // deco();
}
