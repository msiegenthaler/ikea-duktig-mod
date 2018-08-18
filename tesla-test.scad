include <related-external/NecksCaps.scad>;

tesla_h = 47.61;
tesla_d = 44.5;

cap_h = 10.45;

difference() {
  union() {
    translate([0, 0,-42.85]) union() {
      rotate([90,0,45]) scale(5)
        import("related-external/tesla_valve_coil.stl");
      //outer shell (to cover inlets)
      translate([0,0,-4.8]) difference() {
        cylinder(d=tesla_d,h=tesla_h, $fa=0.5, $fs=0.5);
        translate([0,0,0.01]) cylinder(d=42,h=tesla_h+0.02, $fa=0.5, $fs=0.5);
      }
    }

    //top cap
    translate([6.7,0,-0.8])
      28PCO1881();
    //bottom cap
    translate([0,6.7,-tesla_h+0.8]) rotate([0,180,0])
      28PCO1881();

    //top cover
    translate([0, 0, -1.4]) cylinder(d=20, h=1.4);
    //bottom cover
    translate([0, 0, -tesla_h]) cylinder(d=20, h=1.4);

    //outer shell top/bottom
    translate([0,0,0]) difference() {
      cylinder(d=tesla_d,h=cap_h, $fa=0.5, $fs=0.5);
      translate([0,0,0.01]) cylinder(d=42,h=cap_h+0.02, $fa=0.5, $fs=0.5);
    }
    translate([0,0,-tesla_h-cap_h]) difference() {
      cylinder(d=tesla_d,h=cap_h, $fa=0.5, $fs=0.5);
      translate([0,0,-0.01]) cylinder(d=42,h=cap_h+0.02, $fa=0.5, $fs=0.5);
    }
  }
  // top cap connector
  translate([7+9.2,-3.5,-6.1])
    cylinder(d=2.5,h=10);
  // bottom cap connector
  translate([-4.3, 18.5, -tesla_h-3.7])
    cylinder(d=2.5,h=10);

  // mark the top
  translate([-15,-5,-0.4]) rotate([0,0,90])
    linear_extrude(height = 2) text("top", 5);
}