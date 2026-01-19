//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant D - Mounts                         #
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
//#   Several mounts for Static Solar Node variant D.                           #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   January 17, 2026                                                          #
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
roofA   = 22;                              //Roof angle
winH    = 555;                             //Height of the window
winW    = 455;                             //Width of the window
spcW    =   4;                             //Width the spacer
outerR  = conduit_outerD(conduit_M40)/2;   //Outer diameter of the conduit
innerR  = conduit_innerD(conduit_M40)/2;   //Inner diameter of the conduit
boreR   = 3;                               //End cao bore for the solar power cable
 
$fn = 128;

*%cylinder(h=200,d=poleD,center=true);
*%translate([0,-winH,-30]) cube([winW,winH,60]);


//Solar panel mount
//=================
module SSNvD_solar_mount_stl() {
     stl("SSNvD_solar_mount");

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
                    rotate([0,0,30]) cylinder(h=22,r=nut_radius(M4_nut),$fn=6);
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
//SSNvD_solar_mount_stl();

//! 1. Inset M4 nuts
//! 2. Attach solar penel
//! 3. Insert zipties
module SSNvD_solar_mount_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_solar_mount") {

       //$explode=1;

        //Mount
        SSNvD_solar_mount_stl();
    
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
    }
}
*SSNvD_solar_mount_assembly();

//End cap
//=======
//SSNvD_end_cap_profile = [[     boreR,   -2],
//                         [    outerR,   -2],
//                         [    outerR,    0],
//                         [    innerR,    0],
//                         [    innerR,    4],
//                         [  innerR-1,    6],
//                         [  innerR-1,    7],
//                         [    innerR,    9],
//                         [    innerR,   10],
//                         [  innerR-1,   12],
//                         [  innerR-1,   14],
//                         [  innerR-2,   14],
//                         [  innerR-2,   12],
//                         [  innerR-1,   10],
//                         [  innerR-1,    9],
//                         [  innerR-2,    7],
//                         [  innerR-2,    6],
//                         [  innerR-1,    4],
//                         [  innerR-1,    2],
//                         [     boreR,    0]];

SSNvD_end_cap_profile = [[     boreR,   -3],
                         [    outerR,   -3],
                         [    outerR,   -1],
                         [  innerR-0,   -1],
                         [  innerR-1,    0],
                         [  innerR-1,    2],
                         [    innerR,    3],
                         [    innerR,    4],
                         [  innerR-1,    5],
                         [  innerR-2,    5],
                         [  innerR-2,    0],
                         [     boreR,   -1]];
*polygon(SSNvD_end_cap_profile);

//SSNvD_end_cap_ring_profile = [[      innerR,   4.8],
//                              [  innerR-0.2,   4.8],
//                              [  innerR-0.8,   6],
//                              [  innerR-0.8,   7],
//                              [  innerR-0.2,   8.2],
//                              [      innerR,   8.2],
//                              [      innerR,   7.3],
//                              [  innerR-0.4,   6.5],
//                              [      innerR,   5.7]];

SSNvD_end_cap_ring_profile = [[      outerR,  -1],
                              [      outerR,   0],
                              [      innerR,   0],
                              [      innerR,   2.8],
                              [  innerR-0.6,   2.2],
                              [  innerR-0.6,  -0.2],
                              [  innerR+0.2,  -1]];
*polygon(SSNvD_end_cap_ring_profile);

module SSNvD_end_cap_stl() {
    stl("SSNvD_end_cap");

    difference() {
        union() {
            rotate_extrude() 
                polygon(SSNvD_end_cap_profile);
        }
        union() {
            for (a=[0:20:160]) {
                rotate([0,0,a])
                translate([0,0,4])
                    cube([40,2,8],center=true);

            }
        }
    }
}
*SSNvD_end_cap_stl();

module SSNvD_end_cap_ring_stl() {
    stl("SSNvD_end_cap_ring");

//    difference() {
//        union() {
//            rotate_extrude() 
//                polygon(SSNvD_end_cap_ring_profile);
//        }
//        union() {
//            for (a=[0:60:300]) {
//                translate([0,0,22.6])
//                rotate([0,40,a]) {
//                    translate([0,0,1])
//                        cube([60,2,2],center=true);
//                    translate([0,0,0])
//                    rotate([0,90,0])
//                        cylinder(h=60,d=2,center=true);
//
//                }
//            }
//        }
//    }

    rotate_extrude() 
        polygon(SSNvD_end_cap_ring_profile);

}
*SSNvD_end_cap_ring_stl();

//module SSNvD_end_cap_template_stl() {
//    stl("SSNvD_end_cap_template");
//
//    rotate_extrude() {
//        translate([innerR-0.2,0,0])
//            square([0.2,5]);
//        
//    }   
//}
//*SSNvD_end_cap_template_stl();

//Spacer
//======
module SSNvD_spacer_stl() {
     stl("SSNvD_spacer");

     translate([0,0,-7])
     difference() {
        //Positive
        union() {
            hull() {
                cylinder(h=14, r=outerR);
                translate([20,-5,0]) cube([10,10,14]);
            }
            hull() {
                hull() {
                    translate([0,0,0]) cylinder(h=2, r=outerR);
                    translate([20,-10,0]) cube([10,20,2]);
                }
                hull() {
                    translate([0,0,2]) cylinder(h=2, r=outerR-2);
                    translate([20,-5,2]) cube([10,10,2]);
                }
            }
    
             hull() {
                hull() {
                    translate([0,0,12]) cylinder(h=2, r=outerR);
                    translate([20,-10,12]) cube([10,20,2]);
                }
                hull() {
                    translate([0,0,10]) cylinder(h=2, r=outerR-2);
                    translate([20,-5,10]) cube([10,10,2]);
                }
            }
        }
        //Negative
        union() {
               cylinder(h=40, r=outerR+0.1, center=true);
        }
    }
}
*SSNvD_spacer_stl();

//! 1. Insert spacer when mounting the router with zipties
module SSNvD_spacer_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_spacer") {

    //Spacer
    rotate([0,0,180])
    SSNvD_spacer_stl();

    //Ziptie
    translate([-5,0,0])
    ziptie(ziptie_3p6mm,r=poleD/2+5,t=0);
    }
}
*SSNvD_spacer_assembly();

if($preview) {    
    *SSNvD_solar_mount_stl();
}
