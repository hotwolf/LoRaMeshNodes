//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant A - Radio                          #
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
//#   A radio (Heltec T114) mount for the Statc Solar Node variant A.           #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   October 6, 2025                                                           #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

include <LMN_Config.scad>

//Radio enclosure
module SSNvA_radio() {
    difference () {
        //Positive
        union() {
            //Star profile
            difference() {
                union() { 
                    translate([0,0,-2])
                    linear_extrude(2, scale=0.96) 
                        starProfile();
           
                    translate([0,0,-112]) 
                    linear_extrude(110) 
                        starProfile();
                    
                    translate([0,0,-112])
                    rotate([180,0,0]) 
                    linear_extrude(2, scale=0.96) 
                        starProfile();
                }
                union() { 
                    translate([0,0,-20])
                        cylinder(h=30, d=34);
               }
           }

            //Female thread
            threadPitch   = 4;        
            translate([0,0,-20])
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
            translate([0,0,-114])
                cylinder(h=94, d=34);
        }
        //Negative
        union() {
           
            //Tube
            difference() {
                union() {
                    translate([0,0,-110])
                        cylinder(h=90, d=30);
               }
                union() {
                    translate([-20,-20,-110])
                        cube([20,40,53]);
                                                       
                    translate([0,-20,-53])
                        cube([20,40,10]);

                }
            }
            
            //Radio grip holes
            for (m=[0,1]) {
                mirror([m,0,0]) {
                    hull() {
                        translate([10,-20,-110]) cube([40,40,m?78:53]);
                        translate([16,-20,-112]) cube([40,40,m?82:58]);
                    }
                }
            }
                        
            //Heltec T114
            translate([-8,0,-110])
            rotate([0,270,0])    
                Heltec_T114_cutout(true);
            
            translate([-8,-11.5,-110])            
                rounded_cube_yz([26.2,23,51.8],1);
            translate([-20,-10,-110])            
                rounded_cube_yz([16,20,60],1);
           
            //Cable holder                   
            translate([3,0,-54])
                cylinder(h=12, d=6);
            translate([0,0,-48])
                cube([6,6,12], center=true);            
            translate([-20,6,-48])
            rotate([0,90,0])
                cylinder(h=40, r=screw_radius(M3_pan_screw));
            translate([10,6,-48])
            rotate([0,90,0])
                cylinder(h=10, d=screw_boss_diameter(M3_pan_screw));
            translate([-20,-6,-48])
            rotate([0,90,0])
                cylinder(h=40, r=screw_radius(M3_pan_screw));
            translate([10,-6,-48])
            rotate([0,90,0])
                cylinder(h=10, d=screw_boss_diameter(M3_pan_screw));
                      
            //Cable hole
            translate([10,0,-120])            
                cylinder(h=20, d=6);

            //Debug          
            *translate([0,-40,-80])
            cube([80,80,80]);
            
        }
    }
}
*SSNvA_radio();

//Cable clamp
module SSNvA_cable_clamp_stl() {
    stl("SSNvA_cable_clamp");
    difference () {
        union() {
            translate([-4,-11,-53])
                rounded_cube_yz([4,22,10],1);
            translate([0,-3,-53])
                cube([3,6,10]);
        }
        union() {
            
            translate([-20,6,-48])
            rotate([0,90,0])
                cylinder(h=40, r=screw_radius(M3_pan_screw));
            translate([-12,6,-48])
            rotate([0,90,0])
                cylinder(h=10, r=nut_radius(M3_nut), $fn=6);
            translate([-20,-6,-48])
            rotate([0,90,0])
                cylinder(h=40, r=screw_radius(M3_pan_screw));
            translate([-12,-6,-48])
            rotate([0,90,0])
                cylinder(h=10, r=nut_radius(M3_nut), $fn=6);
            
            translate([4.5,-0,-48])
                cylinder(h=12, d=6, center=true);
        }
    }
}
*SSNvA_cable_clamp_stl();

module SSNvA_radio_frame_part1_stl() {
    stl("SSNvA_radio_frame_part1");
    
    difference() {
        SSNvA_radio();
        translate([0,-30,-140])
            cube([40,60,200]);
    }   
}
*SSNvA_radio_frame_part1_stl();

module SSNvA_radio_frame_part2_stl() {
    stl("SSNvA_radio_frame_part2");
    
    difference() {
        SSNvA_radio();
        translate([-40,-30,-140])
            cube([40,60,200]);
    }   
}
*SSNvA_radio_frame_part2_stl();

//! 1. Glue the two parts of the radio frame together
module SSNvA_radio_frame_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_radio_frame") {
    
       //$explode = 1;    
       explode([-20,0,0]) SSNvA_radio_frame_part1_stl(); 
       explode([20,0,0])  SSNvA_radio_frame_part2_stl(); 
    }
}
*SSNvA_radio_frame_assembly();


//! 1. Attach the cable clamp with two M3 screws
//! 2. Insert the Heltec T114
//! 3. Attach the power cable
//! 4. Tighten cable clamp
module SSNvA_radio_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_radio") {
    
        //$explode = 1;    
        //Radio frame
        SSNvA_radio_frame_assembly();

        //Cable clamp
        SSNvA_cable_clamp_stl();

        translate([10,6,-48])
        rotate([0,90,0])
            screw_and_washer(M3_pan_screw, 16);
        translate([-4,6,-48])
        rotate([0,90,0])
        explode([0,0,-20])
            nut(M3_nut);
        translate([10,-6,-48])
        rotate([0,90,0])
            screw_and_washer(M3_pan_screw, 16);
        translate([-4,-6,-48])
        rotate([0,90,0])
        explode([0,0,-20])
            nut(M3_nut);
    
        //Heltec T114
        translate([-8,0,-110])
        rotate([0,270,0])    
        explode([0,0,-40])
            Heltec_T114();
    }
}
//SSNvA_radio_assembly();

if($preview) {    
   *SSNvA_radio_assembly();
}
