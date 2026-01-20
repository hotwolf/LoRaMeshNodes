//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant A - Mounts                         #
//###############################################################################
//#    Copyright 2025 Dirk Heisswolf                                            #
//#    This file is part of the LoRaMeshNodes project.                          #
//#                                                                             #
//#    This project is free software: you can redistribute it and/or modify     #
//#    it under the terms of the GNU General Public License as published by     #
//#    the Free Software Foundation, either version 3 of the License, or        #
//#    (at your option) any later version.                                      #
//#                                                                             #
//#    This project is distributed in the hope that it will be useful,          #
//#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #
//#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
//#    GNU General Public License for more details.                             #
//#                                                                             #
//#    You should have received a copy of the GNU General Public License        #
//#    along with this project.  If not, see <http://www.gnu.org/licenses/>.    #
//#                                                                             #
//#    This project makes use of the NopSCADlib library                         #
//#    (see https://github.com/nophead/NopSCADlib).                             #
//#                                                                             #
//###############################################################################
//# Description:                                                                #
//#   Several mounts for Static Solar Node variant A.                           #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   October 6, 2025                                                           #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <LMN_Config.scad>

//Variabes     
poleD   = conduit_outerD(conduit_M40)+0.4; //Pole diameter
solarD  = 55.2;                            //Diameter of the solar panel holder
solarSO = solarD/2-7;                      //Screw offset of the solar panel holder
aluW    = 20;                              //Width of the aluminium profile
aluT    =  5.2;                            //Thickness of the aluminium profile
roofA   = 22;                            //Roof angle
winH    = 555;                             //Height of the window
winW    = 455;                             //Width of the window
spcW    =   4;                             //Width the spacer

//$fn = 128;

*%cylinder(h=200,d=poleD,center=true);
*%translate([0,-winH,-30]) cube([winW,winH,60]);


//Solar panel mount
//=================
module SSNvA_solar_mount_stl() {
     stl("SSNvA_solar_mount");

     difference() {
        //Positive
        union() {
            hull() {
                translate([poleD/2+8,0,0]) 
                rotate([0,90,0])
                    cylinder(h=2,d=solarD);
                
                translate([0,-poleD/2-1,-solarD/2-4])
                    cube([poleD/4,poleD+2,solarD+4]);
            }
        }
        //Negative
        union() {
            //Pole
            cylinder(h=100,d=poleD,center=true);
            
            //Screw holes
            for(a=[0:120:240]) {
                rotate([0,90,0])
                rotate([0,0,a+60])
                translate([solarSO,0,4]) {
                    cylinder(h=60,r=screw_clearance_radius(M4_pan_screw));
                    rotate([0,0,60]) cylinder(h=22,r=nut_radius(M4_nut),$fn=6);
                }
            }

            //Ziptie guides
            for(h=[-23,8]) {
                translate([0,0,h])
                rotate_extrude() {
                    translate([poleD/2+2,0,0])
                        square([2,8]);
                }
            }           
        }
    }
}
SSNvA_solar_mount_stl();

//! 1. Inset M4 nuts
//! 2. Attach solar penel
//! 3. Insert zipties
module SSNvA_solar_mount_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_solar_mount") {

       //$explode=1;

        //Mount
        SSNvA_solar_mount_stl();
    
        //Zipties
        for(h=[-23,8]) {
            translate([0,0,h+4])
                ziptie(ziptie_3p6mm,r=poleD/2+2,t=0);
        }
    
        //Screws and nits
        for(a=[0:120:240]) {
            rotate([0,90,0])
            rotate([0,0,a+60]) {
                translate([solarSO,0,36]) screw_and_washer(M4_pan_screw, 16);     
                translate([solarSO,0,20]) rotate([0,0,30]) nut(M4_nut);
            }
        }

//nut(M4_nut);

    }
}
//SSNvA_solar_mount_assembly();

//Window mount
//============

module SSNvA_window_mount_drill_template_stl() {
     stl("SSNvA_solar_mount_drill_mount");

