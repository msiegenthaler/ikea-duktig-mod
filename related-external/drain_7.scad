// from https://www.thingiverse.com/thing:1858532

/* drain_7
 * set the 'roundHoles' to true to get circular side holes or to 
 * false to get rectangular side holes.
 * at the end of this file, uncomment the lines:
 * rim();
 * or
 * basket();
 * to generate the object you want.
 */

roundHoles      = true; //false;

dExt            = 70;
dIntTop         = 44;
dIntBottom      = 40;
depth           = 10;
epsilon         = 2;
space           = 2;
partWidth       = 3;
partHeight      = 2.5;

rBase           = dIntBottom/2.0;
rTop            = rBase + (dIntTop/2.0 - rBase)*(depth+partHeight)/depth;

lowerRingWidth  = 2.2;
lowerStripWidth = lowerRingWidth-1;
wallThickness   = 2;
angleStep       = 30;

splitSpace      = 1.1;
rBump           = 1;
shiftBump       = 0.5;
transBump       = shiftBump/2.0;

$fn             = 100;

module topDisk(){
    h  = partHeight;
    rB = dExt/2.0;
    rT = (dExt-2*partHeight)/2.0;
    cylinder(r1=rB,r2=rT,h=h);
}
module cup(inner){
    h  = depth + partHeight;
    factor = (inner ? wallThickness + 0.4 : 0);
    rb = rBase - factor;
    rt = rTop  - factor;
    translate([0,0,-depth])
        cylinder(r1=rb,r2=rt,h=h);
}
module lowerCuttingRings(){
    rX0 = lowerRingWidth*2.0;
    rI0 = rX0-lowerRingWidth;
    rX1 = rX0*2.0;
    rI1 = rX1-lowerRingWidth;
    h   = wallThickness+2*epsilon;
    translate([0,0,-depth])
        linear_extrude(height=h,center=true){
            for (i=[lowerRingWidth:lowerRingWidth:dIntBottom/3 - (1+wallThickness)])
                difference(){
                    rE = i*2.0;
                    circle(r=rE);
                    circle(r=rE-lowerRingWidth);
                }
        }
}
module lowerStrips(){
    x = rBase - lowerRingWidth/2.0;
    y = lowerStripWidth; 
    z = wallThickness;
    for (i=[0:angleStep:360]){
        rotate([0,0,i]){
            translate([0,-y/2.0,-depth])
                cube([x,y,z]);
        }
    }
}
module cupSideCutterSingleRect(){
    x  = wallThickness+2*epsilon;
    y  = lowerStripWidth*1.5; 
    z  = depth-wallThickness;
    x0 = rBase-2*epsilon; // - lowerRingWidth/2.0-epsilon;
    difference(){
        translate([x0,-y/2.0,-z])
            cube([x,y,z]);
        translate([x0,-y/2.0,-(z+wallThickness)/2.0])
            cube([x,y,wallThickness]);
    }
}
module cupSideCuttersR(){
    rotate([0,0,angleStep/6.0]){
        for (i=[0:angleStep/3.0:360]){
            rotate([0,0,i]){
                cupSideCutterSingleRect();
            }
        }
    }
}
module cupSideCutterSingleCyl(){
    h  = wallThickness+2*epsilon;
    r  = 0.25 + (lowerStripWidth*1.5)/2.0; 
    z  = depth-wallThickness;
    x0 = rBase-2*epsilon; 
    translate([x0,0,0])
        rotate([0,90,0])
            cylinder(r=r,h=h);
}
module cupSideCuttersC(){
    r=(lowerStripWidth*1.5)/2.0; 
    count=0;
    dZ = -r-1;
    decZ = -2*r-2;
    for (j=[0:1:1]){
        translate([0,0,dZ + j*decZ]){
            for (i=[0:angleStep/3.0:360]){
                rotate([0,0,i+(j*angleStep/6.0)]){
                    cupSideCutterSingleCyl();
                }
            }
        }
    }
}
module cupSideCutters(){
    if (roundHoles){
        cupSideCuttersC();
    }
    else{
        cupSideCuttersR();
    }
}
module topCutterSingle(){
    x  = dExt/2.0 - rTop - epsilon-4;
    y  = lowerStripWidth*2; 
    z  = partHeight + 4*epsilon;
    x0 = rTop+epsilon+1;
    translate([x0,-y/2.0,-2*epsilon])
        cube([x,y,z]);
}
module topCutters(){
    rotate([0,0,angleStep/6.0]){
        for (i=[0:angleStep/3.0:360]){
            rotate([0,0,i]){
                topCutterSingle();
            }
        }
    }
}
module make0(){
    difference(){
        union(){
            topDisk();
            cup(false);
        }
        translate([0,0,wallThickness])
            cup(true);
    }
}
module make1(){
    difference(){
        make0();
        lowerCuttingRings();
    }
    lowerStrips();
}
module make2(){
    difference(){
        make1();
        cupSideCutters();
    }
}
module make3(){
    difference(){
        make2();
        topCutters();
    }
}

module bumpSingle(){
    r = rBump; 
    x = rTop+shiftBump;
    y = 0;
    z = partHeight/2.0;
    translate([x,y,z])
        sphere(r);
}
module bumpArray(shiftedOut){
    tX = (shiftedOut ? transBump : 0);
    for (angle=[0:90:360]){
        rotate([0,0,angle])
            translate([tX,0,0])
                bumpSingle();
    }
}
module basket(){
    h  = depth + partHeight + epsilon;
    difference(){
        make3();
        translate([0,0,-depth-epsilon/2.0])
            difference(){
                cylinder(r=2*rTop+epsilon,h=h);
                cylinder(r=rTop + splitSpace*0.9,h=h);  
                // maybe the splitSpace is screwed up?
            }
        }
    //bumpArray(false);
}
module rimNoBumps(){
    h = depth + partHeight + epsilon;
    difference(){
        make3();
        translate([0,0,-depth-epsilon/2.0])
            cylinder(r=rTop+splitSpace+transBump,h=h);
    }
}
module rim(){
    difference(){
        rimNoBumps();
        bumpArray(true);
    }
}
// Un comment one or both of the next line to generate the objects 
// inverted.

//rotate([180,0,0])
    make3();
