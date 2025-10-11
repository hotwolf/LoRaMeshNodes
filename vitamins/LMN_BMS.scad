//###############################################################################
//# LoRaMeshNodes - BMS                                                         #
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
//#   A model of a BMS battery protection board.                                #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   August 25, 2025                                                           #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <../lib/NopSCADlib/utils/core/core.scad>
//include <../scad/LMN_Config.scad>

use <../lib/NopSCADlib/vitamins/pcb.scad>

LiIonBMS    = [// 0. Type
               "LiIonBMS",
               // 0. Description
               "1S 3.7V battery protection board",
               // 2. Length
               30,
               // 3. Width
               4,
               // 4. Thickness
               1.2,
               // 5. Corner radius
               0, 
               // 6. Mounting hole diameter
               0,
               // 7. Pad around mounting hole
               0,
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

LiFePo4BMS  = [// 0. Type
               "LiFePo4BMS",
               // 0. Description
               "1S 3.2V battery protection board",
               // 2. Length
               30.4,
               // 3. Width
               4,
               // 4. Thickness
               1.2,
               // 5. Corner radius
               0, 
               // 6. Mounting hole diameter
               0,
               // 7. Pad around mounting hole
               0,
               // 8. Colour of the substrate
               "Blue",
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
module LiIonBMS() {
            pcb(LiIonBMS); 
}

//Lithium-Iron-Phosphate BMS Module
module LiFePo4BMS() {
            pcb(LiFePo4BMS); 
}

if($preview) {    
    *LiIonBMS();
    *LiFePo4BMS();
}