     difference() {
         //Positive
         union() { 
             difference() {
                translate([-2,-2,-2]) cube([22,24,7]);
                translate([-0.2,-0.2,0])  cube([21,20.3,10]);
             }
            translate([ 5,10,0]) cylinder(h=5,d=6);
            translate([15,10,0]) cylinder(h=5,d=6);
         }
         union() { 
            translate([ 5,10,-10]) cylinder(h=25,d=3.2);
            translate([15,10,-10]) cylinder(h=25,d=3.2);
            translate([ 5,10,-3]) cylinder(h=3,d1=5,d2=2);
            translate([15,10,-3]) cylinder(h=3,d1=5,d2=2);
         }
     }
}
//SSNvA_window_mount_drill_template_stl();

module SSNvA_window_mount_extrusion_spacer_stl() {
     stl("SSNvA_solar_mount_extrusion_spacer");

     linear_extrude(80) {
         polygon([[-0.1,  20],[-0.1,  13],[   2,  11],[   2,   9],[-0.1,   7],
                  [-0.1,-0.1],[   7,-0.1],[   9,   2],[  11,   2],[  13,-0.1],
                  [20.1,-0.1],[20.1,  13],[  18,  11],[  18,   9],[20.1,   7],
                //[  20,  20],[  21,  20],[  24,  17],[  24,  -4],[  -4,  -4],[  -4,  17],[  -1,  20]]);
                  [20.1,  20],[  21,  20],[  22,  17],[  22,  -4],[  -2,  -4],[  -2,  17],[  -1,  20]]);
     }
}
//SSNvA_window_mount_extrusion_spacer_stl();

module SSNvA_window_mount_extrusion_end_cap_stl() {
    stl("SSNvA_solar_mount_extrusion_end_cap");

    difference() {
        hull() {
            translate([1,1,0]) rounded_cube_xy([22,22,1],r=2);
            translate([0,0,1]) rounded_cube_xy([24,24,16],r=2);
        }
        translate([2,2,2])
        linear_extrude(16) {
            polygon([[-0.1,  20],[-0.1,  13],[   2,  11],[   2,   9],[-0.1,   7],
                     [-0.1,-0.1],[   7,-0.1],[   9,   2],[  11,   2],[  13,-0.1],
                     [20.1,-0.1],[20.1,  13],[  18,  11],[  18,   9],[20.1,   7],
                     [20.1,20.1],[  13,20.1],[  11,  18],[   9,  18],[   7,20.1]]);
        }
    }
    
    translate([12,12,0])  cylinder(h=10,d=5);
    translate([12,12,10]) cylinder(h=2,d1=5,d2=3);
    
}
//SSNvA_window_mount_extrusion_end_cap_stl();

module SSNvA_window_mount_pole_holder_stl() {
     stl("SSNvA_window_mount_pole_holder");

     difference() {
        //Positive
        union() {
            hull() {
                translate([poleD/2+4,-10,-10]) 
                    cube([20,20,20]);                
                translate([7,-poleD/2+2,-10])
                    cube([2,poleD-4,20]);
            }
            
            hull() {
                hull() {
                    translate([poleD/2+4,-10,-10]) 
                        cube([20,20,4]);                
                    translate([7,-poleD/2+2,-10])
                        cube([2,poleD-4,4]);
                }
                hull() {
                    translate([poleD/2+4,-12,-10]) 
                        cube([20,24,2]);                
                    translate([7,-poleD/2+1,-10])
                        cube([2,poleD-2,2]);
                }
            }
            
            hull() {
                hull() {
                    translate([poleD/2+4,-10,6]) 
                        cube([20,20,4]);                
                    translate([7,-poleD/2+2,6])
                        cube([2,poleD-4,4]);
                }
                hull() {
                     translate([poleD/2+4,-12,8]) 
                        cube([20,24,2]);                
                    translate([7,-poleD/2+1,8])
                        cube([2,poleD-2,2]);
                }
            }
        }
        //Negative
        union() {
            //Pole
            cylinder(h=100,d=poleD,center=true);
            //Extrusion
            translate([poleD/2+4,-10,-20]) 
            linear_extrude(40) {
                 polygon([[-0.1,  20],[-0.1,  13],[   2,  11],[   2,   9],[-0.1,   7],
                          [-0.1,-0.1],[   7,-0.1],[   9,   2],[  11,   2],[  13,-0.1],
                          [20.1,-0.1],[20.1,   7],
                          [20.1,20.1],[  13,20.1],[  11,  18],[   9,  18],[   7,20.1]]);
            }
            
        }
    }
}
//SSNvA_window_mount_pole_holder_stl();

