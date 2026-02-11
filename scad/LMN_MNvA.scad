//###############################################################################
//# LoRaMeshNodes - Mobile Node Variant A                                       #
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
//#   variant A.                                                                #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   January 23, 2026                                                          #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

//! These are the assembly instructions for the Mobile Node (Variant A) (MNvA),
//! a portable [Meshtastic](https://meshtastic.org) or
//! [MeshCore](https://meshcore.co.uk) node.

include <LMN_Config.scad>

//Parameters
lEncC     = wallT;             //Lower enclosure chamfer
lEncX     = 132+2*lEncC;       //Lower enclosure X dimension
lEncY     =  60+2*lEncC;       //Lower enclosure Y dimension
lEncZ     =  11+2*lEncC;       //Lower enclosure Z dimension
lEncR     =  10;               //Lower enclosure corner radius
pcbY      =  37;               //PCB Y position
lipoX     =  17;               //Lipo X position (from center)
lipoY     = lEncC;             //Lipo Y position
antX      =   5.5+lEncC;       //Ant X position
//antY    =  34;           //Ant Y position
antY      =  34+0.9;           //Ant Y position
antZ      = lEncZ/2;           //Ant Z position
gripX     = lEncX-3*lEncC;     //Grip hole X position (lower right corner)
gripY     =   3*lEncC;         //Grip hole Y position (lower right corner)
gripW     =  42;               //Grip hole Y width
//gripW   =  36;               //Grip hole Y width
gripH     =  12;               //Grip hole Y height
screwT    = M3_dome_screw;      //Screw type
nutT      = screw_nut(screwT); //Nut type
screwPos  = [[lEncR,lEncR],
             [lEncX-8,lEncY-13.6]];
             //[lEncX-lEncR,lEncY-13.6],
             //[84,22]];
            
micro = 0.001;
//Shape of the opening
module opening(d=0) {
    minR = 4;
    
    offset(delta=d, chamfer=false) {
        hull() {
            translate([lEncR,lEncR,0])
                circle(r=lEncR-lEncC-1);
            translate([lEncC+minR+1,antY-minR-0.6,0])
                circle(r=minR);
            translate([gripX-gripW-lEncC-minR-1,lEncC+minR+1,0])
                circle(r=minR);                    
            translate([gripX-gripW-lEncC-minR-1,antY-minR-0.6,0])
                square([minR,minR]);
        }
        hull() {           
            translate([screwPos[1].x,screwPos[1].y,0])
                circle(r=minR);
            translate([lipoX+minR-2,screwPos[1].y,0])
                circle(r=minR);
            translate([screwPos[1].x,gripY+gripH+lEncC+minR+1,0])
                circle(r=minR);
            translate([lipoX-2,gripY+gripH+lEncC+1,0])
                square([minR,minR]);
        }
        translate([gripX-gripW-lEncC-1,gripY+gripH+lEncC-minR+1,0])
        difference () {
            square([minR,minR]);
            translate([minR,0,0]) circle(r=minR);
        }
        translate([lipoX-minR-2,antY-0.6,0])
        difference () {
            square([minR,minR]);
            translate([0,minR,0]) circle(r=minR);
        }
    }
}
*translate([0,0,20]) opening();

//Lower enclosure
module MNvA_lEnc_stl() {
    stl("MNvA_lEnc");

