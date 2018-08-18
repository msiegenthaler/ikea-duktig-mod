include <canister-cap.scad>;
include <hose-connector.scad>;

barb_count = 2;

air_hole_d = 0.5;
air_hole_count = 3;

canister_cap_connector();

module canister_cap_connector() {
  difference() {
    union() {
      translate([0,0,hose_size*barb_count*0.9]) rotate([180,0,0])
        barb(hose_size, barb_count);
      translate([0,0,-height-top_wall]) canister_cap();
    };
    translate([0,0,-5])
      cylinder(h=hose_size*barb_count+10, r=hose_size*0.75/2, $fa = 0.5, $fs = 0.5 );
    for (i=[0:air_hole_count])
      rotate([0,0,360/air_hole_count*i]) translate([major_d/3,0,-top_wall*1.5])
        cylinder(d=air_hole_d,h=top_wall*3);
  };
}
