//###############################################################################
//# LoRaMeshNodes - MPPT                                                        #
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
//#   A model of a MPPT charger board.                                          #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   October 8, 2025                                                           #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>
//include <../scad/LMN_Config.scad>

use <../lib/NopSCADlib/vitamins/pcb.scad>

SDBK03TA    = [// 0. Type
               "SDBK03TA",
               // 0. Description
               "MPPT Solar Charge Controller",
               // 2. Length
               24.3,
               // 3. Width
               12,
               // 4. Thickness
               1.2,
               // 5. Corner radius
               0, 
               // 6. Mounting hole diameter
               0,
               // 7. Pad around mounting hole
               0,
               // 8. Colour of the substrate
               "White",
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

//Lithium-Ion BMS Module
module SDBK03TA() {
            pcb(SDBK03TA); 
}

if($preview) {    
    *SDBK03TA();
}
