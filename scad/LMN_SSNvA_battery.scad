//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant A - Battery                        #
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
//#   October 8, 2025                                                           #
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
batZ       =  62;                                                    //Battery Y position
batNZ      = batZ+batL/2+contact_neg(batCType).x;                    //Negative battery contact X position
batPZ      = batZ-batL/2-contact_pos(batCType).x;                    //Positive battery contact X position
batCW      = max(contact_width(batCType), 10.4);                     //Width of a battery contact
batCH      = max(contact_height(batCType), 9.6);                     //Height of a battery contact
batCT      = max(contact_thickness(batCType),0.8);                   //Thickness of a battery contact
bmsX       =   4;                                                    //BMS X position    
bmsY       =   0;                                                    //BMS Y position
bmsZ       = 110;                                                    //BMS Y position
bmsL       = LiFePo4BMS[2];                                          //BMS length
mpptX      = -6;                                                    //MPPT X position    
mpptY      =   0;                                                    //MPPT Y position
mpptZ      = 110;                                                    //MPPT Y position
mpptL      = SDBK03TA[2];                                            //MPPT length
$fn        = 128;

//Battery holder shape
module SSNvA_battery_frame() {
    difference () {
        //Positive
        union() {

           //Star profile
           translate([0,0,0]) 
           linear_extrude(127) 
               starProfile();
            
           translate([0,0,127])
           rotate([0,0,0]) 
           linear_extrude(2, scale=0.95) 
               starProfile();
  
            //Frame
            translate([0,0,129]) 
                cylinder(h=4, d1=conduit_innerD(conduit_M40)-2,d2=10);
            translate([0,0,0]) 
                cylinder(h=129, d=conduit_innerD(conduit_M40)-2);
             translate([0,0,0]) 
                 cylinder(h=4, d=conduit_innerD(conduit_M40));
             translate([0,0,4]) 
                 cylinder(h=2, d1=conduit_innerD(conduit_M40),d2=conduit_innerD(conduit_M40)-2);            
        }
        //Negative
        union() {
    
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

            //Lower cable mount
            difference() {
                union() {
                    translate([0,-12,6])
                        rounded_cube_yz([30,24,16], r=2);
                     translate([-30,-12,12])
                        rounded_cube_yz([30,24,10], r=2);
                     translate([-30,-12,12])
                        cube([30,24,10]);
                }
                union() {
                    translate([0,0,7])
                    rotate([0,90,90])
                        cylinder(h=60,d=10,center=true);
                    translate([0,0,3])
                        cube([8,60,10],center=true);                    
                }
            }
            //Cable guide
            translate([-14,0,14.4])    
            rotate([0,90,0])
                cylinder(h=30, d=6);
            translate([-14,0,14.4])    
                sphere(d=6);
            //Cable hole
            translate([12,0,-10])
                cylinder(h=20, d=6);
            //Screw holes
            translate([-8,-7,-10])
                cylinder(h=22, r=screw_clearance_radius(M3_pan_screw));
            translate([-8,-7,-10])
                cylinder(h=12, d=screw_boss_diameter(M3_pan_screw));
            translate([-8,7,-10])
                cylinder(h=22, r=screw_clearance_radius(M3_pan_screw));
            translate([-8,7,-10])
                cylinder(h=12, d=screw_boss_diameter(M3_pan_screw));

            //Upper cable mount
            difference() {
                union() {
                    translate([-30,-(mpptL-1)/2,105])
                        rounded_cube_yz([30,mpptL-1,18], r=2);
                    translate([-30,-(mpptL+0.4)/2,mpptZ])
                        cube([30,mpptL+0.4,1.6]);                   
                    translate([0,-(bmsL-1)/2,105])
                        rounded_cube_yz([30,bmsL-1,18], r=2);
                    translate([0,-(bmsL+0.4)/2,bmsZ])
                        cube([30,bmsL+0.4,1.6]);                   
                }
                union() {
                }
            }
            //Cable guide
            hull() {
                translate([-10,0,121]) sphere(d=6);
                translate([10,0,121]) sphere(d=6);
            }
            //Cable hole
            translate([-10,0,114])
                cylinder(h=20, d=6);
            //Screw holes
            translate([3,-7,110])
                cylinder(h=20, r=screw_clearance_radius(M3_pan_screw));
            translate([3,-7,128])
                cylinder(h=14, d=screw_boss_diameter(M3_pan_screw));
            translate([3,7,110])
                cylinder(h=20, r=screw_clearance_radius(M3_pan_screw));
            translate([3,7,128])
                cylinder(h=14, d=screw_boss_diameter(M3_pan_screw));
                  
            //Cable channels
            for (a=[148,158,168]) {
                rotate([0,0,a])
                hull() {
                    translate([(conduit_innerD(conduit_M40)-3)/2,0,20])
                        cylinder(h=100, d=1.6);
                    translate([(conduit_innerD(conduit_M40)-1)/2,0,20])
                        cylinder(h=100, d=1.6);
                 }
            }
            
            //Screw hole
            translate([0,0,7])
            rotate([0,90,90])
                cylinder(h=60,r=screw_clearance_radius(M6_hex_screw),center=true);            
            translate([0,17,7])
            rotate([0,90,90])
                cylinder(h=2,r1=screw_clearance_radius(M6_hex_screw),r2=screw_clearance_radius(M6_hex_screw)+1);
            translate([0,-19,7])
            rotate([0,90,90])
                cylinder(h=2,r1=screw_clearance_radius(M6_hex_screw)+1,r2=screw_clearance_radius(M6_hex_screw));
            
        }
    }   
}
//SSNvA_battery_frame();

