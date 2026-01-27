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
batX      =  batL/2+wallT+0.5;       //Battery X position (from center)
batY      =  batD/2+2;               //Battery Y position
batZ      =  batD/2+2;               //Battery Z position
bmsX      =   batX;                  //BMS X position
bmsY      = batD+wallT+1;            //BMS Y position
bmsZ      =  batZ;                   //BMS Z position
encC      = wallT;                   //Enclosure chamfer
encX      = batL+2*wallT+1+8;        //Enclosure X dimension
encY      =  60+2*encC;              //Enclosure Y dimension
encZ      =  11+2*encC;              //Enclosure Z dimension
encR      =  5;                      //Enclosure corner radius
lEncZ     =  batZ;                   //Lower enclosure Z dimension
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
module enclosure() {
  
    difference() {
        //Positive       
        union() {
            
            //Enclosure shape
            *%hull() {
                translate([encC,encC,0])
                    rounded_cube_xy([encX-2*encC,encY-2*encC,encZ],r=encR-encC);
                translate([0,0,encC])
                    rounded_cube_xy([encX,encY,encZ-2*encC],r=encR);                   
                translate([encC,encC,0])
                    rounded_cube_xy([encX-2*encC,batD/2,batD-2+2*encC],r=encR-encC);
                translate([0,0,encC])
                    rounded_cube_xy([encX,batD/2+encC,batD-2],r=encR);
                
                  
                
                
            }
         }
        //Negative
        union() {

            //Enclosure shape

              
            //Antenna
            antOffs = 28.4;
            
            translate([antX,antY+antOffs,antZ])
            rotate([90,0,0])
                cylinder(h=antOffs,d=13);
            
            translate([antX,antY,antZ])
            rotate([90,0,0])
                cylinder(h=10,d=6.8);
            #hull() {
                translate([wallT,antY-2-17,wallT+micro]) 
                    cube([12,17,encZ-2*wallT-2]);
                translate([wallT+2,antY-2-17,wallT+micro]) 
                    cube([10,17,encZ-2*wallT]);
            }
            translate([wallT,batY,wallT]) 
                cube([14,antY-batY-2,encZ-2*wallT]);
                  
            hull() {
                for (y=[0,10]) {
                    translate([0,y,0]) {
                
                        translate([antX,antY+antOffs,antZ])
                            sphere(d=13.4);
                        
                        translate([antX-10,antY+antOffs,antZ])
                        rotate([0,90,0])
                            cylinder(h=84,d=13.4);
                        
                        //hull() {
                            translate([antX+74,antY+antOffs,antZ])
                                sphere(d=13.4);
                            translate([antX+120,antY+antOffs,antZ])
                                sphere(d=6.4);
                        //}
                        
                        translate([antX+84,antY+antOffs,antZ])
                        rotate([0,90,0])
                            cylinder(h=82,d=6.4);
                    }
                }
            }
            
            //PCB
            #translate([encX-wallT+1,pcbY,wallT])
            rotate([0,180,0])
                Heltec_T114_cutout();
            
            #translate([encX-wallT+1,pcbY+22.86/2,wallT])
            rotate([0,0,180])
            rounded_cube_xy([52.80,22.86,encZ-2*wallT-1],r=1);       
                
            //Battery
            #translate([batX,batY,batZ])
            rotate([0,90,0])
                cylinder(h=batL+1, d=batD+0.4, center=true);
            
            
            *translate([batX,batY,wallT])
                rounded_cube_yz([64,51,6],r=2);
            *hull() {
                translate([batX,batY,wallT+2])
                    cube([64,51,encZ-2*wallT-4]);
                translate([batX,batY+2,wallT+2+micro])
                    cube([64,49,encZ-2*wallT-2]);
            }

            //Screws
            for (pos=screwPos) {
                translate([pos.x,pos.y,encZ-wallT-8])
                    cylinder(h=nut_thickness(nutT)+0.2, r=nut_radius(nutT)+0.1, $fn=6);
                translate([pos.x,pos.y,wallT])
                     cylinder(h=40, r=screw_clearance_radius(screwT)+0.4);
               translate([pos.x,pos.y,encZ-wallT-2.2]) 
                    cylinder(h=2, r1=screw_clearance_radius(screwT)+1, r2=screw_head_radius(screwT)+1); 
                translate([pos.x,pos.y,encZ-wallT-0.2]) 
                    cylinder(h=1, r=screw_head_radius(screwT)+1);
            }
                  
           
        }
    }
}
//clip(xmin=20)
*enclosure(); 

//Lower enclosure
module MNvB_lEnc_stl() {
    stl("MNvB_enc");
    //Antenna
            antOffs = 28.4;


