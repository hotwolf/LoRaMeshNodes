//###############################################################################
//# LoRaMeshNodes - LiFePo4 USB Charger                                         #
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
//#   A model of a LiFePo4 USB charger board.                                   #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   December 29, 2025                                                         #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>
//include <../scad/LMN_Config.scad>

use <../lib/NopSCADlib/vitamins/pcb.scad>


USBCharger  = [// 0. Type
               "USBCharger",
               // 0. Description
               "LiFePo4 USB Charger",
               // 2. Length
               23,
               // 3. Width
               16,
               // 4. Thickness
               1.2,
               // 5. Corner radius
               0, 
               // 6. Mounting hole diameter
               1,
               // 7. Pad around mounting hole
               2.0,
               // 8. Colour of the substrate
               "Black",
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


module USBCharger() {
    translate([0,0,0]) {
        //PCB
        translate([0,0,0])   
        pcb(USBCharger);
        //USB-C
        h = 3.26;
        w = 8.94;
        r = h/2 - 0.5;
        if (true) { 
            translate([-13,-w/2,0.2])
            color("silver")
            rounded_cube_yz([10,w,h],r);
           }
    }
}
*USBCharger();

module USBCharger_cutout() {
    //Body
    difference() {
        union() {
            translate([0,0,2])
                cube([23.2,16.8,4],center=true);
        }
        union() {
            translate([-12,8.2-0.6,1.4])
                cube([24,1,1]);

            translate([-12,-8.6,1.4])
                cube([24,1,1]);

        }
    } 
    //LED
    translate([11.5-4.5,-8+3,0])
        cylinder(h=20,d=2);
    //USB-C
    h = 3.26;
    w = 8.94;
    r = h/2 - 0.5;
    if (true) { 
        translate([-13,-w/2,0.2])
        rounded_cube_yz([10,w,h],r);
        hull() {
            translate([-20,-7,-0.2])
            rounded_cube_yz([8,14,4],r);
            translate([-20,-7-6,-0.2-6])
            rounded_cube_yz([2,14+12,4+12],r);
        }
    }
}
*USBCharger_cutout();

if($preview) {    
  *USBCharger();  
}
