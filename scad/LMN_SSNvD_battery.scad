//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant D - Battery                        #
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
//#   A holder for a 32700 LiFePo4 battery with MPPT charger.                   #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   January 17, 2026                                                          #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

include <LMN_Config.scad>

//Parameters
batType    = LI32700;                                                //Battery type
batCType   = battery_contact(batType);                               //Battery contact type
batL       = battery_length(batType);                                //Battery length
batD       = battery_diameter(batType);                              //Battery diameter
batX       =   0;                                                    //Battery X position    
batY       =   0;                                                    //Battery Y position
batZ       =  -76;                                                   //Battery Y position
batNZ      = batZ+batL/2+contact_neg(batCType).x;                    //Negative battery contact X position
batPZ      = batZ-batL/2-contact_pos(batCType).x;                    //Positive battery contact X position
batCW      = max(contact_width(batCType), 10.4);                     //Width of a battery contact
batCH      = max(contact_height(batCType), 9.6);                     //Height of a battery contact
batCT      = max(contact_thickness(batCType),0.8);                   //Thickness of a battery contact
bmsX       =   0;                                                    //BMS X position    
bmsY       =   0;                                                    //BMS Y position
bmsZ       = -30;                                                    //BMS Y position
bmsL       = LiFePo4BMS[2];                                          //BMS length
mpptX      =   0;                                                    //MPPT X position    
mpptY      =   0.5;                                                  //MPPT Y position
mpptZ      = -12;                                                    //MPPT Y position
mpptL      = SDBK03TA[2];                                            //MPPT length
$fn        = 128;

//Battery holder shape
module SSNvD_battery_frame() {
    difference () {
        //Positive
        union() {

            //Male thread
            threadPitch   = 4;        
            translate([0,0,-20])   
            thread(dia     = 26, 
                   pitch   = threadPitch, 
                   length  = 20, 
                   profile = thread_profile(threadPitch / 2.2, threadPitch * 0.25, 60),
                   center  = false, 
                   top     = -1, 
                   bot     = 0, 
                   starts  = 1, 
                   solid   = true, 
                   female  = false);              
            
           //Star profile
           translate([0,0,-114]) 
           linear_extrude(92) 
               starProfile();
            
           translate([0,0,-22])
           rotate([0,0,0]) 
           linear_extrude(2, scale=0.95) 
               starProfile();
  
           translate([0,0,-114])
           rotate([180,0,0]) 
           linear_extrude(2, scale=0.96) 
               starProfile();
               
            //Frame
            translate([0,0,-130]) 
                cylinder(h=110, d=34);
                     
        }
        //Negative
        union() {
 
            //Thread
            intersection() {
                translate([0,0,-30])                   
                    cylinder(h=42, d=23.4);
                translate([-11,-20,-40])                   
                    cube([22,40,42]);
            }
                     
            //Battery compartment
            translate([0,0,batPZ+batCT])
                cylinder(h=batNZ-batPZ-2*batCT, d=batD+0.4, center=false);            
            translate([0,-(batD+0.4)/2,batPZ+batCT])
                cube([batD+0.4,batD+0.4,batNZ-batPZ-2*batCT]);
            
            //Negative battery contact
            translate([batX-batCH/2,batY-batCW/2,batNZ-batCT/2])
                cube([batCH, batCW, batCT]);
            translate([batX-batCH/2,batY-2,batNZ])
                cube([batCH, 4, 6]);
            translate([batX-batCH/2,batY-4,batNZ-6])
                cube([batCH, 8, 6]);
            translate([batX,batY-batCW/2,batNZ-batCT/2])
            scale([1,1,0.5])
            difference() {
                rotate([270,0,0])
                    cylinder(h=batCW, d=2);
                translate([-10,-10,0])
                    cube([20,20,20]);
            }
            
            //Positive battery contact
            translate([batX-batCH/2,batY-batCW/2,batPZ-batCT/2])
                cube([batCH, batCW, batCT]);
            translate([batX-batCH/2,batY-2,batPZ-6])
                cube([batCH, 4, 6]);
            translate([batX-batCH/2,batY-4,batPZ])
                cube([batCH, 8, 6]);
            translate([batX,batY-batCW/2,batPZ+batCT/2])
            scale([1,1,0.5])
            difference() {
                rotate([270,0,0])
                    cylinder(h=batCW, d=2);
                translate([-10,-10,-20])
                    cube([20,20,20]);
            }

            //Upper cable mount
            translate([mpptX-(mpptL+0.4)/2,-1,-18])
                cube([mpptL+0.4,2,40]);                   
            translate([-40,-(bmsL-1)/2,-34])
                rounded_cube_yz([80,bmsL-1,10], r=2);
            translate([-40,-(bmsL+0.4)/2,bmsZ])
                cube([80,bmsL+0.4,1.8]);                   

            //Cable channels
            for (a=[148,158,168]) {
                rotate([0,0,a])
                hull() {
                    translate([(conduit_innerD(conduit_M40)-3)/2,0,-120])
                        cylinder(h=90, d=1.6);
                    translate([(conduit_innerD(conduit_M40)-1)/2,0,-120])
                        cylinder(h=90, d=1.6);
                 }
            }

            //Cable clamp
            translate([0,-20,-156])
                rounded_cube_xz([40,40,40],r=4);

            translate([-40,-15,-126])
                rounded_cube_yz([80,30,10], r=2);

            translate([-6,9,-134])
                cylinder(h=20, r=screw_clearance_radius(M3_pan_screw));
            translate([-6,9,-142])
                cylinder(h=14, d=screw_boss_diameter(M3_pan_screw));

            translate([-6,-9,-134])
                cylinder(h=20, r=screw_clearance_radius(M3_pan_screw));
            translate([-6,-9,-142])
                cylinder(h=14, d=screw_boss_diameter(M3_pan_screw));

            translate([0,0,-126])
            rotate([0,90,158]) {
                translate([0,0,0])  cylinder(h=40, d=1.2, center=true);
                translate([0,3,0])  cylinder(h=40, d=1.2, center=true);
                translate([0,-3,0]) cylinder(h=40, d=1.2, center=true);
            }
        }
    }   
}
*SSNvD_battery_frame();