module SSNvA_window_mount_bracket_stl() {
    stl("SSNvA_solar_mount_bracket");

    difference() {
        //Positive
        union() {
        
            hull() {
                difference() {
                    translate([-30,10+spcW,10])
                    rotate([-roofA,0,0])
                    translate([-14,-14,40])
                        cube([28,28,60]);
               
                    translate([-30,10+spcW,10])
                    rotate([-roofA,0,0])
                    translate([-17,-11,10])
                        cube([28,28,100]);
                }
    
                translate([-5,-80-spcW,10])
                rotate([270,0,0])
                    cylinder(h=60,d=8.4);
            }
                     
            translate([-30,10+spcW,10])
                    rotate([-roofA,0,0])
                    translate([-14,-14,40])
                        cube([28,28,60]);
      
             for(h=[55,85]) {                 
                translate([-30,10+spcW,10])
                rotate([-roofA,0,0])
                translate([0,0,h]) {
                    translate([0,14,0])
                    rotate([270,0,0]) cylinder(h=2, d=screw_boss_diameter(M4_pan_screw)+4);
                }                 
             }
          
            
        }
        //Negative
        union() {
            
            translate([-5,-90-spcW,10])
            rotate([270,0,0])
                cylinder(h=80,d=6.5);
          
            translate([-30,10+spcW,10])
            rotate([-roofA,0,0])
            translate([-10,-10,10])
            linear_extrude(100) {
                 polygon([[-0.1,  20],[-0.1,  13],[   2,  11],[   2,   9],[-0.1,   7],
                          [-0.1,-0.1],[   7,-0.1],[   9,   2],[  11,   2],[  13,-0.1],
                          [20.1,-0.1],[20.1,  13],[  18,  11],[  18,   9],[20.1,   7],
                          [20.1,20.1],[  13,20.1],[  11,  18],[   9,  18],[   7,20.1]]);
            }

            for(h=[55,85]) {                 
                translate([-30,10+spcW,10])
                rotate([-roofA,0,0])
                translate([0,0,h]) {
                    rotate([270,0,0]) cylinder(h=20, r=screw_clearance_radius(M4_pan_screw));
                    translate([0,12,0])
                    rotate([270,0,0]) cylinder(h=20, d=screw_boss_diameter(M4_pan_screw));
                    
                    translate([0,5,0])
                    rotate([270,0,0]) cube([16,16,6],center=true);
                }                 
            }            
        }
    }
}
//SSNvA_window_mount_bracket_stl();

//! 1. Drill 6mm holes into the extrusions
//! 2. Cut M5 threads into the end of upper horizontal the extrusion
//! 3. Insert the spacers
module SSNvA_window_mount_extrusion_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_mount_extrusion") {

        //Upper horizontal extrusion
        explode([0,40,0])
        difference() {
            translate([-20,10+spcW,10])
            rotate([0,90,0])
                extrusion(E2020,winW+40,cornerHole=false,center=false);     
            union() {
                for (x=[-5,winW+5]) {
                    translate([x,-5,10])
                    rotate([270,0,0])
                        cylinder(h=40,d=6);
                
                } 
            }
        }

        //Lower horizontal extrusion
        explode([0,-40,0])
        difference() {
            translate([-10,-winH-10-spcW,10])
            rotate([0,90,0])
                extrusion(E2020,winW+20,cornerHole=false,center=false);     
            union() {
                for (x=[-5,winW+5]) {
                    translate([x,5-winH,10])
                    rotate([90,0,0])
                        cylinder(h=40,d=6);
                
                } 
            }
        }

        //Vertical extrusion
        explode([-40,0,0])
        difference() {
            translate([-30,10+spcW,10])
            rotate([-roofA,0,0])
            translate([0,0,-10])
                extrusion(E2020,300,cornerHole=false,center=false);
             translate([-50,10+spcW,10])
             rotate([0,90,0])
                cylinder(h=40,d=6);

        }

    }
}
//$explode=1;
//SSNvA_window_mount_extrusion_assembly();

