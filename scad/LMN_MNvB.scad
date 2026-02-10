//###############################################################################
//# LoRaMeshNodes - Mobile Node Variant B                                       #
//###############################################################################
//#    Copyright 2025 -2026 Dirk Heisswolf                                      #
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
//#    GNU General Public License for more detals.                              #
//#                                                                             #
//#    You should have received a copy of the GNU General Public License        #
//#    along with this project.  If not, see <http://www.gnu.org/licenses/>.    #
//#                                                                             #
//#    This project makes use of the NopSCADlib library                         #
//#    (see https://github.com/nophead/NopSCADlib).                             #
//#                                                                             #
//###############################################################################
//# Description:                                                                #
//#   This file contains modules, which are specifiv for the Mobile Node        #
//#   variant B.                                                                #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   January 26, 2026                                                          #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

//! These are the assembly instructions for the Mobile Node (Variant A) (MNvA),
//! a portable [Meshtastic](https://meshtastic.org) or
//! [MeshCore](https://meshcore.co.uk) node.

include <LMN_Config.scad>

//Parameters
batT      = S25R18650;               //Battery type
batD      = battery_diameter(batT);  //Battery diameter
batL      = battery_length(batT);    //Battery length
batX      =  batL/2+wallT+0.0;        //Battery X position (from center)
batY      =  batD/2+3;               //Battery Y position
batZ      =  batD/2+2;               //Battery Z position
bmsX      =   batX;                  //BMS X position
bmsY      = batD+wallT+1;            //BMS Y position
bmsZ      =  batZ;                   //BMS Z position
encC      = wallT;                   //Enclosure chamfer
encX      = batL+2*wallT+1+8;        //Enclosure X dimension
encY      =  60+2*encC;              //Enclosure Y dimension
encZ      =  11+2*encC;              //Enclosure Z dimension
encR      =  5;                      //Enclosure corner radius
lEncZ     =  wallT+10;               //Lower enclosure Z dimension
pcbY      =  38;                     //PCB Y position
antX      =   5.5+encC;              //Ant X position
antY      =  32;                     //Ant Y position
antZ      = encZ/2;                  //Ant Z position
screwT    = M3_dome_screw;           //Screw type
nutT      = screw_nut(screwT);       //Nut type
screwPos  = [[19,50],
             [encX-wallT-4,wallT+4]];
             //[encX-encR,encY-13.6],
             //[84,22]];
            
micro = 0.001;
inf   = 100;

//Enclosure shape
module enclosure(fix=0) {
    //Antenna
    antOffs = 28.0;
 
