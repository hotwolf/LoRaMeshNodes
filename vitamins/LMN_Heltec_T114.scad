//###############################################################################
//# LoRaMeshNodes - Heltec T114                                                 #
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
//#   A model of a Heltec T114 LoRa mesh node.                                  #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   July 21, 2025                                                             #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>
//include <../scad/LMN_Config.scad>

use <../lib/NopSCADlib/vitamins/pcb.scad>


Heltec_T114 = [// 0. Type
               "Heltec_T144",
               // 0. Description
               "Heltec T144",
               // 2. Length
               50.80,
               // 3. Width
               22.86,
               // 4. Thickness
               1.6,
               // 5. Corner radius
               2.58, 
               // 6. Mounting hole diameter
               1,
               // 7. Pad around mounting hole
               2.0,
               // 8. Colour of the substrate
               "Black",
               // 9. True if the parts should be separate BOM items
               false,
               //10. List of hole positions
               [[11.44+ 0*2.54, 1.27],[11.44+ 0*2.54,21.59],
                [11.44+ 1*2.54, 1.27],[11.44+ 1*2.54,21.59],
                [11.44+ 2*2.54, 1.27],[11.44+ 2*2.54,21.59],
                [11.44+ 3*2.54, 1.27],[11.44+ 3*2.54,21.59],
                [11.44+ 4*2.54, 1.27],[11.44+ 4*2.54,21.59],
                [11.44+ 5*2.54, 1.27],[11.44+ 5*2.54,21.59],
                [11.44+ 6*2.54, 1.27],[11.44+ 6*2.54,21.59],
                [11.44+ 7*2.54, 1.27],[11.44+ 7*2.54,21.59],
                [11.44+ 8*2.54, 1.27],[11.44+ 8*2.54,21.59],
                [11.44+ 9*2.54, 1.27],[11.44+ 9*2.54,21.59],
                [11.44+10*2.54, 1.27],[11.44+10*2.54,21.59],
                [11.44+11*2.54, 1.27],[11.44+11*2.54,21.59],
                [11.44+12*2.54, 1.27],[11.44+12*2.54,21.59]],
               //11. List of components                                                                                       
               [[2,11.34, 180, "usb_C"]],
               //12. List of accessories to go on the BOM, SD cards, USB cables, etc. 
               [],
               //13. Grid origin if a perfboard
               [],
               //14. Optional outline polygon for odd shaped boards
               []];

L76K_GNSS = [// 0. Type
               "L76K_GNSS",
               // 0. Description
               "Heltec L76K_GNSS Module",
               // 2. Length
               18,
               // 3. Width
               16,
               // 4. Thickness
               1.6,
               // 5. Corner radius
               1, 
               // 6. Mounting hole diameter
               1,
               // 7. Pad around mounting hole
               2.0,
               // 8. Colour of the substrate
               "Green",
               // 9. True if the parts should be separate BOM items
               false,
               //10. List of hole positions
               [],
               //11. List of components                                                                                       
               [],
               //12. List of accessories to go on the BOM, SD cards, USB cables, etc. 
               [],
               //13. Grid origin if a perfboard
               [],
               //14. Optional outline polygon for odd shaped boards
               []];




module Heltec_T114() {
    translate([0,0,-6.21]) {
        //PCB
        translate([50.80/2,0,0])   
        pcb(Heltec_T114);
        //Display
        translate([0,-22.86/2,1.6])
        color("GhostWhite", 0.5)  
        rounded_cube_xy([50.80,22.86,6.21-1.6],r=2.58);
        
        translate([7.9,-17.7/2,5.22])
        color("SteelBlue")
        cube([31.25,17.70,1]);
    }
}
//Heltec_T114();

module Heltec_T114_cutout(minimal=false) {
    //Body    
    translate([0,-22.86/2,-6.21])
    rounded_cube_xy([50.80,22.86,6.21],r=1);
    //Display    
    translate([7.9,-17.70/2,0])
    linear_extrude(20) square([31.25,17.70]);
    if (!minimal) {
        translate([7.9+31.25/2,0,0.4])
        linear_extrude(16, scale=2) square([31.25,17.70], center=true);
    }
    //Connetor clearance
    translate([6.87,-17.7/2,-9.68])
    cube([50.8-6.87, 17.7, 9.68]);
    //USB-C
    h = 3.26;
    w = 8.94;
    r = h/2 - 0.5;
    if (true) { 
        translate([-10,-w/2,-6.21+1.6])
        rounded_cube_yz([10,w,h],r);
        hull() {
            translate([-10,-7,-6.21+1.6+h/2-2])
            rounded_cube_yz([8,14,4],r);
            translate([-10,-7-6,-6.21+1.6+h/2-2-6])
            rounded_cube_yz([2,14+12,4+12],r);
        }
    }
    //Buttons
    if (!minimal) {
        translate([2.5,8,0])
        cylinder(h=4, r1=2.6, r2=2.1);
        translate([2.5,-8,0])
        cylinder(h=4, r1=2.6, r2=2.1);
        hull() {
            translate([2.5,8,0])
            cylinder(h=1, r=2.4);            
            translate([5.6,6,0])
            cylinder(h=1, r=1.4);
        }
        hull() {
            translate([5.6,6,0])
            cylinder(h=1, r=1.4);
            translate([5.6,-6,0])
            cylinder(h=1, r=1.4);
        }            
        hull() {
            translate([2.5,-8,0])
            cylinder(h=1, r=2.4);            
            translate([5.6,-6,0])
            cylinder(h=1, r=1.4);
        }
    }
}
*Heltec_T114_cutout();

module Heltec_T114_buttons(h=wallT) {
    difference() {
        union() {
            translate([2.5,8,0])
            cylinder(h=4, r1=2.3, r2=1.8);
            translate([2.5,-8,0])
            cylinder(h=4, r1=2.3, r2=1.8);
            hull() {
                translate([2.5,8,0])
                cylinder(h=0.8, r=2);            
                translate([5.6,6,0])
                cylinder(h=0.8, r=1);
            }
            hull() {
                translate([5.6,6,0])
                cylinder(h=0.8, r=1);
                translate([5.6,-6,0])
                cylinder(h=0.8, r=1);
            }            
            hull() {
                translate([2.5,-8,0])
                cylinder(h=0.8, r=2);            
                translate([5.6,-6,0])
                cylinder(h=0.8, r=1);
            }
        }
        translate([0,-12,h]) cube([6,24,10]);
    }
}
Heltec_T114_buttons();

//L76K GNSS Module
module L76K_GNSS() {
            pcb(L76K_GNSS); 
}
//L76K_GNSS();

//Heltec_T114_buttons();

if($preview) {    
    *Heltec_T114();
}