    difference() {
        //Positive       
        union() {
            
            //Enclosure shape
            hull() {
                translate([lEncC,lEncC,0])
                    rounded_cube_xy([lEncX-2*lEncC,lEncY-2*lEncC,lEncZ],r=lEncR-lEncC);
                translate([0,0,lEncC])
                    rounded_cube_xy([lEncX,lEncY,lEncZ-2*lEncC],r=lEncR);
            }
         }
        //Negative
        union() {

            //Enclosure shape

            //Grip hole
            translate([gripX-gripW,gripY,-10])
                rounded_cube_xy([gripW,gripH,lEncZ+20],r=gripH/2-lEncC);
            
            hull() {
                translate([gripX-gripW-lEncC,gripY-lEncC,-1])
                    rounded_cube_xy([gripW+2*lEncC,gripH+2*lEncC,1],r=gripH/2-0.01);               
                translate([gripX-gripW,gripY,0])
                    rounded_cube_xy([gripW,gripH,lEncC],r=gripH/2-lEncC);
            }
            
            hull() {
                translate([gripX-gripW-lEncC,gripY-lEncC,lEncZ])
                    rounded_cube_xy([gripW+2*lEncC,gripH+2*lEncC,1],r=gripH/2-0.01);               
                translate([gripX-gripW,gripY,lEncZ-lEncC])
                    rounded_cube_xy([gripW,gripH,lEncC],r=gripH/2-lEncC);
            }
            
            //Antenna
//          antOffs = 28.0;
            antOffs = 28.0-0.9;
            
            translate([antX,antY+antOffs,antZ])
            rotate([90,0,0])
                cylinder(h=antOffs,d=13.4);
            
            translate([antX,antY,antZ])
            rotate([90,0,0])
                cylinder(h=10,d=6.8);
            
            hull() {
                translate([wallT,antY-2-17,wallT+micro]) 
                    cube([12,17,lEncZ-2*wallT-2]);
                translate([wallT+2,antY-2-17,wallT+micro]) 
                    cube([10,17,lEncZ-2*wallT]);
            }
            translate([wallT+2,antY-2-17,wallT+6]) 
                cube([20,17,lEncZ-2*wallT]);
             
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
                      
            *translate([antX,antY+antOffs,antZ-13.4/2])     
            cylinder(h=13.4, r=13.4/2);
                    
            hull() {
                for (y=[0,10]) {
                    translate([0,y,0]) {                
                        *translate([antX,antY+antOffs,antZ])
                            sphere(d=13.4);
                        
                        translate([antX-10,antY+antOffs,antZ])
                        rotate([0,90,0])
                            cylinder(h=84,d=13.4);
                    }
                }
            }
                                             
             hull() {
                for (y=[0,10]) {
                    translate([0,y,0]) {                
                        translate([antX+74,antY+antOffs,antZ])
                            sphere(d=13.4);
                        translate([antX+120,antY+antOffs,antZ])
                            sphere(d=7.8);
                    }
                }
            }
                        
             hull() {
                for (y=[0,10]) {
                    translate([0,y,0]) {                
                        translate([antX+84,antY+antOffs,antZ])
                        rotate([0,90,0])
                            cylinder(h=82,d=7.8);
                    }
                }
             }
            
            //PCB
            translate([lEncX-wallT,pcbY,wallT])
            rotate([0,180,0])
                Heltec_T114_cutout();
            
            hull() {
                translate([lEncX-wallT-0.6,pcbY+22.86/2,wallT])
                rotate([0,0,180])
                //rounded_cube_xy([51.80,22.86,lEncZ-2*wallT-2],r=1);       
                rounded_cube_xy([51.80,22.86,7],r=1);       
    
                translate([lEncX-wallT-2,pcbY+22.86/2,wallT+micro])
                rotate([0,0,180])
                rounded_cube_xy([49.80,22.86,lEncZ-2*wallT],r=1);       
            }
            translate([lEncX-2*lEncR-53,pcbY-22.86/2,wallT+3+micro])
                cube([60,lipoY+51-pcbY+22.86/2,lEncZ-2*wallT-3]);
            
            translate([lEncX-64,pcbY-7,wallT])
                cube([16,14,10]);

            //Battery
            translate([lipoX,lipoY,wallT])
                rounded_cube_yz([64,51,6],r=2);
            hull() {
                translate([lipoX,lipoY,wallT+2])
                    cube([64,51,lEncZ-2*wallT-4]);
                translate([lipoX,lipoY+2,wallT+2+micro])
                    cube([64,49,lEncZ-2*wallT-2]);
            }

            //Screws
            for (pos=screwPos) {
                translate([pos.x,pos.y,lEncZ-wallT-8])
                    cylinder(h=nut_thickness(nutT)+0.2, r=nut_radius(nutT)+0.1, $fn=6);
                translate([pos.x,pos.y,wallT])
                     cylinder(h=40, r=screw_clearance_radius(screwT)+0.4);
                translate([pos.x,pos.y,lEncZ-wallT-2.2]) 
                    cylinder(h=2, r1=screw_clearance_radius(screwT)+1, r2=screw_head_radius(screwT)+1); 
                translate([pos.x,pos.y,lEncZ-wallT-0.2]) 
                    cylinder(h=1, r=screw_head_radius(screwT)+1);
            }
                  
            //Opening
            translate([0,0,lEncZ-wallT]) linear_extrude(10) opening(0.2);   
        }
    }
}
//clip(xmin=80)
*MNvA_lEnc_stl();

//Upper enclosure
module MNvA_uEnc_stl() {
    stl("MNvA_uEnc");

