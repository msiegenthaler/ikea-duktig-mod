include <hose-connector.scad>;
include <related-external/NecksCaps.scad>;


rotate([180,0,0]) bottle_cap_connector();

module bottle_cap_connector() {
  barb_count = 2;
  difference() {
    union() {
      translate([0,0,-hose_size*barb_count*0.9]) barb(hose_size, barb_count);
      28PCO1881();
    };
    translate([0,0,-5])
      cylinder(h=hose_size*barb_count+10, r=hose_size*0.75/2, $fa = 0.5, $fs = 0.5 );
  };
}
