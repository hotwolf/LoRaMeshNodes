//###############################################################################
//# LoRaMeshNodes - Mobile Solar Node Variant B                                  #
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
//#   variant B.                                                                #
//#   Variant B is almost identical to Variant A, bit it uses a 18650 Li-Ion    #
//#   battery, instead of a 103450 Li-Po.                                       #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   August 22, 2025                                                           #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

//! These are the assembly instructions for the Mobile Solar Node (Variant A) (MSNvB),
//! a portable solar powered [Meshtastic](https://meshtastic.org) or
//! [MeshCore](https://meshcore.co.uk) node.

include <LMN_Config.scad>

//Parameters
lEncX      = 100;                                                    //Lower enclosure X dimension
lEncY      = 100;                                                    //Lower enclosure Y dimension
lEncZ      =  20;                                                    //Lower enclosure Z dimension
lEncRim    =   3;                                                    //Lower enclosure rim width
pcbY       =  61;                                                    //PCB Y position
gnssX      =  18.4;                                                  //GNSS X position (from left edge)
gnssY      =  58;                                                    //GNSS Y position
antY       =  78;                                                    //Antenna Y position
bmsX       =  -lEncX/2+4;                                            //BMS X position
bmsY       =  46;                                                    //BMS Y position
bmsZ       =  -lEncZ/2;                                              //BMS Z position
standY     =  78;                                                    //Y position of the stand pivot    
standT     =   6;                                                    //Thickness of the stand pivot    
standBarW  =  12;                                                    //Width of the stand's bar
standBarT  =   wallT;                                                //Thickness of the stand's bar
standBarY  =  36;                                                    //Y position of the stand's bar
standA     =   0;                                                    //Current angle of the stand
batType    = S25R18650;                                              //Battery type
batCType   = battery_contact(batType);                               //Battery contact type
batL       = battery_length(batType);                                //Battery length
batD       = battery_diameter(batType);                              //Battery diameter
batX       =-1.5-lEncX/2;                                            //Battery X position    
batY       = 29.8;                                                   //Battery Y position
batZ       = -lEncZ/2+0.3;                                           //Battery Y position
batNX      = batX+battery_length(batType)/2+contact_neg(batCType).x; //Negative battery contact X position
batPX      = batX-battery_length(batType)/2-contact_pos(batCType).x; //Positive battery contact X position
batCW      = max(contact_width(batCType), 10.4);                     //Width of a battery contact
batCH      = max(contact_height(batCType), 9.4);                     //Height of a battery contact
batCT      = max(contact_thickness(batCType),0.8);                   //Thickness of a battery contact

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
                translate([standBarY,lEncZ,0]) rotate([0,0,270]) polygon(barCutoutProf);
//                translate([0,lEncZ,0]) rotate([0,0,270]) polygon(barCutoutProf);
//            }
            translate([0,-lEncZ/2,0]) square([2*wallT,2*lEncZ]);
//         #translate([lEncY-2*wallT,-lEncZ/2,0]) square([2*wallT,2*lEncZ]);
        }
    }    
}
*translate([2-lEncX/2,0,0])
rotate([270,0,90])
lEncInnerProf(1);

//Plain stand shape
module standShape (cutout=false, angle=standA*1) {
    gap   = cutout ? gapW : 0;
    angle = cutout ? 0 : angle;
    
    translate([0,standY,-standR]) 
    rotate([angle,0,0]) {
    
    //Feet
    translate([-lEncX/2,0,-standR])  {            
        for(m = [0,1]) {
            mirror([m,0,0]) {
                translate([-lEncX/2+standT,0,standR])
                rotate([90,0,270]) {

                    rotate([180,0,0]) 
                        if (m==1) cylinder(h=(0.75*standR)+gap, r1=standR-edgeR+gap, r2=0);
                        for (a = [0,cutout ? 270 : 0])
                            rotate([0,0,a])
                            if (m==1) hull() { 
                                translate([0.1*(standR-edgeR+gap),0,-0.75*0.9*standR-gap]) sphere(r=0.05*standR+gap);
                                translate([0.9*(standR-edgeR+gap),0,-0.75*0.1*standR-gap]) sphere(r=0.05*standR+gap);
                            }
                            translate([standBarY,0,0]) sphere(r=0.12*standR+gap);

                    difference() {
                          
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
                        if ((m==0) && (cutout==false)) translate([0,0,-10]) cylinder(h=20, d=13.2);        
                    }
                }
            }
        }
        //Bar 
        translate([(lEncX-standT)/2,-standY+standBarY,0])
        rotate([0,270,0])
        linear_extrude(lEncX-standT)
        offset(r= edgeR+gap)
        offset(delta=-edgeR)
        if (cutout)
            polygon(barCutoutProf);
        else
           polygon(barProf);
        }
    }
}
//standShape(false);
//standShape(true);

