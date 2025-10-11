//###############################################################################
//# LoRaMeshNodes - Configuration                                               #
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
//#   Common configuration                                                      #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   July 18, 2025                                                             #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
//include <./target.scad>
include <../lib/NopSCADlib/lib.scad>
include <../lib/NopSCADlib/vitamins/antenna.scad>
include <../lib/NopSCADlib/vitamins/batteries.scad>
include <../lib/NopSCADlib/vitamins/screws.scad>
include <../lib/NopSCADlib/vitamins/nuts.scad>
include <../lib/NopSCADlib/vitamins/zipties.scad>
include <../lib/NopSCADlib/utils/thread.scad>

include <../vitamins/LMN_Heltec_T114.scad>
include <../vitamins/LMN_lipo.scad>
include <../vitamins/LMN_solar.scad>
include <../vitamins/LMN_antenna.scad>
include <../vitamins/LMN_BMS.scad>
include <../vitamins/LMN_MPPT.scad>
include <../vitamins/LMN_conduits.scad>
include <../vitamins/LMN_extrusions.scad>

use     <./LMN_Common.scad>

//Common parameters
solarA = 35;   //Solar panel tilt angle
wallT  =  3;   //Wall thickness of the enclosure
gapW   =  0.2; //Gap between moving parts
edgeR  =  1;   //Rounded edges
