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
roofA   = 30;                             //Roof angle

//$fn = 128;

*%cylinder(h=200,d=poleD,center=true);

//ziptie(ziptie_3p6mm,r=25,t=10);

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
                    rotate([0,0,30]) cylinder(h=36,r=nut_radius(M4_nut),$fn=6);
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
//SSNvA_solar_mount_stl();

//Vertical mount
//==============
module SSNvA_vertical_mount_stl() {
     stl("SSNvA_vertical_mount");

     difference() {
        //Positive
        union() {
            hull() {
                translate([poleD/2+2,-aluW/2-1,-10]) 
                    cube([2,aluW+2,20]);                
                translate([7,-poleD/2+2,-10])
                    cube([2,poleD-4,20]);
            }
            
            hull() {
                hull() {
                    translate([poleD/2+2,-aluW/2-1,-10]) 
                        cube([2,aluW+2,4]);                
                    translate([7,-poleD/2+2,-10])
                        cube([2,poleD-4,4]);
                }
                hull() {
                     translate([poleD/2+2,-aluW/2-2,-10]) 
                        cube([2,aluW+4,2]);                
                    translate([7,-poleD/2+1,-10])
                        cube([2,poleD-2,2]);
                }
            }
            
             hull() {
                hull() {
                    translate([poleD/2+2,-aluW/2-1,6]) 
                        cube([2,aluW+2,4]);                
                    translate([7,-poleD/2+2,6])
                        cube([2,poleD-4,4]);
                }
                hull() {
                     translate([poleD/2+2,-aluW/2-2,8]) 
                        cube([2,aluW+4,2]);                
                    translate([7,-poleD/2+1,8])
                        cube([2,poleD-2,2]);
                }
            }
        }
        //Negative
        union() {
            //Pole
            cylinder(h=100,d=poleD,center=true);
            
            //Aluminium rod
            translate([poleD/2+aluT/2+2,0,0])
                cube([aluT,aluW,100],center=true);
        }
    }
}
//SSNvA_vertical_mount_stl();

//Horizontal mount
//================
module SSNvA_horizontal_mount_stl() {
     stl("SSNvA_horizontal_mount");

     L = 20; //Length of the mount

     difference() {
        //Positive
        union() {
            translate([-L/2,-(aluW*cos(roofA))/2,0])
                cube([L,2+aluW*cos(roofA),4+aluW*sin(roofA)]);
        }
        //Negative
        union() {
            translate([0,0,2+(aluW/2)*sin(roofA)])
            rotate([-roofA,0,0])
            translate([-50,-aluW/2,0])
                #cube([100,aluW,aluT+10],center=false);
            translate([-50,-40,2+aluW*sin(roofA)])
                cube([100,80,aluT+80],center=false);
        }
    }
}
SSNvA_horizontal_mount_stl();

if($preview) {    
//    SSNvA_solar_mount_stl();
//    SSNvA_vertical_mount_stl();
//    SSNvA_horizontal_mount_stl();

}