//Printed stand
module MSNvB_stand_stl() {
    stl("MSNvB_stand");
   translate([0,0,-lEncRim])
    standShape(false);

}
*MSNvB_stand_stl();

//Printed buttons
module MSNvB_buttons_stl() {
    stl("MSNvB_buttons");
   
    Heltec_T114_buttons();
}
*MSNvB_buttons_stl();

//Lower enclosure body
module MSNvB_lEnc_stl() {
    stl("MSNvB_lEnc");

    //Main enclosure
    difference() {
        //Positive       
        union() {
            //Body outside
            translate([-edgeR,0,0])
            rotate([270,0,90]) 
            minkowski() {
                linear_extrude(lEncY-2*edgeR)
                offset(delta=-edgeR) polygon(lEncSideProf);
                sphere(r=edgeR);
             }
        }
        //Negative
        union() {
            //Snap
            translate([-lEncX/2,lEncY/2,0])
            for (a = [0,90,180,270]) {
                rotate([0,0,a])
                hull() {
                    for (x = [-lEncX/4,lEncX/4]) {
                        $fn = 64;
                        translate([x,-lEncY/2+0,-1.6])
                        scale([6.2,2.2,2.2]) sphere(d=0.8);
                    }
                }
            }
            
            //Inner space
            difference() {
                translate([-wallT,0,0]) lEncInnerProf();
                union() {
                    translate([-standT-wallT-2*gapW,0,-1.5*lEncZ]) 
                        cube([standT+wallT+2*gapW,lEncY,2*lEncZ]);

                    translate([-standT-0.75*standR-2*gapW,lEncY-27,-1.5*lEncZ]) 
                        rounded_cube_xy([standT+0.75*standR,32,2*lEncZ], r=2);


                    translate([-lEncX,0,-1.5*lEncZ])                    
                        cube([standT+wallT+2*gapW,lEncY,2*lEncZ]);             
                    translate([-lEncX,lEncY-32,-1.5*lEncZ]) 
                        rounded_cube_xy([18,32,2*lEncZ], r=2);
                }
            }

            //Top 
            translate([-1.5*lEncX,-0.5*lEncY,0]) cube([2*lEncX,2*lEncY,40]);
            
            //Stand
            translate([0,0,-lEncRim]) 
            standShape(true);
            
            //PCB
            translate([-standT-wallT-2*gapW,pcbY,-lEncZ+wallT])
            rotate([0,180,0])
            Heltec_T114_cutout();
            
            //Antenna
            translate([-lEncX+wallT+12,antY,-(lEncRim+lEncZ)/2])
            rotate([0,270,0])
            cylinder(h=25, d=13);
            translate([-lEncX+wallT+22,antY,-(lEncRim+lEncZ)/2])
            rotate([0,270,0])
            cylinder(h=35, d=6.3);

            //Li-Ion battery        
            translate([batNX-contact_thickness(batCType)-0.6,batY,batZ])
            rotate([0,270,0])
                cylinder(h=batNX-batPX-2*contact_thickness(batCType)-1.2, d=batD+0.2);                        
            //Solar panel
            translate([-100,0,0])
            solar_100x100();

            //Debug
//            translate([-0.2*lEncX,-50,-50]) cube([100,200,100]);
//            translate([-100,-100,-10]) cube([200,200,100]);
        }
    }
    