    difference() {
        //Positive       
        union() {

            //Enclosure shape
            difference() {
                union() {
                    hull() {
                        translate([encC,encC,0])
                            rounded_cube_xy([encX-2*encC,encY-2*encC,encZ],r=encR-encC);
                        translate([0,0,encC])
                            rounded_cube_xy([encX,encY,encZ-2*encC],r=encR);
                        *translate([encC,encC,0])
                            rounded_cube_xy([encX-2*encC,batY-encC,batD+2*encC-2],r=encR-encC);
                        *translate([0,0,encC])
                            rounded_cube_xy([encX,batY,batD-2],r=encR);
                        *translate([encC,batY,batY])
                        rotate([0,90,0])
                            cylinder(h=encX-2*encC, d=batD+4);
                        
                        *translate([0,batY,batY])
                        rotate([0,90,0])
                            cylinder(h=encX, d=batD+4-2*encC);
                    }

                    hull() {
 
                        clip(ymax=batY) {
                            translate([encC,encC,0])
                                rounded_cube_xy([encX-2*encC,encY-2*encC,batD+2*encC-1],r=encR-encC);
                            translate([0,0,encC])
                                rounded_cube_xy([encX,encY,batD-1],r=encR);
                        }

                    }
                                            
                    intersection() {                   
                        hull() {
                            translate([encC,batY,batY])
                            rotate([0,90,0])
                                cylinder(h=encX-2*encC, d=batD+4);
                
                            translate([0,batY,batY])
                            rotate([0,90,0])
                                cylinder(h=encX, d=batD+4-2*encC);
                        }
                        hull() {
                            translate([encC,encC,0])
                                rounded_cube_xy([encX-2*encC,30-encC,batD+2*encC],r=encR-encC);
                            translate([0,0,encC])
                                rounded_cube_xy([encX,30,batD],r=encR);
                        }
                    }                            
                }
            }
        }
        //Negative
        union() {
            //Antenna
            antOffs = 28.0;

            translate([antX,antY+antOffs,antZ])
            rotate([90,0,0])
                cylinder(h=antOffs,d=13.4);
            
            translate([antX,antY,antZ])
            rotate([90,0,0])
                cylinder(h=10,d=6.8);
            
            translate([wallT-0.5,antY-10-9,wallT]) 
                cube([12,15,12.3]);
           
            translate([wallT-0.5,antY-4-9,wallT+4]) 
                cube([16,9,6+fix]);
             
            hull() {
                translate([antX,antY+antOffs,antZ])
                rotate([0,0,180])
                rotate([0,90,0])
                    cylinder(h=wallT+13.4/2,d=13.4);
    
                translate([antX,antY+antOffs,antZ-13.4/2])     
                rotate([0,0,180])
                rotate_extrude(angle=90) square([8,13.4]);
            }
            
            translate([antX,antY+antOffs,antZ-13.4/2])    
            rotate([0,0,0])
            rotate_extrude(angle=90) square([13-4/2,13.4]);
           
            translate([antX,antY+antOffs,antZ-13.4/2])     
            cylinder(h=13.4, r=13.4/2);
               
            translate([antX-10,antY+antOffs,antZ])
            rotate([0,90,0])
                cylinder(h=100,d=13.4+micro);         
            *translate([antX-10,antY+antOffs,antZ])
            rotate([0,90,0])
            rotate_extrude() {
                square([13.4/2,100]);        
            }
            
            translate([antX-10,antY+antOffs+10,antZ])
            rotate([0,90,0])
                cylinder(h=100,d=13.4);
             translate([antX-10,antY+antOffs,antZ-13.4/2])
                cube([100,10,13.4]);

            //PCB
            translate([encX-wallT,pcbY,wallT])
            rotate([0,180,0])
                Heltec_T114_cutout();
            
            hull() {
                translate([encX-wallT-0.6,pcbY+22.86/2,wallT])
                rotate([0,0,180])
                //rounded_cube_xy([51.80,22.86,encZ-2*wallT-2],r=1);       
                rounded_cube_xy([51.80,22.86,7],r=1);       
    
                translate([encX-wallT-2,pcbY+22.86/2,wallT])
                rotate([0,0,180])
                rounded_cube_xy([49.80,22.86,10],r=1);       
            }
            translate([encX-2*encR-47,pcbY-22.86/2,wallT+3])
                cube([53,batY+40-pcbY+22.86/2,7+fix]);
            
            translate([encX-64,pcbY-7,wallT])
                cube([16,14,10+fix]);
            translate([encX-64,pcbY-14,wallT+4])
                cube([8,18,6+fix]);

            //Battery
            translate([batX,batY,batZ])
            rotate([0,90,0])
                cylinder(h=66,d=19,center=true);
            translate([batX,batY+19/2,batZ])
                cube([66,10,8.3],center=true);
            
            //Screws
            for (pos=screwPos) {
                translate([pos.x,pos.y,encZ-wallT-8])
                rotate([0,0,30])
                    cylinder(h=nut_thickness(nutT)+0.2, r=nut_radius(nutT)+0.1, $fn=6);
                translate([pos.x,pos.y,wallT])
                     cylinder(h=40, r=screw_clearance_radius(screwT)+0.4);
                *translate([pos.x,pos.y,encZ-wallT-2.2]) 
                    cylinder(h=2, r1=screw_clearance_radius(screwT)+1, r2=screw_head_radius(screwT)+1); 
                translate([pos.x,pos.y,encZ-wallT-0.2]) 
                    cylinder(h=20, r=screw_head_radius(screwT)+1);
            }
            
        }
    }
}
*enclosure();

