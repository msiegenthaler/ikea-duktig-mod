include <related-external/simplethreads.scad>
include <hose-connector.scad>;
include <related-external/NecksCaps.scad>;

barb_count = 2;

pitch = 4.5;
major_d = 36.8;
rotations = 3;
step = 5;
tolerance = 1.1;

side_wall = 2.2;
top_wall = 1.8;
height = pitch * (rotations + 0.5);

holders_d = 10;
holders_in = 1;

air_hole_d = 0.5;
air_hole_count = 3;

canister_cap_connector();

module canister_cap_connector() {
  difference() {
    union() {
      translate([0,0,hose_size*barb_count*0.9]) rotate([180,0,0])
        barb(hose_size, barb_count);
      translate([0,0,-height-top_wall]) cap();
    };
    translate([0,0,-5])
      cylinder(h=hose_size*barb_count+10, r=hose_size*0.75/2, $fa = 0.5, $fs = 0.5 );
    for (i=[0:air_hole_count])
      rotate([0,0,360/air_hole_count*i]) translate([major_d/3,0,-top_wall*1.5])
        cylinder(d=air_hole_d,h=top_wall*3);
  };
}

module cap() {
  difference() {
    cap_raw();
    canister_thread_internal();
  }
}

module cap_raw() {
  d = major_d + 2*side_wall + 2*holders_in;
  h = height+top_wall;
  count = floor(d * PI / holders_d);
  difference() {
    cylinder(d=d, h=h, $fa=0.1, $fs=0.1);
    for (i=[0:count]) {
      rotate([0,0,i*360/count])
        translate([-(d+holders_d)/2 + holders_in,0,-0.01])
          cylinder(d=holders_d, h=h+0.02);
    }
  }
}

module canister_thread_internal() {
  thread(
    pitch,
    major_d,
    step,
    rotations,
    tolerance,
    true
  );
}