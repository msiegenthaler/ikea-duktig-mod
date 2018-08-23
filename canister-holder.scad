height = 120;
thickness = 4;

stabilizator = 10;
stabilizator_h = 7;

board_width = 180;
board_thickness = 12.0;
board_gap = 0.2;
board_holder_s = 10;
board_holder_t = 1;
board_overlap = 5;

// holder_front();
holder_back();

module holder_front() {
container_lift = 34;
  difference() {
    base();
    translate([0,container_lift,50]) rotate([180,0,0]) {
      cutout_front();
    }
  }
}

module holder_back() {
  container_lift = 5;
  difference() {
    base();
    translate([0,container_lift,50]) rotate([180,0,0]) {
      cutout_back();
    }
  }
}

module base() {
  w = board_width + 2*board_holder_s;
  translate([-w/2,0,0]) {
    cube([w, height, thickness]);
    stabilize_on_board(w);
    holder_flaps();
  }
}

module holder_flaps() {
  h = board_thickness + 2*board_gap;
  h2 = h + board_holder_s;
  w = board_width + 2*board_holder_s;
  a = board_holder_s - board_gap;
  b = board_holder_s + board_overlap;
  linear_extrude(board_holder_t) polygon([
    [0  ,0],
    [w , 0],
    [w , -h2],
    [w-board_holder_s, -h2],
    [w-b, -h],
    [w-a, -h],
    [w-a, 0],
    [a, 0],
    [a, -board_thickness],
    [b, -board_thickness],
    [a, -h2],
    [0, -h2],
  ]);
}

module stabilize_on_board(w) {
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

module cutout_back() {
  size = 4;
  w = 17.3;   //width at the end
  add_h = 50; //additional height
  h = 11.8;
  d = 100;
  ps = [
    [ 0,   0],
    [ 0,   0.7],
    [ 9,   0.7],
    [10,   0.9],
    [10.25, 1],
    [11.1, 2],
    [11.4, 3],
    [11.5, 4],
    [11.6, 5],
    [11.6, 6],
    [11.6, 7],
    [11.67, 8],
    [11.78, 9],
    [11.9, 10],
    [12.1, 11],
    [12.45, 12],
    [13.1, 13],
    [14.0, 14],
    [15.0, 15],
    [16,   15.8],
    [17,   16.3],
    [18,   16.7],
    [19,   17.0],
    [20,   17.2],
    [21,   17.3],
    [add_h,w],
    [add_h,0],
  ];
  scale([size,size]) {
    rotate([0,0,-90]) linear_extrude(d) polygon(points = ps);
    translate([0,0,d])rotate([180,0,-90]) linear_extrude(d) polygon(points = ps);
  }
}