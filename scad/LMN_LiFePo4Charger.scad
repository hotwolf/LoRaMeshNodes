//###############################################################################
//# LoRaMeshNodes - LiFePo4 Battery Charger                                     #
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
//#   December 29, 2025                                                         #
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
batZ       =   0;                                                    //Battery Y position
batNZ      = batZ+batL/2+contact_neg(batCType).x;                    //Negative battery contact X position
batPZ      = batZ-batL/2-contact_pos(batCType).x;                    //Positive battery contact X position
batCW      = max(contact_width(batCType), 10.4);                     //Width of a battery contact
batCH      = max(contact_height(batCType), 9.6);                     //Height of a battery contact
batCT      = max(contact_thickness(batCType),0.8);                   //Thickness of a battery contact
pcbX       =  -3;                                                    //USB charger X position    
pcbY       =   18;                                                    //USB charger Y position
pcbZ       =   34;                                                    //USB charger Y position
pcbL       = USBCharger[2];                                          //USB charger length
$fn        = 128;

//Battery holder shape
module LiFePoCharger_frame() {
    difference () {
        //Positive
        union() {

            //Frame
            translate([0,0,1]) 
                cylinder(h=batNZ-batPZ+14, d=batD+4, center=true);
            translate([-(batD+4)/2,0,1-(batNZ-batPZ+14)/2]) 
                rounded_cube_xy([9+batD/2,8+batD/2,batNZ-batPZ+14],r=1);
            translate([-(batD+4)/2,-(batD+4)/2,1-(batNZ-batPZ+14)/2]) 
                rounded_cube_xy([2+batD/2,2+batD/2,batNZ-batPZ+14],r=1);
            
            //Label
            translate([7,batD/2+4,0])
            rotate([180,0,0])
            rotate([0,90,0]) {
               translate([0,0,0])
                    linear_extrude(1)
                        text("32700 LiFePO4", size=6, halign="center", valign="center");
                
                translate([batNZ,0,0])
                    linear_extrude(1)
                        text("+", size=6, halign="center", valign="center");
                
                translate([batPZ,0,0])
                    linear_extrude(1)
                        text("‒", size=6, halign="center", valign="center");
                
           }
            
        }
        //Negative
        union() {
    
            //Battery compartment
            translate([0,0,batPZ+batCT])
                cylinder(h=batNZ-batPZ-2*batCT, d=batD+0.4, center=false);
            
            translate([0,-(batD+0.4)/2,batPZ+batCT])
                cube([batD+0.4,batD+0.4,batNZ-batPZ-2*batCT]);
            
             translate([-6,-batD-4,batPZ+batCT])
                rounded_cube_xz([batD+0.4,batD+4,batNZ-batPZ-2*batCT],r=2);
    
            //Negative battery contact
            #translate([batX-batCH/2,batY-batCW/2,batNZ-batCT/2])
                cube([batCH, batCW, batCT]);
            #translate([batX-batCH/2,batY-2,batNZ])
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
            #translate([batX-batCH/2,batY-batCW/2,batPZ-batCT/2])
                cube([batCH, batCW, batCT]);
            #translate([batX-batCH/2,batY-2,batPZ-6])
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

            //PCB
            translate([pcbX,pcbY,pcbZ])
            rotate([0,90,90])
                USBCharger_cutout();

            //Cable channels
            hull() {
                translate([-batCH/2,-2,batNZ+2])
                    cube([batCH/2,pcbY+2,4]);
                translate([-14,pcbY-2,batNZ+2])
                    cube([14,6,4]);
            }


            
            translate([-batCH/2,0,batPZ-6])
                cube([batCH/2,pcbY,4]);
            translate([-batCH/2,pcbY,batPZ-6])
                cube([batCH/2,4,batNZ-batPZ+8]);
           
            //Screws
            type=M3_dome_screw;
            for (z=[batNZ+3,batPZ-3]) {
                translate([0,-6,z]) {
                    
                   translate([-50,0,0])
                   rotate([0,90,0]) 
                       cylinder(h=100, r=screw_clearance_radius(type));
                    
                   translate([4,0,0])
                   rotate([0,90,0]) 
                       cylinder(h=20, r=screw_head_radius(type));
                    
                   translate([-25,0,0])
                   rotate([30,0,0]) rotate([0,90,0])
                       cylinder(h=20, r=screw_nut_radius(type), $fn=6);
                }
            }           
        }
    }   
}
*LiFePoCharger_frame();

module LiFePoCharger_frame_part1_stl() {
    stl("LiFePoCharger_frame_part1");
    difference() {
        LiFePoCharger_frame();
        translate([0,-50,-50]) cube([100,100,200]);
    }
}
*LiFePoCharger_frame_part1_stl();

module LiFePoCharger_frame_part2_stl() {
    stl("LiFePoCharger_frame_part2");
    difference() {
        LiFePoCharger_frame();
        translate([-100,-50,-50]) cube([100,100,200]);
    }
}
*LiFePoCharger_frame_part2_stl();

//! Assemble as shown

module LiFePo4Charger_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("LiFePo4Charger") {

        $explode=1;

        //Battery
        explode([60,0,0])
        translate([batX,batY,batZ])
        battery(batType);

        //Battery contacts
        translate([batX,batY,batNZ])
        rotate([0,180,90])
            battery_contact(batCType, false);
        translate([batX,batY,batPZ])
        rotate([0,0,90])
            battery_contact(batCType, true);

        //USB Charger
        explode([-20,0,0])
        translate([pcbX,pcbY,pcbZ])
        rotate([0,90,90])
            USBCharger();
            
        //Screws
        type=M3_dome_screw;
        for (z=[batNZ+3,batPZ-3]) {
            translate([0,-6,z]) {
                
               explode([60,0,0])
               translate([4,0,0])
               rotate([0,90,0]) 
                   screw(type, 20);
                
               explode([-60,0,0])
               translate([-5.4,0,0])
               rotate([30,0,0]) rotate([0,90,0])
                   nut(screw_nut(type));
            }
        }           
            
        //Frame
        explode([-40,0,0])LiFePoCharger_frame_part1_stl();
        explode([ 20,0,0])LiFePoCharger_frame_part2_stl();
    }
}

if($preview) {    
   LiFePo4Charger_assembly();
}