    difference() {
        //Positive
        union() {
            //Opening
            translate([0,0,lEncZ-wallT]) linear_extrude(wallT) opening(-0.2);   

            //Screws
            for (pos=screwPos) {
                translate([pos.x,pos.y,lEncZ-wallT-2]) 
                    cylinder(h=2, r1=screw_clearance_radius(screwT)+0.9, r2=screw_head_radius(screwT)+0.9);
            }
                
            //Spacers
            translate([lipoX+4,lipoY+5,lEncZ-wallT-3])
                rounded_cube_xy([10,3,3],r=1);               
            translate([lipoX+4,lipoY+40,lEncZ-wallT-3])
                rounded_cube_xy([10,3,3],r=1);
                
            translate([lipoX+45,lipoY+5,lEncZ-wallT-3])
                rounded_cube_xy([10,3,3],r=1);               
            translate([lipoX+45,lipoY+40,lEncZ-wallT-3])
                rounded_cube_xy([10,3,3],r=1);
                
             translate([lEncX-44,pcbY+8.6,lEncZ-wallT-4])
                rounded_cube_xy([8,3,4],r=1);
             translate([lEncX-44,pcbY-11.6,lEncZ-wallT-4])
                rounded_cube_xy([8,3,4],r=1);            

             translate([lEncX-24,pcbY+8.6,lEncZ-wallT-4])
                rounded_cube_xy([8,3,4],r=1);
             translate([lEncX-24,pcbY-11.6,lEncZ-wallT-4])
                rounded_cube_xy([8,3,4],r=1);            
        }
        //Negative
        union() {
            //Screws
            for (pos=screwPos) {
                translate([pos.x,pos.y,lEncZ-screw_head_height(screwT)-0.2])
                    cylinder(h=10, r=screw_head_radius(screwT)+0.4);
                translate([pos.x,pos.y,wallT])
                     cylinder(h=20, r=screw_clearance_radius(screwT)+0.4);
            }
        }
    }
}
*MNvA_uEnc_stl();

//Printed buttons
module MNvA_buttons_stl() {
    stl("MNvA_buttons");
   
   translate([lEncX-wallT,pcbY,wallT])
    rotate([0,180,0])
    Heltec_T114_buttons(wallT+0.4);
}
*MNvA_buttons_stl();

//Lower enclosure assembly
//! Insert nuts during print
module MNvA_lEnc_assembly() {
    //pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = true)
    //pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = false)
    //pose([-82, 50, 71], [76, 0, 237])
    assembly("MNvA_lEnc") {
 
        exploded = is_undef($explode) ? 0 : $explode; // 1 for exploded view
 
        //Enclosure
        if (exploded) {
            clip(zmax=8) MNvA_lEnc_stl();
        } else {
           MNvA_lEnc_stl(); 
        }
        
        //Nuts
        for (pos=screwPos) {
            explode([0,0,10])
            translate([pos.x,pos.y,lEncZ-wallT-8])
                nut(nutT);
        }
    }
}
//$explode = 1;
*MNvA_lEnc_assembly();

//Main assembly
//! Insert components, attach top and fasten screws.
module MNvA_assembly() {
    //pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = true)
    //pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = false)
    //pose([-82, 50, 71], [76, 0, 237])
    assembly("MNvA") {

        //Lower enclosure
        MNvA_lEnc_assembly($explode=0);
        
        //Upper enclosure
        explode([0,0,90])
        MNvA_uEnc_stl();
        
        //Buttons
        explode([0,0,20])
        MNvA_buttons_stl();
        
        //LiPo battery
        explode([0,0,40])
        translate([lipoX,lipoY,wallT])
        rotate([0,0,0])
        lipo_755060();

        //Antenna
        explode([0,40,0])
        translate([antX,antY-3,antZ])
        rotate([270,0,0])
        LoRa_20cm_antenna(wallT, 90);

        //PCB
        explode([0,0,30])
        translate([lEncX-wallT,pcbY,wallT])
        rotate([0,180,0])
        Heltec_T114();

        //Screw
        for (pos=screwPos) {
            explode([0,0,50])
            translate([pos.x,pos.y,lEncZ-screw_head_height(screwT)])
                screw(screwT, 10);
        }
    }
}
//$explode = 1;
//$vpt = [-82, 50, 71];
//$vpr = [76, 0, 237];
//MNvA_assembly();
  
if($preview) {
//    $vpt = [-82, 50, 71];
//    $vpr = [76, 0, 237];
    //$explode = 1;
    *MNvA_lEnc_assembly();
    MNvA_assembly();
}
