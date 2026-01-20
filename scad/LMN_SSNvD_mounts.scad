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
solarD  = 68;                              //Diameter of the solar panel holder
solarSO = solarD/2-9;                      //Screw offset of the solar panel holder
aluW    = 20;                              //Width of the aluminium profile
aluT    =  5.2;                            //Thickness of the aluminium profile
roofA   = 22;                              //Roof angle
winH    = 555;                             //Height of the window
winW    = 455;                             //Width of the window
spcW    =   4;                             //Width the spacer
outerR  = conduit_outerD(conduit_M40)/2;   //Outer diameter of the conduit
innerR  = 37.2/2;                          //Inner diameter of the conduit (tight fit)
boreR   = 3.4/2;                           //End cao bore for the solar power cable
 
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
                
                translate([0,-poleD/2-1,-solarD/2-2])
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
                rotate([0,0,a+30])
                translate([solarSO,0,4]) {
                    cylinder(h=60,r=screw_clearance_radius(M4_pan_screw));
                    rotate([0,0,30])
                    cylinder(h=22,r=nut_radius(M4_nut),$fn=6);
                }
            }

            //Ziptie guides
            for(h=[-16,8]) {
                translate([0,0,h])
                rotate_extrude() {
                    translate([poleD/2+2,0,0])
                        square([2,8]);
                }
            }           
        }
    }
}
SSNvD_solar_mount_stl();

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
SSNvD_end_cap_profile = [[     boreR,  0],
                         [  innerR-4,  2],
                         [  innerR-4, 11],
                         [  innerR-3, 11],
                         [innerR-0.9, 10],
                         [innerR-0.9, -0.9],
                         [    outerR, -0.9],
                         [    outerR, -3],
                         [     boreR, -3]];
*polygon(SSNvD_end_cap_profile);

SSNvD_end_cap_ring_profile = [[      outerR,  -0.6],
                              [      outerR,   0],
                              [      innerR,   0],
                              [      innerR,   10],
                              [  innerR-0.6,   10],
                              [  innerR-0.6,  -0.6]];
*polygon(SSNvD_end_cap_ring_profile);

module SSNvD_end_cap_stl() {
    stl("SSNvD_end_cap");

    difference() {
        union() {
            rotate_extrude() 
                polygon(SSNvD_end_cap_profile);
        }
        union() {
            for (a=[0:90:270]) {
                rotate([0,0,a]) {
                    hull() {
                        translate([innerR-0.6,0,3])  sphere(r=2.2);
                        translate([innerR-0.6,0,20]) sphere(r=2.2);
                    }
                    rotate([0,0,60])
                    translate([innerR-0.6,0,3])  sphere(r=2.2);

                    difference() {
                        union() {
                            rotate([0,0,0])
                            rotate_extrude(angle=60) 
                            translate([innerR-0.6,3,0]) circle(r=2.2);
                        }
                        union() {
                            rotate([0,0,52])
                            translate([innerR-3,0,1])  cylinder(h=4,r=0.8);
                        }
                    }                                      
                }
            }
        }
    }
}
//clip(xmin=0)
*SSNvD_end_cap_stl();

module SSNvD_end_cap_ring_stl() {
    stl("SSNvD_end_cap_ring");

    rotate_extrude() 
        polygon(SSNvD_end_cap_ring_profile);

    for (a=[0:90:270]) {
        intersection() {
            translate([0,0,-1]) cylinder(h=20, r=innerR);
            rotate([0,0,a])
            translate([innerR-0.6,0,3]) sphere(r=2);
        }
    }
}
*clip(xmin=0)
SSNvD_end_cap_ring_stl();

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