    //Interior
    difference() {
        //Positive       
        union() {
             //PCB holder
            translate([-standT-wallT-2*gapW+1,pcbY-27/2,-lEncZ+wallT+2])
            rotate([0,180,0])
            rounded_cube_xy([54,27,4], r=2);
            
            translate([-standT-wallT-2*gapW-20,pcbY-23/2,-lEncZ+wallT])
            rotate([90,0,90])
            linear_extrude(10)
            polygon(pcbClampProf);
       
            translate([-standT-wallT-2*gapW-10,pcbY+23/2,-lEncZ+wallT])
            rotate([90,0,270])
            linear_extrude(10)
            polygon(pcbClampProf);
                  
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
            
            //Li-Ion battery
            difference() {
                union() {
                    intersection() {
                        translate([-lEncX/2,batY,-lEncZ+wallT])
                            rounded_cube_xy([batNX-batPX+4,batD+8,0.6*batD], r=2, xy_center=true);
                     
                        translate([-edgeR,0,0])
                        rotate([270,0,90]) 
                        linear_extrude(lEncY-2*edgeR)
                            polygon(lEncSideProf);
                    }
                                             
                }
                union() {
                    //18650
                    translate([batNX-contact_thickness(batCType)-0.6,batY,batZ])
                    rotate([0,270,0])
                        cylinder(h=batNX-batPX-2*contact_thickness(batCType)-1.2, d=batD+0.2);
                    translate([batPX+contact_thickness(batCType)+0.6,batY-(battery_diameter(batType)+0.2)/2,batZ])
                        cube([batNX-batPX-2*contact_thickness(batCType)-1.2,battery_diameter(batType)+0.2,40]);   
                    //P contact
                    translate([batPX-batCT+contact_thickness(batCType),batY-batCW/2,batZ-batCH/2])
                        cube([batCT,batCW,batCH+20]);

                    translate([batPX,batY,batZ])
                        cube([20,6,batCH+20], center=true);

                    translate([batPX+contact_thickness(batCType),batY,batZ])
                    scale([1,1,2])
                    rotate([90,0,0])
                        cylinder(h=batCW, d=batCT, center=true);
                                   
                    //N contact
                    translate([batNX-contact_thickness(batCType),batY-batCW/2,batZ-batCH/2])
                        cube([batCT,batCW,batCH+20]);

                    translate([batNX,batY,batZ])
                        cube([20,6,batCH+20], center=true);
                 
                    translate([batNX-contact_thickness(batCType),batY,batZ])
                    scale([1,1,2])
                    rotate([90,0,0])
                       cylinder(h=batCW, d=batCT, center=true);

                }
            }
            
            //BMS
            difference() {
                union() {
                    translate([bmsX-17,bmsY-6,-lEncZ+wallT-1])
                        rounded_cube_xy([34,7,-bmsZ], r=2);
         
                }
                union() {
                    translate([0,standBarY,-lEncZ+2])
                    rotate([0,270,0])
                    linear_extrude(lEncX)
                        polygon(barCutoutProf);
                    
                    translate([bmsX-13,bmsY-5,bmsZ-4])
                        cube([26,10,20]);

                    translate([bmsX-15,bmsY-1.2,bmsZ-4])
                        cube([30,1.2,20]);
                    
                }
            }
            
        }
        //Negative
        union() {
            //PCB
            translate([-standT-wallT-2*gapW,pcbY,-lEncZ+wallT])
            rotate([0,180,0])
            Heltec_T114_cutout();
//            translate([-standT-wallT-2*gapW,pcbY,-lEncZ+wallT])
//            rotate([0,180,0])
//            rounded_cube_xy([50.80,22.86,lEncZ-wallT],r=1);

            translate([0,standBarY,-lEncZ+2])
            rotate([0,270,0])
            linear_extrude(lEncX)
                polygon(barCutoutProf);
            
        }
    }
}
MSNvB_lEnc_stl();

