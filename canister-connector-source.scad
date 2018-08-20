include <canister-cap.scad>;
include <hose-connector.scad>;

barb_count = 2;
barb_offset = 10;

snorkel_h = 220;
snorkel_d = 6;
snorkel_d_inner = snorkel_d - 2*1.2;
snorkel_d_top = 2;
snorkel_offset = 6;

canister_cap_connector();

module canister_cap_connector() {
  difference() {
    union() {
      translate([barb_offset,0,hose_size*barb_count*0.9]) rotate([180,0,0])
        barb(hose_size, barb_count);
      translate([0,0,-height-top_wall])
        canister_cap();
      translate([-snorkel_offset,0,0])
        snorkel();
    };
    translate([barb_offset,0,-5])
      cylinder(h=hose_size*barb_count+10, r=hose_size*0.75/2, $fa = 0.5, $fs = 0.5 );
    translate([-snorkel_offset, 0, -5])
      cylinder(h=10, d=snorkel_d_top, $fa=0.1, $fs=0.1);
  };
}

module snorkel() {
  translate([0,0,-snorkel_h]) difference() {
    cylinder(d=snorkel_d, h=snorkel_h, $fa=0.1, $fs=0.1);
    translate([0,0,-0.01])
      cylinder(d=snorkel_d_inner, h=snorkel_h+0.02, $fa=0.1, $fs=0.1);
  }
}