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
lipoX     =   0;      //Lipo X position (from center)
lipoY     =  18;      //Lipo Y position
gnssX     =  20;      //GNSS X position (from left edge)
gnssY     =  67;      //GNSS Y position
antY      =  86;      //Ant Y position
standY    =  58;      //Y position of the stand pivot    
standT    =   6;      //Thickness of the stand pivot    
standBarW =   12;     //Width of the stand's bar
standBarT =   wallT;  //Thickness of the stand's bar
standA    =   0;      //Current angle of the stand

explode = is_undef($explode) ? 0 : $explode; // 1 for exploded view

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

ziptChanProf =  [[       -30,    0               ],
                 [        30,    0               ],
                 [        30,   20               ],
                 [        27,   20               ],
                 [        27,    1.6             ],
                 [       -27,    1.6             ],
                 [       -27,   20               ],
                 [       -30,   20               ]];
    
  
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
//           polygon([[-standBarW ,  -standBarW       ],
//                    [-standBarW , 2*standBarW       ],
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
            //Snap
            translate([-lEncX/2,lEncY/2,0])
            for (a = [0,90,180,270]) {
                rotate([0,0,a])
                for (x = [-lEncX/4,0,lEncX/4]) {
                    $fn = 64;
                    translate([x,-lEncY/2+0,-1.6])
                    scale([6.2,2.2,2.2]) sphere(d=1);
                }
            }
            
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
            translate([-lEncX/2+lipoX-18,lipoY+2,-lEncZ+wallT+3])
            minkowski() {
                cube([41,30,10]);
                sphere(2);
            }

            //Solar panel
            translate([-100,0,0])
            solar_100x100();

            //Debug
//            translate([-lEncX/2,-50,-50]) cube([100,200,100]);
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
       
//            translate([-wallT-43,pcbY-23/2,-lEncZ+wallT])
//            rotate([90,0,90])
//            linear_extrude(10)
//            polygon(pcbClampProf);
       
            translate([-wallT-10,pcbY+23/2,-lEncZ+wallT])
            rotate([90,0,270])
            linear_extrude(10)
            polygon(pcbClampProf);
       
//            translate([-wallT-33,pcbY+23/2,-lEncZ+wallT])
//            rotate([90,0,270])
//            linear_extrude(10)
//            polygon(pcbClampProf);
            
            //Lipo
            translate([-lEncX/2+lipoX-21,lipoY-1,-lEncZ+wallT])
            rounded_cube_xy([54,36,6],r=2);  
            
            //GNSS
            translate([gnssX-lEncX-1,gnssY-8,-lEncZ+wallT])
            rotate([90,0,90])
            linear_extrude(6)
            polygon(pcbClampProf);

            translate([gnssX-lEncX+5,gnssY+8,-lEncZ+wallT])
            rotate([90,0,270])
            linear_extrude(6)
            polygon(pcbClampProf);

            difference() {
                union() {
                    translate([gnssX-lEncX-11,gnssY-10,-lEncZ+wallT])  
                    rounded_cube_xy([20,20,5.6], r=2);                    
                }
                union() {
                    translate([gnssX-lEncX-9,gnssY-8,-lEncZ+wallT+4.6+1.6-3.8])  
                    cube([18,16,10]);
                   
                    translate([gnssX-lEncX-7,gnssY-6,-lEncZ+wallT])  
                    cube([20,12,10]);
                   
                    translate([gnssX-lEncX-2,gnssY-11,-lEncZ+wallT])
                    cube([8,4,20]);
                    
                    translate([gnssX-lEncX-2,gnssY+7,-lEncZ+wallT])
                    cube([8,4,20]);
                    
                    translate([0,0,-lEncRim]) 
                    standShape(true);                   
                }
            }
        }
        //Negative
        union() {
            //PCB
            translate([-wallT,pcbY,-lEncZ+wallT])
            rotate([0,180,0])
            Heltec_T114_cutout();
            translate([-wallT-1,pcbY-22.86/2,0])
            rotate([0,180,0])
            rounded_cube_xy([50.80,22.86,lEncZ-wallT],r=1);
            //Lipo     
            translate([-lEncX/2+lipoX-18,lipoY+2,-lEncZ+wallT+3])
            minkowski() {
                cube([41,30,10]);
                sphere(2);
            }
            translate([-lEncX/2+lipoX-18+7,lipoY+2,-lEncZ+wallT+5])
            minkowski() {
                cube([41,30,10]);
                sphere(2);
            }
     
            translate([0,0.5*standY,-lEncZ+2])
            rotate([0,270,0])
            linear_extrude(lEncX)
                polygon(barCutoutProf);
       
            for (y=[7,29])
                translate([-lEncX/2+lipoX+6,lipoY+3+y,-lEncZ+wallT])
                rotate([90,0,0])
                linear_extrude(8)
                offset(r=-0.6)
                offset(r=0.6) 
                    polygon(ziptChanProf);   
            
        }
    }
}
*MSNvA_lEnc_stl();

