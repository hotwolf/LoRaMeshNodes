//###############################################################################
//# LoRaMeshNodes - Extrusions                                                  #
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
//#   September 20, 2025                                                        #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>

//                                                        w  h
//                                                        i  e
//                                                        d  i
//                                                        t  g
//                                                        h  h
//                                                           t
rectext_5x20   = ["rectext_5x20",  "Aluminium profile 5x20mm²",  20, 5];

function rectext_type(type)          = type[0]; //! Profile type
function rectext_width(type)         = type[2]; //! Profile width
function rectext_height(type)        = type[3]; //! Profile heifgt

module rectext(type, length) { //! Draw a rectangular extrusion
  vitamin(str("rectext(", type[0], ", ", length,"): ", type[1], "length ", length, "mm"));

    width      = rectext_width(type);
    height     = rectext_height(type);

    color("silver")
    translate([0,0,0])
    cube([width,height,length]);
}

if($preview) {    
  *rectext(rectext_5x20, 80);
}