module SSNvD_battery_frame_part1_stl() {
    stl("SSNvD_battery_frame_part1");
    difference() {
        SSNvD_battery_frame();
        translate([0,-50,-150]) cube([100,100,200]);
    }
}
*SSNvD_battery_frame_part1_stl();

module SSNvD_battery_frame_part2_stl() {
    stl("SSNvD_battery_frame_part2");
    difference() {
        SSNvD_battery_frame();
        translate([-100,-50,-150]) cube([100,100,200]);
    }
}
*SSNvD_battery_frame_part2_stl();

//! Glue the two pieces of the frame together
module SSNvD_battery_frame_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_battery_frame") {

        SSNvD_battery_frame_part1_stl();
        SSNvD_battery_frame_part2_stl();
    }
}
//SSNvD_battery_frame_assembly();

module SSNvD_battery_cable_clamp_stl() {
    stl("SSNvD_battery_cable_clamp");
    difference() {
        //Positive
        union() {
            intersection() {
                translate([-40,-14.9,0])
                    rounded_cube_yz([40,29.8,5], r=2);
                translate([0,0,-10])
                    cylinder(h=30, d=32);
            }       
        }
        //Negative
        union() {
            translate([-6,-9,2])
                cylinder(h=6,r=nut_radius(M3_washer),$fn=6);
            translate([-6,-9,-10])
                cylinder(h=20, r=screw_radius(M3_pan_screw));
            translate([-6,9,2])
                cylinder(h=6,r=nut_radius(M3_washer),$fn=6);
            translate([-6,9,-10])
                cylinder(h=20, r=screw_radius(M3_pan_screw));
            
             translate([0,0,0])
            rotate([0,90,158]) {
                translate([0,0,0])  cylinder(h=40, d=1.2, center=true);
                translate([0,3,0])  cylinder(h=40, d=1.2, center=true);
                translate([0,-3,0]) cylinder(h=40, d=1.2, center=true);
            }
        }        
    }
}
translate([0,0,-160]) SSNvD_battery_cable_clamp_stl();

//! Insert two M3 waschers into the cable clamp
module SSNvD_battery_cable_clamp_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvD_battery_cable_clamp") {
      
        //$explode=1;

        //Cable clamp
        SSNvD_battery_cable_clamp_stl();

        //Nuts
        explode([0,0,10])
        translate([-6,-9,2])
            nut(M3_nut);
        
        explode([0,0,10])
        translate([-6,9,2])
            nut(M3_nut);
    }
}
*translate([0,0,-126]) SSNvD_battery_cable_clamp_assembly();

//! Solder and assemble components
module SSNvD_battery_assembly() {
  //pose([30, 0, 0], [150,150,0])
    translate([0,0,-95])
    assembly("SSNvD_battery") {
     
        //$explode=1;
        
        //Frame
        SSNvD_battery_frame_assembly();
        
        //Battery
        explode([40,0,0])
        translate([batX,batY,batZ])
        battery(batType);
    
        //Battery contacts
        translate([batX,batY,batNZ])
        rotate([0,180,90])
            battery_contact(batCType, false);
        translate([batX,batY,batPZ])
        rotate([0,0,90])
            battery_contact(batCType, true);

        //Cable clamp
        explode([-20,0,0])
        translate([0,0,-125])
            SSNvD_battery_cable_clamp_assembly();

        //Cable clamp screws
        translate([-6,-9,-128])
        rotate([180,0,0])
            screw_and_washer(M3_pan_screw, 10);
        translate([-6,9,-128])
        rotate([180,0,0])
            screw_and_washer(M3_pan_screw, 10);

        //BMS
        explode([20,0,0])
        translate([bmsX,bmsY,bmsZ])
        rotate([0,0,90])
            LiFePo4BMS();
            
        //MPPT
        explode([0,0,20])
        translate([mpptX,mpptY,mpptZ])
        rotate([90,0,0])
            SDBK03TA();
                    
    }
}
*SSNvD_battery_assembly();

if($preview) {    
    *SSNvD_battery_assembly();
}
