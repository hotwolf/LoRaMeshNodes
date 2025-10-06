//###############################################################################
//# LoRaMeshNodes - Lithiom-Polymer Battery                                     #
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
//#   A model of a LiPo battery.                                                #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   July 18, 2025                                                             #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>

//                                                               l   w     h  r  c
//                                                               e   i     e  a  o
//                                                               n   d     i  d  n
//                                                               g   t     g  i  n
//                                                               t   h     h  u  e
//                                                               h         t  s  c
//                                                                               t
//                                                                               o
//                                                                               r
lipo_103450   = ["103450", "Lithium-Polymer-Akku 3,7V 2500mAh", 45, 34, 10.2, 1, 7];
lipo_755060   = ["755060", "Lithium-Polymer-Akku 3,7V 3000mAh", 60, 50,  7.5, 1, 3];

lipos    = [lipo_103450, lipo_755060];

function lipo_type(type)          = type[0]; //! Battery type
function lipo_length(type)        = type[2]; //! Battery length
function lipo_width(type)         = type[3]; //! Battery width
function lipo_height(type)        = type[4]; //! Battery height
function lipo_radius(type)        = type[5]; //! Corner radius
function lipo_connector(type)     = type[6]; //! Width of the battery connector

module lipo(type) { //! Draw a battery
    vitamin(str("LiPo", type[0], "): ", type[1]));

    length      = lipo_length(type);
    width       = lipo_width(type);
    height      = lipo_height(type);
    radius      = lipo_radius(type);
    connector   = lipo_connector(type);

    //Battery   
    translate([radius,radius,radius]) 
    color("silver")
    cube([length-2*radius,width-2*radius,height-2*radius]);
    
    //Protective wrapper
    color("gold",0.5)
    minkowski() {
        sphere(r=radius, $fn=32);
        
        translate([radius,radius,radius]) 
        color("silver")
        cube([length-2*radius,width-2*radius,height-2*radius]);
    }

    //Connector
    color("gold",0.5)
    hull() {
        translate ([length,                        radius, height/2]) sphere(r=radius, $fn=32);
        translate ([length,                  width-radius, height/2]) sphere(r=radius, $fn=32);
        translate ([length+connector-radius,       radius, height/2]) sphere(r=radius, $fn=32);
        translate ([length+connector-radius, width-radius, height/2]) sphere(r=radius, $fn=32);
    }
}

module lipo_103450() {
  lipo(lipo_103450);
}

if($preview) {    
   *lipo(lipo_103450);
}
