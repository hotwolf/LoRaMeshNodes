//###############################################################################
//# LoRaMeshNodes - Antenna                                                     #
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
//#   A selection of LoRa antennas.                                             #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   July 21, 2025                                                             #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>
use     <../lib/NopSCADlib/vitamins/antenna.scad>
//                                                                                       t
LoRa_20cm_antenna   =  ["LoRa_20cm_antenna", 
                        "20cm LoRa Antenna",
                        200,                       //! Total length
                        6,                         //! Diameter at the top
                        13,                        //! Diameter at the base
                        20.6,                      //! Split point
                        20.6,                      //! Length of the straight part
                        [5.3, 26, 1.7, 8.5, 2],    //! Hinge post width, z value of the pin, pin diameter, width reduction and slot width
                        [13.1, 13, 6.5],             //! Grip d, h, h2
                        [[97.6, 0.7, 0.6],         //! List of ring z, thickness, depths
                         [99, 0.7, 0.6]],          //! Space for left panel, washers and nuts when screwed on fully.
                        6.45];                     //! Panel hole radius


module LoRa_20cm_antenna(wall=3, angle=90) {
   antenna(LoRa_20cm_antenna, wall, angle);   
}

module LoRa_N_antenna(wall=3) {
    vitamin(str("LoRa_N_antenna: Antenna with N.connector"));
    
    //Socket
    intersection() {
        translate([0,0,0]) color("Silver") cylinder(h=22, d=15.8);
        cube([30,13.5,60], center=true);
    }
    translate([0,0,wall]) color("Silver") cylinder(h=2.6, d=21.4, $fn=6);
       
    translate([0,0, -2])   color("Red") cylinder(h=2, d=22.8);
    translate([0,0, -4.4]) color("Silver") cylinder(h=2.4, d=22.8);
    translate([0,0, -8])   color("Silver") cylinder(h=3.6, d=14.1);
    translate([0,0,-15])   color("Silver") cylinder(h=7,   d=7);
    translate([0,0,-38])   color("Black")  cylinder(h=23,  d=4);
    
    //Antenna
    translate([0,0, 12.2]) color("Silver") cylinder(h=22.4, d=20);
    translate([0,0, 34.6]) color("Silver") cylinder(h=40.5, d=23);
    translate([0,0, 34.6]) color("SlateGray") cylinder(h=400, d=20);
}


if($preview) {
   *LoRa_N_antenna();
   //antenna(LoRa_40cm_antenna, 3, 90);
}
