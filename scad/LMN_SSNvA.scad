//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant A                                  #
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
//#   This is the main assembly of the Statc Solar Node variant A.              #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   July 18, 2025                                                             #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

include <LMN_Config.scad>
include <LMN_SSNvA_scruton.scad>
include <LMN_SSNvA_antenna.scad>
include <LMN_SSNvA_radio.scad>
include <LMN_SSNvA_battery.scad>
include <LMN_SSNvA_mounts.scad>

//! 1. Cut the M40 counduit to the desired length
//! 2. Drill a 6mm hole through the pole, approx. 10mm above the bottom end
//! 3. Slide helix segments over the pole

module SSNvA_pole_assembly() {
    //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_pole") {
        //$explode = 1;

        //Conduit
        difference() {
            //Positive
            union() {
                translate([0,0,-200])
                    conduit(conduit_M40, 2000);
            }
            //Negative
            union() {
                translate([-40,-40,200])
                    cube([80,80,2000]);
                rotate([30,0,0])
                    cube([100,100,20],center=true);
                translate([0,0,-190])
                rotate([90,0,0])
                    cylinder(h=60,d=6,center=true);
                
            }
        }
        
        //Scruton helix
        difference() {
            //Positive
            union() {
               explode([0,0,400])                                
               translate([0,0,40])                
                     SSNvA_scrutonM40_stl();              
                explode([0,0,350])                                
                translate([0,0,-120])                
                     SSNvA_scrutonM40_stl();                             
            }
            //Negative
            union() {
                rotate([30,0,0])
                    cube([100,100,20],center=true);
            }
        }
    }
}
//SSNvA_pole_assembly();

// 1. Screw the antenna and the radio frame together
// 2. Plug the antenna cord onto the Heltec T114
module SSNvA_top_assembly() {
    //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_top") {
        //$explode = 1;
    
        //Antenna
        explode([0,0,40])                                
        translate([0,0,140])
            SSNvA_antenna_assembly();
    
        //Radio
        explode([0,0,-40])                                
        translate([0,0,140])
        SSNvA_radio_assembly();
    }
}
//SSNvA_top_assembly();

//! 1. Slide the antenna and radio into the top end of the pole
//! 2. Attach the power cable of the antenna to the battery assembly
//! 3. Slide the battery assembly into the bottom end of the pole
//! 4. Attach the solar panel to the MPPT controller
//! 5. Attach the panel to the panel mount
//! 6. Attach the panel mount to the pole with zipties
module SSNvA_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA") {

    $explode=1;

    //Conduit
    SSNvA_pole_assembly();   
            
    //Radio and antenna
    explode([0,0,200])                                
    SSNvA_top_assembly();

    //Battery
    explode([0,0,-160])                                
    translate([0,0,-200])
        SSNvA_battery_assembly();

    //Solar panel
    explode([0,80,0])                                
    translate([0,0,-150])
        SSNvA_solar_mount_assembly();
    }
}

if($preview) {    
   SSNvA_assembly();
}
