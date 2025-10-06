//###############################################################################
//# LoRaMeshNodes - Conduits                                                    #
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
//#   Plain PVC conduits.                                                       #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   September 20, 2025                                                        #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>

//                                                          o    i
//                                                          u    n
//                                                          t    n
//                                                          e    e
//                                                          r    r
//                                                          D    D
conduit_M20   = ["conduit_M20",  "Conduit diameter 20mm",  20,  17.5];
conduit_M25   = ["conduit_M25",  "Conduit diameter 25mm",  25,  22.3];
conduit_M32   = ["conduit_M32",  "Conduit diameter 32mm",  32,  29.1];
//conduit_M40   = ["conduit_M40",  "Conduit diameter 40mm",  40,  35.5];
conduit_M40   = ["conduit_M40",  "Conduit diameter 40mm",  40,  37.2];

function conduit_type(type)          = type[0]; //! Conduit type
function conduit_outerD(type)        = type[2]; //! Conduit outer diameter
function conduit_innerD(type)        = type[3]; //! Conduit inner diameter

module conduit(type, length) { //! Draw a conduit
  vitamin(str("conduit(", type[0], ", ", length,"): ", type[1], "length ", length, "mm"));

    outerD      = conduit_outerD(type);
    innerD      = conduit_innerD(type);

    color("DarkGray")
    translate([0,0,0])
    difference() {
      translate([0,0,0])   cylinder(h=length,    d=outerD);
      translate([0,0,-10]) cylinder(h=length+20, d=innerD);
    }
}

if($preview) {    
  *conduit(conduit_M40, 80);
}
