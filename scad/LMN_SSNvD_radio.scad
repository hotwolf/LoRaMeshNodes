//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant D - Radio                          #
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
//#   A radio (Heltec T114) mount for the Statc Solar Node variant D.           #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   January 17, 2026                                                          #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <LMN_Config.scad>

//Radio enclosure
module SSNvD_radio() {
    difference () {
        //Positive
        union() {
            //Star profile
            difference() {
                union() { 
                    translate([0,0,-2])
                    linear_extrude(2, scale=0.96) 
                        starProfile();
           
                    translate([0,0,-121]) 
                    linear_extrude(119) 
                        starProfile();
                    
                    translate([0,0,-121])
                    rotate([180,0,0]) 
                    linear_extrude(2, scale=0.96) 
                        starProfile();
                }
                union() { 
                    translate([0,0,-20])
                        cylinder(h=30, d=34);
                    translate([0,0,-124])
                        cylinder(h=30, d=34);
               }
            }

            //Upper female thread
            threadPitch   = 4;        
            translate([0,0,-20])
            intersection() {   
                thread(dia     = 31, 
                       pitch   = threadPitch, 
                       length  = 20, 
                       profile = thread_profile(threadPitch / 2.2, threadPitch * 0.25, 60),
                       center  = false, 
                       top     = -1, 
                       bot     = 0, 
                       starts  = 1, 
                       solid   = true, 
                       female  = true);              
                cylinder(h=20, d=34);
            }

            //Lower female thread
            //threadPitch   = 4;        
            translate([0,0,-123])
            intersection() {   
                thread(dia     = 31, 
                       pitch   = threadPitch, 
                       length  = 20, 
                       profile = thread_profile(threadPitch / 2.2, threadPitch * 0.25, 60),
                       center  = false, 
                       top     = 0, 
                       bot     = -1, 
                       starts  = 1, 
                       solid   = true, 
                       female  = true);              
                cylinder(h=20, d=34);
            }

            //Tube
            translate([0,0,-103])
                cylinder(h=83, d=34);
        }
        //Negative
        union() {
           
            //Tube
            difference() {
                union() {
                    translate([0,0,-100])
                        cylinder(h=80, d=30);
                }
                union() {
                    translate([-20,-20,-100])
                        cube([20,40,58]);
                }
            }
            
            //Radio grip holes
            for (m=[0,1]) {
                mirror([m,0,0]) {
                    hull() {
                        translate([10,-20,-100]) cube([40,40,78]);
                        translate([16,-20,-102]) cube([40,40,82]);
                    }
                }
            }
                        
            //Heltec T114
            difference() {
                translate([-8,0,-100])
                rotate([0,270,0])    
                    Heltec_T114_cutout(true);
                translate([-30,-30,-124])
                    cube([60,60,20]);               
            }
                
            translate([-8,-11.5,-100])            
                rounded_cube_yz([26.2,23,51.8],1);
            translate([-20,-10,-100])            
                rounded_cube_yz([16,20,60],1);
                                 
            //Cable hole
            translate([0,-11,-110])            
                //cylinder(h=20, d=6);
                rounded_cube_xy([10,22,20],r=4);

            //Debug          
            *translate([0,-40,-80])
            cube([80,80,80]);            
        }
    }
}
*SSNvD_radio();

module SSNvD_radio_frame_part1_stl() {
    stl("SSNvD_radio_frame_part1");
    
    difference() {
        SSNvD_radio();
        translate([0,-30,-140])
            cube([40,60,200]);
    }   
}
*SSNvD_radio_frame_part1_stl();

module SSNvD_radio_frame_part2_stl() {
    stl("SSNvD_radio_frame_part2");
    
    difference() {
        SSNvD_radio();
        translate([-40,-30,-140])
            cube([40,60,200]);
    }   
}
*SSNvD_radio_frame_part2_stl();

//! 1. Glue the two parts of the radio frame together
module SSNvD_radio_frame_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_radio_frame") {
    
       //$explode = 1;    
       explode([-20,0,0]) SSNvD_radio_frame_part1_stl(); 
       explode([20,0,0])  SSNvD_radio_frame_part2_stl(); 
    }
}
*SSNvD_radio_frame_assembly();


//! 1. Attach the cable clamp with two M3 screws
//! 2. Insert the Heltec T114
//! 3. Attach the power cable
//! 4. Tighten cable clamp
module SSNvD_radio_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_radio") {
    
        //$explode = 1;    
        //Radio frame
        SSNvD_radio_frame_assembly();
    
        //Heltec T114
        translate([-8,0,-100])
        rotate([0,270,0])    
        explode([0,0,-40])
            Heltec_T114();
    }
}
//SSNvD_radio_assembly();

if($preview) {    
   *SSNvD_radio_assembly();
}
