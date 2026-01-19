//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant D                                  #
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
//#   This is the main assembly of the Statc Solar Node variant D.              #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   January 17, 2026                                                          #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

include <LMN_Config.scad>
include <LMN_SSNvD_antenna.scad>
include <LMN_SSNvD_radio.scad>
include <LMN_SSNvD_battery.scad>
include <LMN_SSNvD_mounts.scad>

//! 1. Cut the M40 counduit to the desired length (mun. 30cm)
//! 2. Glue the end cap ring into the bottom of the conduit 
module SSNvD_pole_assembly() {
    //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_pole") {

        //$explode = 1;

        //Conduit
        explode([0,0,0])  
        translate([0,0,-300])
            conduit(conduit_M40, 300);

        //End cap ring
        explode([0,0,-20])  
        translate([0,0,-300])
        SSNvD_end_cap_ring_stl(); 
    }
}
*SSNvD_pole_assembly();

// 1. Screw the antenna and the radio frame together
// 2. Plug the antenna cord onto the Heltec T114
module SSNvD_top_assembly() {
    //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_top") {
        //$explode = 1;
    
        //Antenna
        explode([0,0,40])                                
        translate([0,0,-32])
            SSNvD_antenna_assembly();
    
        //Radio
        explode([0,0,0])                                
        translate([0,0,-32])
        SSNvD_radio_assembly();
        
        //Battery
        explode([0,0,-40])                                
        translate([0,0,-40])
        SSNvD_battery_assembly();
        
    }
}
*SSNvD_top_assembly();

//! 1. Slide the antenna and radio into the top end of the pole
//! 2. Attach the power cable of the antenna to the battery assembly
//! 3. Slide the battery assembly into the bottom end of the pole
//! 4. Attach the solar panel to the MPPT controller
//! 5. Attach the panel to the panel mount
//! 6. Attach the panel mount to the pole with zipties
module SSNvD_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD") {

    $explode=1;

    //Conduit
    SSNvD_pole_assembly();    
            
    //Antenna, radio, and battery
    explode([0,0,310])                                
    SSNvD_top_assembly();

    //Solar panel
    explode([80,0,0])                                
    translate([0,0,-150])
        SSNvD_solar_mount_assembly();
    
    //End cap
    explode([0,0,-20])                                
    translate([0,0,-300])
        SSNvD_end_cap_stl();
            
    //Spacers 
    explode([-80,0,0])
    translate([0,0,-260])
        SSNvD_spacer_assembly();
        
    explode([-80,0,0])
    translate([0,0,-40])
        SSNvD_spacer_assembly();
    }
}

if($preview) {    
   SSNvD_assembly();
}