// Lower enclosure
//! 1. Clamp the stand on to the enclosure 
//! 1. Attach the antenna to the enclosure 
//! 2. Connect it to the Heltec T114 board
//! 3. Insert buttons
//! 4. Insert Heltec T114 board
//! 5. Connect and insert the GNSS module (optional)
//! 6. Attach the battery with two zip ties
//! 7. Connect the battery to the Heltec T114 board
module MSNvB_lEnc_assembly() {
    pose([ -70.08, 49.90, 50.00 ], [ 44.50, 0.00, 36.40 ], exploded = true)
    pose([ -70.08, 49.90, 50.00 ], [ 44.50, 0.00, 36.40 ], exploded = false)
    assembly("MSNvB_lEnc") {

        //Li-Ion battery        
        translate([batX,batY,batZ])
        rotate([0,270,0])
            battery(batType);

        translate([batNX,batY,batZ])
        rotate([270, 0, 90])
            battery_contact(batCType, false);

        translate([batPX,batY,batZ])
        rotate([270, 0, 270])
            battery_contact(batCType, true);
            
        //BMS
        translate([bmsX,bmsY,bmsZ])
        rotate([90,0,0])
            LiIonBMS();

        //Antenna
        translate([explode?-24:0,0,0])
        translate([-lEncX+wallT+15,antY,-(lEncRim+lEncZ)/2])
        rotate([0,270,0])
        LoRa_20cm_antenna(wallT, 90);

        //Lower enclosure
        MSNvB_lEnc_stl();

        //Stand
        explode([0,0,-50])
        MSNvB_stand_stl();
        
        //PCB
        explode([0,0,30])
//        translate([-wallT,pcbY,-lEncZ+wallT])
        translate([-standT-wallT-2*gapW,pcbY,-lEncZ+wallT])
        rotate([0,180,0])
        Heltec_T114();
  
        //Buttons
        explode([0,0,20])
        translate([-standT-wallT-2*gapW,pcbY,-lEncZ+wallT])
        rotate([0,180,0])
        MSNvB_buttons_stl();
  
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
//MSNvB_lEnc_assembly();

module MSNvB_top_stl() {
    stl("MSNvB_top");

    //Snap
    translate([-lEncX/2,lEncY/2,0])
    for (a = [0,90,180,270]) {
        rotate([0,0,a])
        hull() {
            for (x = [-lEncX/4,lEncX/4]) {
                $fn = 64;
                translate([x,-lEncY/2+0,-1.6])
                scale([6,2,2]) sphere(d=0.8);
            }
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
*MSNvB_top_stl();

//Node assembly
//! 1. Connect the solar panel to the Heltec T114 board
//! 2. Place the solar panel on the enclosure
//! 3. Attach the top frame
module MSNvB_enc_assembly() {
    pose([ -70.08, 49.90, 50.00 ], [ 44.50, 0.00, 36.40 ], exploded = true)
    pose([ -70.08, 49.90, 50.00 ], [ 44.50, 0.00, 36.40 ], exploded = false)
//    pose([-82, 50, 71], [76, 0, 237])
    assembly("MSNvB_enc") {

     //Lower enclosure
     MSNvB_lEnc_assembly();

     //Solar panel
     explode([0,0,20])   
     translate([-100,0,0]) solar_100x100();

     //Top
     explode([0,0,40])   
     MSNvB_top_stl();
    }
}
//$explode = 1;
//$vpt = [-82, 50, 71];
//$vpr = [76, 0, 237];
//MSNvB_assembly();
  
module MSNvB_cov_stl() {
    stl("MSNvB_cov");

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
*MSNvB_cov_stl();

//Cover assembly
//! Slide on the protective cover for transportation.
module MSNvB_assembly() {
    pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = true)
    pose([ 1.83, 50.00, 71.00 ], [ 55.70, 0.00, 25.90 ], exploded = false)
//    pose([-82, 50, 71], [76, 0, 237])
    assembly("MSNvB") {

     //Enclosure
     MSNvB_enc_assembly();

     //cover
     explode([-0.6*lEncX,0,0])   
     translate([1.2*lEncX,0,0]) MSNvB_cov_stl();
    }
}
//$explode = 1;
//$vpt = [-82, 50, 71];
//$vpr = [76, 0, 237];
//MSNvB_assembly();
  
if($preview) {
//    $vpt = [-82, 50, 71];
//    $vpr = [76, 0, 237];
    $explode = 0;
    MSNvB_lEnc_assembly();
//    MSNvB_enc_assembly();
//    MSNvB_assembly();
}
