//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant B - Battery                        #
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
module SSNvB_battery_frame() {
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

            //Frame
            //translate([0,0,-130]) 
            translate([0,0,-166]) 
                cylinder(h=146, d=36);
                     
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
                    translate([17.4,0,-120])
                        cylinder(h=90, d=2);
                    translate([20,0,-120])
                        cylinder(h=90, d=2);
                 }
            }

            //Dome
            translate([0,0,-164])
                sphere(d=32);
            translate([0,0,-170])
                cylinder(h=6,d=32);

            //Cable clamp
            difference() {
                translate([-40,-15,-146])
                    rounded_cube_yz([80,30,30], r=2);
                difference() {
                    translate([0,-15,-130])
                        cube([3,30,10]);
                    union() {
                        translate([-10,-10,-125])
                        rotate([0,90,0])
                            cylinder(h=20, r=screw_clearance_radius(M3_pan_screw));
                        translate([-10,10,-125])
                        rotate([0,90,0])
                            cylinder(h=20, r=screw_clearance_radius(M3_pan_screw));
                        translate([3,-2,-125])
                        rotate([0,0,0])
                            cylinder(h=40, d=1.2, center=true);
                        translate([3,2,-125])
                        rotate([0,0,0])
                            cylinder(h=40, d=1.2, center=true);
                     }
                }
            }
        }
    }   
}
*SSNvB_battery_frame();

module SSNvB_battery_frame_part1_stl() {
    stl("SSNvB_battery_frame_part1");
    difference() {
        SSNvB_battery_frame();
        translate([0,-50,-150]) cube([100,100,200]);
    }
}
*SSNvB_battery_frame_part1_stl();

module SSNvB_battery_frame_part2_stl() {
    stl("SSNvB_battery_frame_part2");
    difference() {
        SSNvB_battery_frame();
        translate([-100,-50,-150]) cube([100,100,200]);
    }
}
*SSNvB_battery_frame_part2_stl();

//! Glue the two pieces of the frame together
module SSNvB_battery_frame_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvB_battery_frame") {

        SSNvB_battery_frame_part1_stl();
        SSNvB_battery_frame_part2_stl();
    }
}
//SSNvB_battery_frame_assembly();

module SSNvB_battery_cable_clamp_stl() {
    stl("SSNvB_battery_cable_clamp");
    difference() {
        //Positive
        union() {
            translate([1,0,0])
                cube([2,29.6,10],center=true);
             translate([0,-14.8,-5])
                rounded_cube_xz([5,29.6,10],r=2);
        }
        //Negative
        union() {
            translate([2,-10,0])
            rotate([0,90,0])
                cylinder(h=6,r=nut_radius(M3_washer),$fn=6);
            translate([-10,-10,0])
            rotate([0,90,0])
                cylinder(h=20, r=screw_radius(M3_pan_screw));
            translate([2,10,0])
            rotate([0,90,0])
                cylinder(h=6,r=nut_radius(M3_washer),$fn=6);
            translate([-10,10,0])
            rotate([0,90,0])
                cylinder(h=20, r=screw_radius(M3_pan_screw));
            translate([0,2,-10])
                cylinder(h=40, d=1.2, center=true);
            translate([0,-2,-10])
                cylinder(h=40, d=1.2, center=true);
        }        
    }
}
//translate([0,0,-160]) 
*SSNvB_battery_cable_clamp_stl();

//! Insert two M3 waschers into the cable clamp
module SSNvB_battery_cable_clamp_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvB_battery_cable_clamp") {
      
        //$explode=1;

        //Cable clamp
        SSNvB_battery_cable_clamp_stl();

        //Nuts
        explode([10,0,0])
        rotate([0,90,0])
        translate([0,-10,2])
            nut(M3_nut);
        
        explode([10,0,0])
        rotate([0,90,0])
        translate([0,10,2])
            nut(M3_nut);
    }
}
//translate([0,0,-126]) 
*SSNvB_battery_cable_clamp_assembly();

//! Solder and assemble components
module SSNvB_battery_assembly() {
  //pose([30, 0, 0], [150,150,0])
    translate([0,0,-103])
    assembly("SSNvB_battery") {
     
        $explode=1;
        
        //Frame
        //clip(ymin=0)
        SSNvB_battery_frame_assembly();
        
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
        explode([20,0,0])
        translate([0,0,-125])
            SSNvB_battery_cable_clamp_assembly();

        //Cable clamp screws
        translate([0,-10,-125])
        rotate([0,270,0])
            screw_and_washer(M3_pan_screw, 10);
        translate([0,10,-125])
        rotate([0,270,0])
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
*SSNvB_battery_assembly();

if($preview) {    
    *SSNvB_battery_assembly();
}
