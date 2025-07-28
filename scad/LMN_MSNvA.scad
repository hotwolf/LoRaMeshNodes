//###############################################################################
//# LoRaMeshNodes - Mobile Solar Node Variant A                                  #
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
//#   This file contains modules, which are specifiv for the Mobile Solar Node  #
//#   variant A.                                                                #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   July 18, 2025                                                             #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

//! These are the assembly instructions for the Mobile Solar Node (Variant A) (MSNvA),
//! a portable solar powered [Meshtastic](https://meshtastic.org) or
//! [MeshCore](https://meshcore.co.uk) node.

include <LMN_Config.scad>

//Parameters
lEncX     = 100;      //Lower enclosure X dimension
lEncY     = 100;      //Lower enclosure Y dimension
lEncZ     =  16;      //Lower enclosure Z dimension
lEncRim   =   3;      //Lower enclosure rim width
pcbY      =  78;      //PCB Y position
lipoX     =   4;      //Lipo X position (from center)
lipoY     =  18;      //Lipo Y position
gnssX     =  22;      //GNSS X position (from left edge)
gnssY     =  30;      //GNSS Y position
antY      =  86;      //Ant Y position
standY    =  58;      //Y position of the stand pivot    
standT    =   6;      //Thickness of the stand pivot    
standBarW =   12;     //Width of the stand's bar
standBarT =   wallT;  //Thickness of the stand's bar
standA    =   0;      //Current angle of the stand

//Lower enclosure side profile
lEncSideProf  = [[                                  0,            0],
                 [                                  0,      lEncRim],
                 [        (lEncZ-lEncRim)/tan(solarA),        lEncZ],
                 [lEncX-((lEncZ-lEncRim)*tan(solarA)),        lEncZ],
                 [                              lEncX,      lEncRim],
                 [                              lEncX,            0],
                 [                              lEncX,          -10],
                 [                                  0,          -10]];

//Stand profile
standR        = (lEncZ-lEncRim)/2;
standProf     = [[                                  0,        standR],
                 [                                  0,       -standR],
                 [ (standY+standR)*tan(solarA)-standR,       -standR],
                 [ (standY-standR)*tan(solarA)-standR,        standR]];

barCutoutProf = [[-standBarW ,  -standBarW       ],
                 [-standBarW , 2*standBarW       ],
                 [ standBarT, standBarW-standBarT],
                 [ standBarT,           standBarT]];

barProf       = [[        0, 0                  ],
                 [        0, standBarW          ],
                 [standBarT, standBarW-standBarT],
                 [standBarT,           standBarT]];

pcbClampProf  = [[         0,    0              ],
                 [         0, 6.22              ],
                 [         1, 6.72              ],
                 [         1, 7.22              ],
                 [        -2, 7.22              ],
                 [        -2,    0              ]];

module lEncInnerProf(depth=lEncX-2*wallT) {
    rotate([270,0,90])
    linear_extrude(depth)
    offset(delta=-wallT, chamfer=false)   
    difference() {
        polygon(lEncSideProf);
        union() {
//            hull() {
                translate([0.5*standY,lEncZ,0]) rotate([0,0,270]) polygon(barCutoutProf);
//                translate([0,lEncZ,0]) rotate([0,0,270]) polygon(barCutoutProf);
//            }
            translate([0,-lEncZ/2,0]) square([2*wallT,2*lEncZ]);
//         #translate([lEncY-2*wallT,-lEncZ/2,0]) square([2*wallT,2*lEncZ]);
        }
    }    
}
*#translate([2-lEncX/2,0,0])
rotate([270,0,90])
lEncInnerProf(1);

*difference() {
    rotate([270,0,90])
//    round_3D(or=5, chamfer_base=true)
    lEncBody();
    union() {
        translate([-wallT,pcbY,-lEncZ+wallT])
        rotate([0,180,0])
        Heltec_T114_cutout();
    }
}

//Plain stand shape
module standShape (cutout=false, angle=0) {
    gap = cutout ? gapW : 0;
    
