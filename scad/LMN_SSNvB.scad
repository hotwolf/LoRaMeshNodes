//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant B                                  #
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
//#   This is the main assembly of the Statc Solar Node variant B.              #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   November 17, 2025                                                         #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

include <LMN_Config.scad>
//include <LMN_SSNvA_scruton.scad>
//include <LMN_SSNvA_antenna.scad>
include <LMN_SSNvB_antenna.scad>
include <LMN_SSNvB_radio.scad>
include <LMN_SSNvB_battery.scad>
include <LMN_SSNvB_mounts.scad>
//include <LMN_SSNvA_mounts.scad>

solarZ = 0;  //Mounting height of the solar panels
$fn    =128;

//! 1. Attach antenna, radio and battery frame
module SSNvB_core_assembly() {
    //pose([30, 0, 0], [150,150,0])
    assembly("SSNvB_core") {

            translate([0,0,268]) {
            //translate([0,0,224]) {
            //Antenna
            //clip(ymin=0)    
            explode([0,0,80])
                SSNvB_antenna_assembly();
    
            //Radio
            explode([0,0,40])
            translate([0,0,0])
                SSNvB_radio_assembly();
            
            //Battery
            //clip(ymin=0)
                SSNvB_battery_assembly();
        }
    }
}
//$explode = 1;
*SSNvB_core_assembly();

//! 1. Cut the DN75 pipe to the desired length
//! 2. Drill 10mm holes for the solar panel connectors
//! 3. Glue in the antenna holder and the two end cap threads
//! 4. Glue on enclosure mount
module SSNvB_pipe_assembly() {
    //pose([30, 0, 0], [150,150,0])
    assembly("SSNvB_pipe") {
        //$explode = 1;

        //Pipe
        //clip(ymin=0)
        difference() {
            //Positive
            union() {
                conduit(conduit_DN75, 470);
            }
            //Negative
            union() {
               //Cut
               *translate([0,0,250])
               rotate([30,0,0])
                    cube([100,100,20],center=true);

                //Holes
                width = solar_width(flex_solar_198x100);
                bumps = solar_bumps(flex_solar_198x100);
                for (bump=bumps) {                    
                    translate([0,0,bump.y+solarZ])
                    rotate([0,90,0])
                    cylinder(h=60,d=10);
                    translate([0,0,bump.y+solarZ+width])
                    rotate([0,90,0])
                    cylinder(h=60,d=10);
                    translate([0,0,bump.y+solarZ+2*width])
                    rotate([0,90,0])
                    cylinder(h=60,d=10);
                }
            }
        }

        //Upper thread
        explode([0,0,80])
        translate([0,0,470])
        rotate([180,0,0])
        //clip(xmin=0)
            SSNvB_EndcapThread_stl();
        
        //Antenna mount
        explode([0,0,480-261+20])
        translate([0,0,270])
        //clip(xmin=0)
            SSNvB_antennaMountThread_stl();
        
        //Lower thread
        explode([0,0,-40])
        translate([0,0,0])
        //clip(ymin=0)
            SSNvB_EndcapThread_stl();
        
        //Enclosure mount
        translate([0,0,150])
        rotate([0,0,220]) {
            rotate([0,180,0])
            explode([0,40,20])
                SSNvB_encMount_stl();
            explode([0,40,20])
                SSNvB_encMount_stl();
        }
        
        //Cable guides
        *for(z=[145,45]) {
            translate([0,0,z])
                SSNvB_cableGuide_stl();
        }
    }
}
*SSNvB_pipe_assembly();

//! 1. Solder wires onto the solar panels terminals
//! 2. Glue solar panels around the pipe 
module SSNvB_solar_assembly() {
    //pose([30, 0, 0], [150,150,0])
    assembly("SSNvB_solar") {
        //$explode=1;

        //Pipe
        SSNvB_pipe_assembly();

        //Solar panels
        width = solar_width(flex_solar_198x100);
        explode([0,80,0])
        translate([0,0,solarZ])
            flex_solar_198x100_D75();
        explode([0,90,10])
        translate([0,0,solarZ+width])
            flex_solar_198x100_D75();
        explode([0,100,20])
        translate([0,0,solarZ+2*width])
            flex_solar_198x100_D75();
    }
}
*SSNvB_solar_assembly();

//! 1. Slide the antenna and radio into the top end of the pole
//! 2. Screw in antenna fastener
//! 3. Attach the power cable of the antenna to the MPPT controller
//! 4. Attach the end caps
module SSNvB_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvB") {
    //$explode=1;

    //Core
    explode([0,0,500])                                
        SSNvB_core_assembly();

    //Fastener
    explode([0,0,1000])
    translate([0,0,270])
    SSNvB_antennaMountFastener_stl();

    //Solar panel
    explode([0,0,0])                                
        SSNvB_solar_assembly();
        
    //Upper end cap    
    //clip(ymin=0)    
    explode([0,0,1100])
    translate([0,0,470])
        SSNvB_uEndcap_stl();
        
    //Lower end cap
    //clip(ymin=0)    
    explode([0,0,-60])
    translate([0,0,0])
        SSNvB_lEndcap_stl();
        
    }
}
*SSNvB_assembly();

if($preview) {    
   SSNvB_assembly();
}