module SSNvA_battery_frame_part1_stl() {
    stl("SSNvA_cable_clamp");
    difference() {
        SSNvA_battery_frame();
        translate([0,-50,-50]) cube([100,100,200]);
    }
}
//SSNvA_battery_frame_part1_stl();

module SSNvA_battery_frame_part2_stl() {
    stl("SSNvA_cable_clamp");
    difference() {
        SSNvA_battery_frame();
        translate([-100,-50,-50]) cube([100,100,200]);
    }
}
//SSNvA_battery_frame_part2_stl();

//! Glue the two pieces of the frame together
module SSNvA_battery_frame_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_battery_frame") {

        SSNvA_battery_frame_part1_stl();
        SSNvA_battery_frame_part2_stl();
    }
}
//SSNvA_battery_frame_assembly();

module SSNvA_battery_cable_clamp_stl() {
    stl("SSNvA_cable_clamp");
    difference() {
        //Positive
        union() {
            translate([-4,-11.5,0])
                rounded_cube_xy([8,23,4],r=2);            
        }
        //Negative
        union() {
            translate([0,0,0])
            rotate([0,90,0])
                cylinder(h=60,d=6,center=true);           
            translate([0,-7,2])
            rotate([0,0,30])
                cylinder(h=6,r=nut_radius(M3_washer),$fn=6);
            translate([0,-7,-10])
                cylinder(h=20, r=screw_radius(M3_pan_screw));
            translate([0,7,2])
            rotate([0,0,30])
                cylinder(h=6,r=nut_radius(M3_washer),$fn=6);
            translate([0,7,-10])
                cylinder(h=20, r=screw_radius(M3_pan_screw));
        }        
    }
}
//translate([-8,0,10])
//    SSNvA_battery_cable_clamp_stl();

module SSNvA_battery_screw_handle_stl(screwType=M6_hex_screw) {
    stl("SSNvA_cable_clamp");
    
    nutType = screw_nut(screwType);
    
    difference() {
        //Positive
        union() {
            for (a=[0:60:300]) {
                rotate([0,0,a+30])
                translate([0,0.6*nut_radius(nutType),0])
                    cylinder(h=2+nut_trap_depth(nutType),r=0.6*nut_radius(nutType));
            }
        }
        //Negative
        union() {
            translate([0,0,-10]) {
                cylinder(h=10+nut_trap_depth(nutType),r=nut_radius(nutType),$fn=6);
                cylinder(h=20+nut_trap_depth(nutType),r=screw_clearance_radius(screwType));
            }
        }
    }
}
//SSNvA_battery_screw_handle_stl();

//! Insert two M3 waschers into the cable clamp
module SSNvA_battery_cable_clamp_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_battery_cable_clamp") {

        //Cable clamp
        SSNvA_battery_cable_clamp_stl();

        //Nuts
        translate([0,-7,2])
        rotate([0,0,30])
            nut(M3_nut);
        
        translate([0,7,2])
        rotate([0,0,30])
            nut(M3_nut);
    }
}

//! Solder and assemble components
module SSNvA_battery_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("SSNvA_battery") {
     
        //$explode=1;
        
        //Frame
        SSNvA_battery_frame_assembly();
        
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

        //Loweŕ cable clamp
        translate([-8,0,13])
            SSNvA_battery_cable_clamp_assembly();

        //Lower cable clamp screws
        translate([-8,-7,2])
        rotate([180,0,0])
            screw_and_washer(M3_pan_screw, 18);
        translate([-8,7,2])
        rotate([180,0,0])
            screw_and_washer(M3_pan_screw, 18);

        //BMS
        explode([40,0,0])
        translate([bmsX,bmsY,bmsZ])
        rotate([0,0,90])
            LiFePo4BMS();
            
        //MPPT
        explode([-40,0,0])
        translate([mpptX,mpptY,mpptZ])
        rotate([0,0,90])
            SDBK03TA();
            
        //Uppeŕ cable clamp
        translate([3,0,122])
        rotate([0,180,0])
            SSNvA_battery_cable_clamp_assembly();

        //Upper cable clamp screws
        translate([3,-7,128])
        rotate([0,0,0])
            screw_and_washer(M3_pan_screw, 12);
        translate([3,7,128])
        rotate([0,0,0])
            screw_and_washer(M3_pan_screw, 12);
            
        //Mount screw    
        translate([0,22,7])
        rotate([0,90,90])
            screw(M6_hex_screw, 50);       

        explode([0,40,0])
        translate([0,26,7])
        rotate([90,30,0])
            SSNvA_battery_screw_handle_stl();

        explode([0,-30,0])
        translate([0,-26,7])
        rotate([0,90,90])
            nut(M6_nut);       

        explode([0,-20,0])
        translate([0,-26,7])
        rotate([270,30,0])
            SSNvA_battery_screw_handle_stl();

                    
    }
}
//SSNvA_battery_assembly();

//Drill template
module SSNvA_battery_drill_template_stl(type=conduit_M40) {
    stl("SSNvA_drill_template");
    
    wallT  =  0.4;                     //wall thickness
    poleD  = conduit_outerD(type)+0.4; //pole diameter

    difference() {
        //Positive
        union() {
            cylinder(h=14, d=poleD+wallT);
        }
        //Negative
        union() {
            translate([0,0,-10])
                cylinder(h=34, d=poleD);
            for (a=[90,270]) {
                rotate([0,0,a])
                translate([-.2+poleD/2,0,7])
                rotate([0,90,0])
                    cylinder(h=10, d1=0.2, d2=20);
            }
        }
    }
}
//SSNvA_battery_drill_template_stl();

if($preview) {    
    *SSNvA_battery_assembly();
}
