height = 120;
container_lift = 34;
// TODO 
thickness = 1;

stabilizator = 10;
stabilizator_h = 7;

board_width = 180;
board_thickness = 12.0;
board_gap = 0.2;
board_holder_s = 10;
board_overlap = 5;


difference() {
  base();
  translate([0,container_lift,50]) rotate([180,0,0]) {
    cutout_front();
  }
  translate([0,0,-50]) linear_extrude(100) {
    air_cutout();
    rotate([0,180,0]) air_cutout();
  }
}

module base() {
  w = board_width + 2*board_holder_s;
  d = board_thickness + board_holder_s;
  h2 = board_thickness + board_holder_s;
  difference() {
    translate([-w/2,0,0]) {
      cube([w, height, thickness]);
      stabilize_on_board();
      linear_extrude(thickness) polygon([
        [0  ,0],
        [w , 0],
        [w , -h2],
        [w-board_holder_s, -h2],
        [w-board_holder_s-board_overlap, -board_thickness],
        [w-board_holder_s-board_overlap, 0],
        [board_holder_s+board_overlap, 0],
        [board_holder_s+board_overlap, -board_thickness],
        [board_holder_s, -h2],
        [0, -h2],
      ]);
    }
    board_with_gap();
  }
}

module stabilize_on_board() {
  w = board_width + 2*board_holder_s;
  translate([w,0,0]) rotate([0,-90,0]) linear_extrude(w) polygon([
    [0,0],
    [stabilizator,0],
    [0,stabilizator_h],
  ])
  cube([w, thickness, thickness+stabilizator]);
}

module board_with_gap() {
  d = 100;
  h = board_thickness + 2*board_gap;
  w = board_width+2*board_gap;
  translate([-w/2,-h,-d/2])
    cube([w, h, d]);
}

module air_cutout() {
  polygon([[20,15],[75,10],[80,50]]);
}

module cutout_front() {
  size = 4; //scale (mm per unit)
  w = 18;   //width at the end
  add_h = 20;   //additional height
  h = 11.8;
  d = 100;
  ps = [
    [-add_h,0],
    [0, 0],
    [1, 0.13],
    [2, 0.5],
    [3, 1.05],
    [4, 1.86],
    [5, 2.7],
    [6, 3.8],
    [7, 5.2],
    [8, 6.8],
    [9.2, 9],
    [9.75, 10],
    [10.2, 11],
    [10.6, 12],
    [10.9, 13],
    [11.2, 14],
    [11.5, 15],
    [11.6, 16],
    [11.8, 17],
    [11.8, 18],
    [-add_h,w],
  ];

  scale([size,size]) {
    translate([w,-h],0) rotate([0,0,90]) linear_extrude(d) polygon(points = ps);
    translate([-w,-h,d]) rotate([180,0,90]) linear_extrude(d) polygon(points = ps);
  }
}