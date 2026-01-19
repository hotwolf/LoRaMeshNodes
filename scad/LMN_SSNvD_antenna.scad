//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant D - Antenna                        #
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
//#   An N-type antenna mount for the Statc Solar Node variant D.               #
//#   It is compatible with the SSNvA antenna mount.                            #
//#                                                                             #
//#     SSNvA: made for Ziisor antennas                                         #
//#     SSNvD: made for Alfa antennas                                           #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   January 17, 2026                                                          #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

include <LMN_Config.scad>

//Antenna enclosure (for Alfa antennas)
module SSNvD_antenna() {
    difference () {
        //Positive
        union() {
           //Star profile
           translate([0,0,2]) 
           linear_extrude(33) 
               starProfile();
            
           translate([0,0,2])
           rotate([180,0,0]) 
           linear_extrude(2, scale=0.96) 
               starProfile();
 
            //Antenna shaft
            translate([0,0,0])   
                cylinder(h=34, d=34);

            difference() {
                union() {
                    intersection() {
                       translate([0,0,32])   
                           cylinder(h=6, d1=50, d2=21);
                       translate([0,0,31])   
                           cylinder(h=8, d=44);        
                    }
                    translate([0,0,30])   
                        cylinder(h=3, d=44);
                }
                union() {
                    translate([0,0,36])   
                       cylinder(h=2,d1=22, d2=23);
                    translate([0,0,28])   
                        cylinder(h=5, d=40.4);
                }
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

            //Antenna grip holes
            for (m=[0,1]) {
                mirror([m,0,0]) {
                    hull() {
                        translate([10,-20,6]) cube([40,40,18]);
                        translate([16,-20,4]) cube([40,40,22]);
                    }
                }
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
*SSNvD_antenna();

//Antenna enclosure STL
module SSNvD_antenna_part1_stl() {
    stl("SSNvD_antenna_part1");
    
    difference() {
        SSNvD_antenna();
        translate([0,-30,-100])
            cube([40,60,200]);
    }
}
*SSNvD_antenna_part1_stl();

module SSNvD_antenna_part2_stl() {
    stl("SSNvD_antenna_part2");
    
    difference() {
        SSNvD_antenna();
        translate([-40,-30,-100])
            cube([40,60,200]);
    }
}
*SSNvD_antenna_part2_stl();

module SSNvD_antenna_top_stl() {
    stl("SSNvD_antenna_top");

    difference() {
        //Positive
        union() {
            translate([0,0,32])   
                cylinder(h=4, d=50);
            translate([0,0,36])   
                cylinder(h=6, d1=50, d2=21);          
        }
        //Negative
        union() {
            translate([0,0,32])   
                cylinder(h=6, d1=50, d2=21);
            translate([0,0,31])   
                cylinder(h=1, d=50);
            translate([0,0,30])   
                cylinder(h=20, d=22);
            translate([0,0,37])   
                cylinder(h=4,d1=23, d2=22);
        }
    }      

}
*SSNvD_antenna_top_stl();

//! 1. Glue the two parts of the antenna frame together
module SSNvD_antenna_frame_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_antenna_frame") {
    
       //$explode = 1;    
       explode([-20,0,0])  SSNvD_antenna_part1_stl(); 
       explode([20,0,0]) SSNvD_antenna_part2_stl(); 

    }
}
*SSNvD_antenna_frame_assembly();

//! 1. Attach the antenna to the frame.  
//! 2. Wrap teflon tape around the bottom of the antenna rod.  
//! 3. Push the top cover over the antenna.  
module SSNvD_antenna_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_antenna") {
    
        //$explode = 1;    
            
        //Antenna frame
        SSNvD_antenna_frame_assembly();
    
        //Antenna  
        explode([0,0,60]) LoRa_N_antenna(wall=6, alfa=true);
    
        //Antenna top cover
        //clip(xmax=0)
        explode([0,0,120]) SSNvD_antenna_top_stl();

    }
}
//SSNvD_antenna_assembly();

if($preview) {    
   *SSNvD_antenna_assembly();
}