    difference() {
        //Positive       
        union() {

            //Enclosure shape
            difference() {
                hull() {
                    translate([encC,encC,0])
                        rounded_cube_xy([encX-2*encC,encY-2*encC,encZ],r=encR-encC);
                    translate([0,0,encC])
                        rounded_cube_xy([encX,encY,encZ-2*encC],r=encR);                   
                }
            #translate([antX,antY+antOffs,antZ]) 
                cylinder(h=10,d=6.6);
            }

        }
        //Negative
        union() {

            //Edge
            translate([-inf,-inf,lEncZ])
                cube([2*inf,2*inf,inf]);
            hull() {            
                translate([wallT/3,wallT/3,lEncZ])
                    rounded_cube_xy([encX-2*wallT/3,encY-2*wallT/3,1],r=encR-wallT/3);        
    
                translate([2*wallT/3,2*wallT/3,lEncZ-wallT/3])
                    rounded_cube_xy([encX-4*wallT/3,encY-4*wallT/3,wallT/3],r=encR-2*wallT/3);        
            }

            //Antenna
            translate([antX,antY+antOffs,antZ])
            rotate([90,0,0])
                cylinder(h=antOffs,d=13);
            
            translate([antX,antY,antZ])
            rotate([90,0,0])
                cylinder(h=10,d=6.8);

            translate([wallT,batY,wallT]) 
                cube([12,antY-batY-2,encZ-2*wallT]);

            translate([wallT+14,batY,wallT+3]) 
                cube([14,34,10]);

            translate([wallT+10,batY,wallT+3]) 
                cube([14,antY-batY-2,10]);
                  
            hull() {
                for (y=[0,10]) {
                    translate([0,y,0]) {
                
                        translate([antX,antY+antOffs,antZ])
                            sphere(d=13.4);
                        
                        translate([antX-10,antY+antOffs,antZ])
                        rotate([0,90,0])
                            cylinder(h=84,d=13.4);
                        
                        //hull() {
                            translate([antX+74,antY+antOffs,antZ])
                                sphere(d=13.4);
                            translate([antX+120,antY+antOffs,antZ])
                                sphere(d=6.4);
                        //}
                        
                        translate([antX+84,antY+antOffs,antZ])
                        rotate([0,90,0])
                            cylinder(h=82,d=6.4);
                    }
                }
            }

            //PCB
            translate([encX-wallT,pcbY,wallT])
            rotate([0,180,0])
                Heltec_T114_cutout();
            
            translate([encX-wallT,pcbY+22.86/2,wallT])
            rotate([0,0,180])
                rounded_cube_xy([52.80,22.86,encZ-2*wallT-1],r=1);       

            translate([encX-wallT,pcbY+28/2,wallT+3])
            rotate([0,0,180])
                cube([54,32,encZ-2*wallT-1]);       

            //Battery
            translate([batX,batY,batZ])
            rotate([0,90,0])
                cylinder(h=batL+1, d=batD+0.4, center=true);

            translate([batX-(batL+1)/2,batY,wallT+1])
                cube([batL+1,batD/2+5,batD/2]);
            
            //Screws
            for (pos=screwPos) {
                #translate([pos.x,pos.y,encZ-wallT-8])
                rotate([0,0,30])
                    cylinder(h=nut_thickness(nutT)+0.2, r=nut_radius(nutT)+0.1, $fn=6);
                translate([pos.x,pos.y,wallT])
                     cylinder(h=40, r=screw_clearance_radius(screwT)+0.4);
               translate([pos.x,pos.y,encZ-wallT-2.2]) 
                    cylinder(h=2, r1=screw_clearance_radius(screwT)+1, r2=screw_head_radius(screwT)+1); 
                translate([pos.x,pos.y,encZ-wallT-0.2]) 
                    cylinder(h=1, r=screw_head_radius(screwT)+1);
            }
            
            

        }
    }
}
*MNvB_lEnc_stl();

//Upper enclosure
module MNvB_uEnc_stl() {
    stl("MNvB_uEnc");

    difference() {
        //Positive
        union() {

            //Screws
            for (pos=screwPos) {
                translate([pos.x,pos.y,encZ-wallT-2]) 
                    cylinder(h=2, r1=screw_clearance_radius(screwT)+0.9, r2=screw_head_radius(screwT)+0.9);
            }
                
            //Spacers               
             translate([encX-46,pcbY+8.6,encZ-wallT-4])
                rounded_cube_xy([32,3,4],r=1);
             translate([encX-46,pcbY-11.6,encZ-wallT-4])
                rounded_cube_xy([32,3,4],r=1);            




        }
        //Negative
        union() {







            //Screws
            for (pos=screwPos) {
                translate([pos.x,pos.y,encZ-screw_head_height(screwT)-0.2])
                    cylinder(h=10, r=screw_head_radius(screwT)+0.4);
                translate([pos.x,pos.y,wallT])
                     cylinder(h=20, r=screw_clearance_radius(screwT));
            }
        }
    }
}
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
        *explode([0,0,90])
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
    MNvB_assembly();
}
