include <related-external/simplethreads.scad>

pitch = 4.5;
major_d = 36.8;
rotations = 3;
step = 5;
tolerance = 1.1;

side_wall = 4;
top_wall = 1.8;
height = pitch * (rotations + 0.5);

holders_d = 10;
holders_in = 1;

module canister_cap() {
  difference() {
    canister_cap_raw();
    canister_thread_internal();
  }
}

module canister_cap_raw() {
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