    //Feet
    translate([-lEncX/2,0,-2*standR])  {
        for(m = [0,1]) {
            mirror([m,0,0]) {
                translate([-lEncX/2+standT,standY,standR])  
                rotate([90,angle,270]) {
                   rotate([180,0,0]) 
                    cylinder(h=(0.75*standR)+gap, r1=standR-edgeR+gap, r2=0);
                    for (a = [0,cutout ? 270 : 0])
                        rotate([0,0,a])
                        hull() { 
                            translate([0.1*(standR-edgeR+gap),0,-0.75*0.9*standR-gap]) sphere(r=0.05*standR+gap);
                            translate([0.9*(standR-edgeR+gap),0,-0.75*0.1*standR-gap]) sphere(r=0.05*standR+gap);
                        }
                    translate([0.5*standY,0,0]) sphere(r=0.12*standR+gap);
                        
                    minkowski() {
                        hull() {
                            sphere(r=edgeR+gap);
                            if (cutout) 
                               union() {
                                 translate([0,-20,0])  sphere(r=edgeR+gap);
                                 translate([0,0,20])  sphere(r=edgeR+gap);
                               }
                        }
                        translate([0,0,edgeR])
                        linear_extrude(standT-2*edgeR) {
                            offset(delta=-edgeR) { 
                                polygon(standProf);
                                circle(r=standR);
                                if (cutout) translate([-standR,-standR,0]) square(standR);
                            }
                        }
                    }
                }
            }
        }
       //Bar 
       translate([(lEncX-standT)/2,0.5*standY,0])
       rotate([0,270,0])
       linear_extrude(lEncX-standT)
       offset(r= edgeR+gap)
       offset(delta=-edgeR)
       if (cutout)
           polygon(barCutoutProf);
//           polygon([[-standBarW ,  -standBarW                ],
//                    [-standBarW , 2*standBarW          ],
//                    [ standBarT, standBarW-standBarT],
//                    [ standBarT,           standBarT]]);
       else
           polygon(barProf);
//           polygon([[        0, 0                  ],
//                    [        0, standBarW          ],
//                    [standBarT, standBarW-standBarT],
//                    [standBarT,           standBarT]]);
        
    }
}
//#standShape(true);
//standShape(false);

//Printed stand
module MSNvA_stand_stl() {
    stl("MSNvA_stand");
   translate([0,0,-lEncRim])
    standShape(false);

}
*MSNvA_stand_stl();

//Printed buttons
module MSNvA_buttons_stl() {
    stl("MSNvA_buttons");
   
    translate([-wallT,pcbY,-lEncZ+wallT])
    rotate([0,180,0])
    Heltec_T114_buttons();
}
*MSNvA_buttons_stl();

//Lower enclosure body
module MSNvA_lEnc_stl() {
    stl("MSNvA_lEnc");

    //Main enclosure
    difference() {
        //Positive       
        union() {
            //Body outside
            translate([-edgeR,0,0])
            rotate([270,0,90]) 
            minkowski() {
                sphere(r=edgeR);
                linear_extrude(lEncY-2*edgeR)
                offset(delta=-edgeR) polygon(lEncSideProf);
            }

            
        }
        //Negative
        union() {
            //Inner space
            difference() {
                translate([-wallT,0,0]) lEncInnerProf();
                union() {
                    translate([-standT-(0.75*standR)-2*gapW,0,-1.5*lEncZ]) 
                        rounded_cube_xy([standT+(0.75*standR)+2*gapW,pcbY-22.86/2,2*lEncZ], r=2);
                    translate([-lEncX,0,-1.5*lEncZ]) 
                        cube([standT+(0.75*standR)+2*gapW,lEncY,2*lEncZ]);             
                    translate([-lEncX,lEncY-25,-1.5*lEncZ]) 
                        rounded_cube_xy([18,25,2*lEncZ], r=2);
                }
            }

            //Top 
            translate([-1.5*lEncX,-0.5*lEncY,0]) cube([2*lEncX,2*lEncY,40]);
            
            //Stand
            translate([0,0,-lEncRim]) 
            standShape(true);
            
            //PCB
            translate([-wallT,pcbY,-lEncZ+wallT])
            rotate([0,180,0])
            Heltec_T114_cutout();
            
            //Antenna
            translate([-lEncX+wallT+12,antY,-lEncZ/2])
            rotate([0,270,0])
            cylinder(h=25, d=13);
            translate([-lEncX+wallT+22,antY,-lEncZ/2])
            rotate([0,270,0])
            cylinder(h=35, d=6.3);

            //LiPo
            translate([lipoX-7.5-lEncX/2,standY/2-standBarW/2,-lEncZ+wallT+1])
            cube([5,2*standBarW,2]);
            translate([lipoX+7.5-lEncX/2,standY/2-standBarW/2,-lEncZ+wallT+1])
            cube([5,2*standBarW,2]);

            //Solar panel
            translate([-100,0,0])
            solar_100x100();

            //Debug
            //translate([-lEncX/2,-50,-50]) cube([100,200,100]);
        }
    }
    