// Lower enclosure
//! 1. Attach the antenna to the enclosure 
//! 2. Connect it to the Heltec T114 board
//! 3. Insert buttons
//! 4. Insert Heltec T114 board
//! 5. Connect and insert the GNSS module (optional)
//! 6. Attach the battery with two zip ties
//! 7. Connect the battery to the Heltec T114 board
module MSNvA_lEnc_assembly() {
    pose([-82, 50, 71], [76, 0, 237])
    assembly("MSNvA_lEnc") {

        //LiPo battery
        explode([0,0,40])
        translate([-20+lipoX-lEncX/2,lipoY,-lEncZ+wallT+2])
        rotate([0,0,0])
        lipo_103450();

        //Antenna
        translate([explode?-24:0,0,0])
        translate([-lEncX+wallT+15,antY,-lEncZ/2])
        rotate([0,270,0])
        LoRa_20cm_antenna(wallT, 90);

        //Lower enclosure
        MSNvA_lEnc_stl();

        //Stand
        explode([0,0,-50])
        MSNvA_stand_stl();
        
        //PCB
        explode([0,0,30])
        translate([-wallT,pcbY,-lEncZ+wallT])
        rotate([0,180,0])
        Heltec_T114();
  
        //Buttons
        explode([0,0,20])
        MSNvA_buttons_stl();
  
        //GNSS
        explode([0,0,30])
        translate([gnssX-lEncX,gnssY,-lEncZ+wallT+4.6])
        rotate([0,0,0])
        L76K_GNSS();
    }
}
//$explode = 1;
//$vpt = [-82, 50, 71];
//$vpr = [76, 0, 237];
//MSNvA_lEnc_assembly();

module MSNvA_top_stl() {
    stl("MSNvA_top");

    //Snap
    translate([-lEncX/2,lEncY/2,0])
    for (a = [0,90,180,270]) {
        rotate([0,0,a])
        for (x = [-lEncX/4,0,lEncX/4]) {
            $fn = 64;
            translate([x,-lEncY/2+0,-1.6])
            scale([6,2,2]) sphere(d=1);
        }
    }

    //Solar panel frame
    difference() {
        union() {
            //Unrounded positives            
            minkowski() {
                difference() {
                    union() {
                        //Rounded positives
                        //Frame    
                        translate([-lEncX-1,-1,-2])
                        rounded_cube_xy([lEncX+2,lEncY+2,6],r=1);
                    }
                    union() {
                        //Rounded negatives
                        //Opening    
                        translate([-lEncX+1,1,0])
                        rounded_cube_xy([lEncX-2,lEncY-2,20],r=1);
                        //Slope
                        translate([0,0,-3])
                        rotate([-35,0,0])
                        translate([-2*lEncX,-lEncY/2,-20+edgeR])
                            cube([3*lEncX,lEncY,20]);

                    }
                }
                sphere(r=edgeR);
            }
        }
        union() {
            //Unrounded positives    
            translate([-lEncX+0.1,0,-17])
                cube([lEncX+0.2,lEncY+0.2,20]);
            
            //Antenna
            translate([-lEncX+wallT+12,antY,-lEncZ/2])
            rotate([0,270,0])
                cylinder(h=25, d=13);

        }
    }         
}
*MSNvA_top_stl();
  