//! 1. attach all parts
module SSNvA_window_mount_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_window_mount") {


        //Extrusions
        SSNvA_window_mount_extrusion_assembly();
    
        //Threaded rods
        for (x=[-5,winW+5]) {    
            translate([x,-winH-40-spcW,10])
            rotate([270,0,0])
                studding(6,winH+2*spcW+80,center=false);
        }

        //Nuts
        for (x=[-5,winW+5]) {
        
            translate([x,20+spcW,10])
            rotate([270,0,0])
                nut_and_washer(M6_nut,false);
            
            translate([x,-winH-20-spcW,10])
            rotate([90,0,0])
                nut_and_washer(M6_nut,false);            
        }

        //Screw
        translate([-40,10+spcW,10])
        rotate([0,270,0])
            screw_and_washer(M6_hex_screw, 30);

        //Bracket
        SSNvA_window_mount_bracket_stl();
        
        //Bracket screws
        for(h=[55,85]) {                 
            translate([-30,10+spcW,10])
            rotate([-roofA,0,0])
            translate([0,0,h]) {
                translate([0,12,0])
                rotate([270,0,0])                  
                    screw_and_washer(M4_pan_screw,10);
                
                translate([0,5,0])
                rotate([270,0,0])                  
                    nut_square(M4_nut);
             }                 
         }  
    }
}
//SSNvA_window_mount_assembly();

//Vertical mount
//==============
//module SSNvA_vertical_mount_stl() {
//     stl("SSNvA_vertical_mount");
//
//     difference() {
//        //Positive
//        union() {
//            hull() {
//                translate([poleD/2+2,-aluW/2-1,-10]) 
//                    cube([2,aluW+2,20]);                
//                translate([7,-poleD/2+2,-10])
//                    cube([2,poleD-4,20]);
//            }
//            
//            hull() {
//                hull() {
//                    translate([poleD/2+2,-aluW/2-1,-10]) 
//                        cube([2,aluW+2,4]);                
//                    translate([7,-poleD/2+2,-10])
//                        cube([2,poleD-4,4]);
//                }
//                hull() {
//                     translate([poleD/2+2,-aluW/2-2,-10]) 
//                        cube([2,aluW+4,2]);                
//                    translate([7,-poleD/2+1,-10])
//                        cube([2,poleD-2,2]);
//                }
//            }
//            
//             hull() {
//                hull() {
//                    translate([poleD/2+2,-aluW/2-1,6]) 
//                        cube([2,aluW+2,4]);                
//                    translate([7,-poleD/2+2,6])
//                        cube([2,poleD-4,4]);
//                }
//                hull() {
//                     translate([poleD/2+2,-aluW/2-2,8]) 
//                        cube([2,aluW+4,2]);                
//                    translate([7,-poleD/2+1,8])
//                        cube([2,poleD-2,2]);
//                }
//            }
//        }
//        //Negative
//        union() {
//            //Pole
//            cylinder(h=100,d=poleD,center=true);
//            
//            //Aluminium rod
//            translate([poleD/2+aluT/2+2,0,0])
//                cube([aluT,aluW,100],center=true);
//        }
//    }
//}
//SSNvA_vertical_mount_stl();

//Horizontal mount
//================
//module SSNvA_horizontal_mount(r=4) {
//     L = 25; //Length of the mount
//
//     difference() {
//        //Positive
//        union() {
//            translate([-L/2,-(aluW*cos(roofA))/2,0])
//                rounded_cube_xz([L,aluW*cos(roofA)+aluT*sin(roofA),40],r=r);
//        }
//        //Negative
//        union() {
//            translate([0,0,1+(aluW/2)*sin(roofA)])
//            rotate([-roofA,0,0])
//            translate([-50,-aluW/2,0])
//                cube([100,aluW,aluT+10],center=false);
//            translate([-50,-40,1+aluW*sin(roofA)])
//                cube([100,80,aluT+80],center=false);
//        }
//    }
//}
////SSNvA_horizontal_mount();
//
//module SSNvA_horizontal_mountR4_stl() {
//     stl("SSNvA_horizontal_mountR4");
//
//     SSNvA_horizontal_mount(4);
//}
//SSNvA_horizontal_mountR4_stl();
//
//module SSNvA_horizontal_mountR0_stl() {
//     stl("SSNvA_horizontal_mountR0");
//
//     SSNvA_horizontal_mount(0);
//}
//SSNvA_horizontal_mountR0_stl();

if($preview) {    
//    SSNvA_solar_mount_stl();
//    SSNvA_vertical_mount_stl();
//    SSNvA_horizontal_mountR0_stl();

}
