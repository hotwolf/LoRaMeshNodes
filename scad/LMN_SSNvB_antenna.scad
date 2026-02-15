//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant B - Antenna                        #
//###############################################################################
//#    Copyright 2026 Dirk Heisswolf                                            #
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
//#   An N-type antenna mount for the Statc Solar Node variant D.               #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   January 17, 2026                                                          #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

include <LMN_Config.scad>
use     <LMN_SSNvB_mounts.scad>

condT  = conduit_DN75;           //Conduit type
outerD = conduit_outerD(condT);  //Outer diameter of the conduit
innerD = conduit_innerD(condT);  //Inner diameter of the conduit
$fn    =128;

//Antenna enclosure (for Alfa antennas)
module SSNvB_antenna_stl() {
    stl("SSNvB_antenna");
    difference () {
        //Positive
        union() {
            //Antenna shaft
            translate([0,0,0])   
                cylinder(h=6, d=36);
            difference() {
                intersection() {
                    translate([0,0,1])   
                        zigzagDisk(flip=true);
                    translate([0,0,-5])   
                        cylinder(h=20, d=innerD-17);                    
                }
                translate([0,0,0])   
                    cylinder(h=7, d=34);
            }
                              
            //Male thread
            threadPitch   = 4;        
            translate([0,0,-20])   
            thread(dia     = 26, 
                   pitch   = threadPitch, 
                   length  = 20, 
                   profile = thread_profile(threadPitch / 2.2, threadPitch * 0.25, 60),
                   center  = false, 
                   top     = 0, 
                   bot     = -1, 
                   starts  = 1, 
                   solid   = true, 
                   female  = false);              
            
        }
        //Negative
        union() {
            //Antenna shaft
            translate([0,0,6])   
                cylinder(h=100, d=22.4);
            
            //Antenna mount
            intersection() {
                translate([0,0,-2]) color("Silver") cylinder(h=22, d=15.8);
                cube([30,13.5,60], center=true);
            }
     
            //Thread
            rotate([180,0,0])   
                cylinder(h=40, d=23.4);
    
            //Debug
            *translate([0,-40,-80])
            cube([80,80,80]);
                     
        }
    }
}
*SSNvB_antenna_stl();

//! 1. Attach the antenna to the frame.  
module SSNvB_antenna_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvB_antenna") {
    
        //$explode = 1;    
            
        //Antenna frame
        SSNvB_antenna_stl();
    
        //Antenna  
        explode([0,0,60]) LoRa_N_antenna(wall=6, alfa=true);
        //explode([0,0,60]) LoRa_N_antenna(wall=6, alfa=false);
    
    }
}
//SSNvB_antenna_assembly();

if($preview) {    
   *SSNvB_antenna_assembly();
}