    //Interior
    difference() {
        //Positive       
        union() {
             //PCB holder
            translate([-wallT,pcbY-27/2,-lEncZ+wallT+2])
            rotate([0,180,0])
            rounded_cube_xy([54,27,4], r=2);
            
            translate([-wallT-20,pcbY-23/2,-lEncZ+wallT])
            rotate([90,0,90])
            linear_extrude(10)
            polygon(pcbClampProf);
       
            translate([-wallT-43,pcbY-23/2,-lEncZ+wallT])
            rotate([90,0,90])
            linear_extrude(10)
            polygon(pcbClampProf);
       
            translate([-wallT-10,pcbY+23/2,-lEncZ+wallT])
            rotate([90,0,270])
            linear_extrude(10)
            polygon(pcbClampProf);
       
            translate([-wallT-33,pcbY+23/2,-lEncZ+wallT])
            rotate([90,0,270])
            linear_extrude(10)
            polygon(pcbClampProf);
            
            //Lipo
            #translate([-15-lEncX/2,lipoY,-lEncZ+wallT])
            rounded_cube_xy([45/2-lipoX+lEncX/2,34,1],r=2);
            
            
        }
        //Negative
        union() {
            //PCB
            translate([-wallT,pcbY,-lEncZ+wallT])
            rotate([0,180,0])
            Heltec_T114_cutout();
      
            //Lipo
            #translate([lipoX-7.5-lEncX/2,standY/2-2*standBarW,-lEncZ+wallT])
            cube([5,4*standBarW,3]);
            #translate([lipoX+7.5-lEncX/2,standY/2-2*standBarW,-lEncZ+wallT])
            cube([5,4*standBarW,3]);
            
             *#translate([-25-lEncX/2,lipoY,-lEncZ+wallT])
            rounded_cube_xy([45+lipoX,34,1],r=2);
           
            
        }
    }
}
*MSNvA_lEnc_stl();

//! A
module MSNvA_lEnc_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("MSNvA_lEnc") {

        //Lower enclosure
        MSNvA_lEnc_stl();

        //Buttons
        MSNvA_buttons_stl();

        //Stand
        *MSNvA_stand_stl();
        
        //PCB
        translate([-wallT,pcbY,-lEncZ+wallT])
        rotate([0,180,0])
        Heltec_T114();

        //Antenna
        translate([-lEncX+wallT+15,antY,-lEncZ/2])
        rotate([0,270,0])
        LoRa_20cm_antenna(wallT, 90);

        //LiPo battery
        translate([-20+lipoX-lEncX/2,lipoY,-lEncZ+wallT])
        rotate([0,0,0])
        lipo_103450();

        //GNSS
        #translate([gnssX-lEncX,gnssY,-lEncZ+wallT+5])
        rotate([0,0,90])
        L76K_GNSS();

    }
}
*MSNvA_lEnc_assembly();

if($preview) {    
   MSNvA_lEnc_assembly();
}






















module MSNvA_top_stl() {
    stl("MSNvA_top");
    
    //Solar panel frame
    difference() {
        union() {
            hull() {
                translate([1,1,0])
                rounded_cube_xy([102,102,5], 1);
                translate([0,0,0])
                rounded_cube_xy([104,104,4], 2);
            }
            
        }
        union() {
            translate([1.9,1.9,2])
            cube([100.2,100.2,10]);
            
            translate([10,10,-10])
            rounded_cube_xy([84,84,20], 2);
            
        }
    }
            
        
  
    
}
*MSNvA_top_stl();
    
    *color("white", 0.5)
    rotate([-35,0,-1])
    translate([-10,-10,0])
    cube([124,122,1]);

    
 *solar(solar_100x100);



*Heltec_T114();



*lipo(lipo_103450);








//! Finished!
module MSNvA_assembly() {
  //pose([30, 0, 0], [150,150,0])
    assembly("MSNvA") {

    }
}

if($preview) {    
   MSNvA_assembly();
}
