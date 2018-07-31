hose_size = 12.7;
inner_hose_size = hose_size * 0.75;

// Generate a single barb notch
module barbnotch( inside_diameter ){
  cylinder( h = inside_diameter * 1.0, r1 = inside_diameter * 0.85 / 2, r2 = inside_diameter * 1.16 / 2, $fa = 0.5, $fs = 0.5 );
}

module solidbarbstack( inside_diameter, count ) {
  union() {
    barbnotch( inside_diameter );
    for (i=[2:count]) {
      translate([0,0, (i-1) * inside_diameter * 0.9]) barbnotch( inside_diameter );
    }
  }
}

module barb( inside_diameter, count )
{
  difference() {
    solidbarbstack( inside_diameter, count );
    translate([0,0,-0.3]) cylinder( h = inside_diameter * (count + 1), r = inner_hose_size / 2, $fa = 0.5, $fs = 0.5 );
  }
}