//Enclosure split
module split(gap=0) {

    difference() {
        //Top
        union() {
            hull() {
                translate([gap,gap,lEncZ+wallT/3])
                    rounded_cube_xy([encX-2*gap,encY-2*gap,40],r=encR);
            
                translate([wallT/3+gap,wallT/3+gap,lEncZ])
                    rounded_cube_xy([encX-2*wallT/3-2*gap,encY-2*wallT/3-2*gap,40],r=encR);
            }
            translate([-10,-10,lEncZ+wallT/3])
                cube([encX+20,encY+20,40]);
        }
        //Bottom
        union() {
            translate([antX,antY+gap,antZ])
            rotate([90,0,0])
                cylinder(h=4+2*gap,d=13.4+gap);         
        } 
    }        
}
*split();

//Lower enclosure
module MNvB_lEnc_stl() {
    stl("MNvB_lEnc");

    difference() {
        enclosure(micro);
        split();
    }
    
}
//clip(xmin=60)
*MNvB_lEnc_stl();

//Upper enclosure
module MNvB_uEnc_stl() {
    stl("MNvB_uEnc");

     intersection() {
        enclosure();
        split(0.2);
    }
}
//clip(xmax=20)
*MNvB_uEnc_stl();

//Printed buttons
module MNvB_buttons_stl() {
    stl("MNvB_buttons");
   
   translate([encX-wallT,pcbY,wallT])
    rotate([0,180,0])
    Heltec_T114_buttons(wallT+0.4);
}
*MNvB_buttons_stl();

//Lower enclosure assembly
//! Insert nuts during print
module MNvB_lEnc_assembly() {
    //pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = true)
    //pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = false)
    //pose([-82, 50, 71], [76, 0, 237])
    assembly("MNvB_lEnc") {
 
        exploded = is_undef($explode) ? 0 : $explode; // 1 for exploded view
 
        //Enclosure
        if (exploded) {
            clip(zmax=8) MNvB_lEnc_stl();
        } else {
           MNvB_lEnc_stl(); 
        }
        
        //Nuts
        for (pos=screwPos) {
            explode([0,0,10])
            translate([pos.x,pos.y,encZ-wallT-8])
            rotate([0,0,30])
                nut(nutT);
        }
    }
}
//$explode = 1;
*MNvB_lEnc_assembly();

//Main assembly
//! Insert components, attach top and fasten screws.
module MNvB_assembly() {
    //pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = true)
    //pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = false)
    //pose([-82, 50, 71], [76, 0, 237])
    assembly("MNvB") {

        //Lower enclosure
        //clip(xmax=20)
        MNvB_lEnc_assembly($explode=0);
        
        //Upper enclosure
        explode([0,0,90])
        MNvB_uEnc_stl();
        
        //Buttons
        explode([0,0,20])
        MNvB_buttons_stl();
        
        //Battery
        explode([0,0,40])
        translate([batX,batY,batZ])
        rotate([0,90,0])
        battery(batT);
 
        //BMS
        translate([bmsX,bmsY,bmsZ])
        rotate([90,0,0])
        LiIonBMS();

        //Antenna
        explode([0,40,0])
        translate([antX,antY-3,antZ])
        rotate([270,0,0])
        LoRa_20cm_antenna(wallT, 90);


        //PCB
        explode([0,0,30])
        translate([encX-wallT,pcbY,wallT])
        rotate([0,180,0])
        Heltec_T114();

        //Screw
        for (pos=screwPos) {
            explode([0,0,50])
            translate([pos.x,pos.y,encZ-screw_head_height(screwT)])
                screw(screwT, 10);
        }
    }
}
//$explode = 1;
//$vpt = [-82, 50, 71];
//$vpr = [76, 0, 237];
//MNvB_assembly();
  
if($preview) {
//    $vpt = [-82, 50, 71];
//    $vpr = [76, 0, 237];
    //$explode = 1;
    *MNvB_lEnc_assembly();
    //clip(xmax=20)
    MNvB_assembly();
}
