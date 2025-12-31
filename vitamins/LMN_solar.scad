//###############################################################################
//# LoRaMeshNodes - Solar panel                                                 #
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
//#   A model of a solar panel.                                                 #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   July 21, 2025                                                             #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>

//                                                                                      l    w   h     b
//                                                                                      e    i   e     u
//                                                                                      n    d   i     m
//                                                                                      g    t   g     p
//                                                                                      t    h   h     s
//                                                                                      h        t    
solar_142x88        = ["solar_142x88",       "Solar Panel 142x88mm² 5V 5W",           142,  88,  3,   []];
solar_100x100       = ["solar_100x100",      "Solar Panel 100x100mm² 5V 3W",          100, 100,  3,   [[25.5,2],[74.5,2],[25.5,98],[74.5,98]]];
solar_175x175       = ["solar_175x175",      "Solar Panel 175x175mm² 6V 5W",          175, 175,  3,   [[150.5,97.5],[150.2,115.4],[140.0,97.5],[140.0,115.4]]];
flex_solar_198x100  = ["flex_solar_198x100", "Flexible Solar Panel 198x100mm² 6V 1W", 198, 100,  1.5, [[17,17.7],[17,81.2]]];


solars         = [solar_142x88, solar_100x100];

function solar_type(type)          = type[0]; //! Solar panel type
function solar_length(type)        = type[2]; //! Solar panel length
function solar_width(type)         = type[3]; //! Solar panel width
function solar_height(type)        = type[4]; //! Solar panel height
function solar_bumps(type)         = type[5]; //! solder bumps on the backside

module solar(type) {
    vitamin(str("solar(", type[0], "): ", type[1]));

    length      = solar_length(type);
    width       = solar_width(type);
    height      = solar_height(type);
    bumps       = solar_bumps(type);

    color("MidnightBlue")
    translate([0,0,0])
      cube([length, width, height]);
 
    //Solder bumps
    intersection() {
        for (bump=bumps) {
//            echo(bump);
            color("silver")
            translate([bump.x,bump.y,0])
                minkowski() { 
                    cylinder(h=0.4, r=5);
                    sphere(0.4);
                }
             }
        translate([0,0,-10]) cube([width, length, 20]);
    }
}

module solar_100x100() {
    solar(solar_100x100);   
}


module flex_solar(type,d) {
    vitamin(str("flex_solar(", type[0], ",", d, "): ", type[1]));

    length      = solar_length(type);
    width       = solar_width(type);
    height      = solar_height(type);
    bumps       = solar_bumps(type);

    color("MidnightBlue")
    rotate([0,0,-360*bumps[0].x/(PI*d)])
    rotate_extrude(angle=360*length/(PI*d))
    translate([d/2,0,0])   
        square([height,width]);

    //Solder bumps
    intersection() {
        for (bump=bumps) {
            //echo(bump);
            color("silver")

            //rotate([0,0,360*bump.x/(PI*d)])
            translate([d/2,0,bump.y])
            scale([1,4,4])
                sphere(1);

        }
        cylinder(h=width,d=d);
    }
}

module flex_solar_198x100_D75() {
    flex_solar(flex_solar_198x100,75);   
}

if($preview) {    
   *solar(solar_175x175);
   *flex_solar_198x100_D75();
//   solar(solar_100x100);
//   solar(solar_142x88);
}