module MSNvA_cov_stl() {
    stl("MSNvA_cov");

    covWallT = 2;

    module simpEnc() {
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
                //Top 
                translate([-1.5*lEncX,-0.5*lEncY,0]) cube([2*lEncX,2*lEncY,40]);
             }
        }
        //Solar panel frame
        union() {
            //Unrounded positives            
            minkowski() {
                difference() {
                    union() {
                        //Rounded positives
                        //Frame    
                        translate([-lEncX-1,-1,-2])
                        rounded_cube_xy([lEncX+2,lEncY+2,6],r=1);
                    }
                    union() {
                        //Rounded negatives
                        //Slope
                        translate([0,0,-3])
                        rotate([-35,0,0])
                        translate([-2*lEncX,-lEncY/2,-20+edgeR])
                            cube([3*lEncX,lEncY,20]);

                    }
                }
                sphere(r=edgeR);
            }
        }
    }
    *simpEnc();

    //Profile
    module simpEncProf() {
        projection(cut = true)
            rotate([0,90,0])
            translate([lEncX/2,0,0]) 
                simpEnc();
    }
    *simpEncProf();

    //Cover
    difference() {
        union() {           
            translate([covWallT+1,0,0])
            rotate([0,270,0])
                minkowski() {
                    linear_extrude(lEncX+6)
                        offset(r=covWallT-1)
                            simpEncProf();
                    sphere(r=1);
                }
            
            
        }
        union() {
            minkowski() {
                union() {
                    simpEnc();
                    difference() {
                        translate([-lEncX/2,0,0]) 
                        rotate([0,270,0])
                        linear_extrude(lEncX)
                           simpEncProf();
                        union() {
                            hull() {
                                translate([-lEncX-covWallT/2-1,lEncY/2-20,5]) sphere(d=2);  
                                translate([-lEncX-covWallT/2-1,lEncY/2+20,5]) sphere(d=2);  
                                translate([-lEncX-covWallT/2-1,lEncY/2-20,20]) sphere(d=2);  
                                translate([-lEncX-covWallT/2-1,lEncY/2+20,20]) sphere(d=2);  
                             }                   
                             hull() {
                                translate([-lEncX-0.4,lEncY/2-20,-lEncZ+0]) sphere(d=2);  
                                translate([-lEncX-0.4,lEncY/2+20,-lEncZ+0]) sphere(d=2);  
                                translate([-lEncX-0.4,lEncY/2-20,-lEncZ-20]) sphere(d=2);  
                                translate([-lEncX-0.4,lEncY/2+20,-lEncZ-20]) sphere(d=2);  
                            }
                        }
                    }
                    translate([-20,lEncY/2,-lEncZ/2+2])
                    rotate([0,90,0])
                        cylinder(h=40, d=20);
                    
                    translate([-2*lEncX,-lEncY/2,-1.5*lEncZ])
                        cube([80,2*lEncY,2*lEncZ]);
                    
                }
                sphere(r=0.2);  
            }           
        }
    }
}
*MSNvA_cov_stl();

//Final assembly
//! 1. Connect the solar panel to the Heltec T114 board
//! 2. Place the solar panel on the enclosure
//! 3. Attach the top frame
module MSNvA_assembly() {
    pose([-82, 50, 71], [76, 0, 237])
    assembly("MSNvA") {

     //Lower enclosure
     MSNvA_lEnc_assembly();

     //Solar panel
     explode([0,0,20])   
     translate([-100,0,0]) solar_100x100();

     //Top
     explode([0,0,40])   
     MSNvA_top_stl();
    }
}
//$explode = 1;
//$vpt = [-82, 50, 71];
//$vpr = [76, 0, 237];
//MSNvA_assembly();

if($preview) {    
   MSNvA_assembly();
}
