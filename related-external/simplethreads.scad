// Metric Screw Thread Library
// by Maximilian Karl <karlma@in.tum.de> (2014)
// modified the api to create internal threads, smooth the start and
// stop threads, and use imperial units: 
//
// 
//
// use module thread_imperial(pitch, majorD, stepAngle, numRotations, tol, internal) 
//         or thread(pitch, majorD, stepAngle, numRotations, tol, internal)
// with the parameters:
// pitch        - screw thread pitch
// majorD       - screw thread major diameter
// step         - step size in degrees (36 gives ten steps per rotation)
// numRotations - the number of full rotations of the thread
// tol          - (optional parameter for internal threads) the amount to increase the 
//                 thread size in mm.Default is 0
// internal     - (optional parameter for internal threads) - this can be set true or  
//                false.  Default is true

root3 = sqrt(3);
root3div3 = root3/3;

//-----------------------------------------------------------------------------------------------
//EXAMPLES:
//example: this creates a 3/8-inch 16TPI bolt using metric units
//thread(1.5875,9.5250,12,12);

//the same thread using imperial units
//thread_imperial(1/19,3/8,12,12);

//an internal thread that will accomodate the two examples above
//translate([15,0,0]){
// difference(){
//    cylinder(r=12,h=8, $fa=60);
//    translate([0,0,-1.337/2]) { 
//        thread(1.337,
//               16.66, //outer d
//               12,
//               8,
//               0.2,
//               true);
//    }
// }
//}
//------------------------------------------------------------------------------------------------

//Creates a thread cross section starting with an equilateral triangle
//and removing the point.  Internal threads (for creating nuts) will 
//have a non-zero tolerance value which enlarges the triangle to
//accomodate a bolt of the same size
module screwthread_triangle(P, tol) {
    cylinderRadius=root3div3*(P+2*tol);
    translate([2*tol,0,0]){
        difference() {
            translate([-cylinderRadius+root3/2*(P)/8,0,0])
            rotate([90,0,0])
            cylinder(r=cylinderRadius,h=0.00001,$fn=3,center=true);
            
            translate([-tol,-P/2,-P/2]){
                cube([P,P,P]); 
            }

            translate([-P,-P/2,P/2]){
               cube([P,P,P]); 
            }
            
            translate([-P,-P/2,-3*P/2]){
               cube([P,P,P]); 
            }
        }
    }
}

//Hulls two consecutive thread triangles to create a segment of the thread
module threadSegment(P,D_maj, step, tol){
    for(i=[0:step:360-step]){
    hull()
        for(j = [0,step])
        rotate([0,0,(i+j)])
        translate([D_maj/2,0,(i+j)/360*P])
           screwthread_triangle(P, tol);
    }  
}

//Places enough thread segments to create one full rotation.  The first
//and last portion of external threads (for making bolts) are tapered 
//at a 20 degree angle for an easier fit
module screwthread_onerotation(P,D_maj,step, tol=0, first=false, last=false, internal=false) {
	H = root3/2*P;
	D_min = D_maj - 5*root3/8*P;       
        
         if(internal==false){ 
            difference(){ 
                threadSegment(P,D_maj, step, 0); 
                if(first==true){
                   //echo("first thread");
                    translate([D_maj/2-P/2,0,-P/2]){
                        rotate(-20,[0,0,1]){translate([0,-P*5,0]){cube([P,P*10,P]); }}}
                }
                
                if(last==true){
                   //echo("last thread");
                    translate([D_maj/2-P/2,0,-P/2+P]){
                        rotate(20,[0,0,1]){translate([0,-P*5,0]){cube([P,P*10,P]); }}}
                }
            }
            
        }else{
            threadSegment(P,D_maj+tol, step, tol);          
        }
 
               
        //make the cylinder a little larger if this is to be an internal thread
        if(internal==false){
            translate([0,0,P/2])
            cylinder(r=D_min/2,h=2*P,$fn=360/step,center=true);
        }else{
            translate([0,0,P/2])
            cylinder(r=D_min/2+tol,h=2*P,$fn=360/step,center=true);          
        }
}

//creates a thread using inches as units (tol is still in mm)
module thread_imperial(pitch, majorD, stepAngle, numRotations, tol=0, internal = false){
    p=pitch*25.4;
    d=majorD*25.4;
    thread(p,d,stepAngle,numRotations, tol);
}

//creates a thread using mm as units
module thread(P,D,step,rotations, tol=0, internal = false) {
    // added parameter "rotations"
    // as proposed by user bluecamel
	for(i=[0:rotations-1])
	translate([0,0,i*P]){
            if(i==0&&rotations<=1){
                screwthread_onerotation(
                P,D,step, tol, true, true, internal); //first if there is only one rotation
            }else if(i==0){
                screwthread_onerotation(
                P,D,step, tol, true, false, internal); //first if more than one rotation
            }else if(i==rotations-1){
                screwthread_onerotation(
                P,D,step, tol, false, true, internal); //last if more than one rotation
            }else{
                screwthread_onerotation(
                P,D,step, tol, false, false, internal); //middle threads
            }
        }
}







