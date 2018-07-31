include <related-external/simplethreads.scad>
include <hose-connector.scad>;

// 3/8 connector
module 38_connector() {
  thread(1.337, 16.66, 12, 7);
}

module faucet_connector() {
  difference() {
    38_connector();
    translate([0,0,-1])
      cylinder(d=inner_hose_size, h=30, $fa=0.1, $fs=0.1);
  }
}

module hose_connector() {
  barb_count = 3;
  translate([0,0,-hose_size*barb_count*0.9])
    barb(hose_size, barb_count);
}

faucet_connector();
hose_connector();
