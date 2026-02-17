//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant B - Mounts and Caps                #
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
//#   Mounts and end caps.                                                      #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   February 13, 2026                                                         #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

include <LMN_Config.scad>

solarZ = 10;                     //Mounting height of the solar panels
condT  = conduit_DN75;           //Conduit type
outerD = conduit_outerD(condT);  //Outer diameter of the conduit
innerD = conduit_innerD(condT);  //Inner diameter of the conduit
$fn    =128;

*#translate([0,0,-20]) cylinder(h=40, d=innerD);

module femaleThread(condT=condT,l=40,d=innerD,top=0,bot=0) { 
    outerD         = conduit_innerD(condT);  //Outer diameter of the conduit
    threadPitch    = 4;
    
    intersection() {
        thread(dia     = d-1, 
               pitch   = threadPitch, 
               length  = l, 
               profile = thread_profile(threadPitch / 2.2, threadPitch * 0.25, 60),
               center  = false, 
               top     = top, 
               bot     = bot, 
               starts  = 1, 
               solid   = true, 
               female  = true);              
        translate([0,0,-1])
           cylinder(h=l+2, d=d);
    } 

    difference() {
        cylinder(h=l, d=d);
        translate([0,0,-1])
           cylinder(h=l+2, d=innerD-0.6); 
    }
}
*clip(xmin=0)
femaleThread(l=15,top=-1);

module maleThread(condT=condT,di=64,do=innerD,l=40,top=0,bot=0) { 
    outerD         = conduit_outerD(condT);  //Outer diameter of the conduit
    threadPitch    = 4;
    difference() {
        thread(dia     = do-5.4, 
               pitch   = threadPitch, 
               length  = l, 
               profile = thread_profile(threadPitch / 2.2, threadPitch * 0.25, 60),
               center  = false, 
               top     = top, 
               bot     = bot, 
               starts  = 1, 
               solid   = true, 
               female  = false);              
         if (di>0) {
             translate([0,0,-1])
             cylinder(h=l+2, d=di);
         }
     }
}
*clip(xmin=0)
maleThread();

module zigzagDisk(flip=false) {
    
    segments = 36;
    a        = 360/segments;
    h        = 4;
    r        = innerD/2-4;        
    points   = [[0         ,0         , 0],    // 0
                [r         ,0         ,-h/2],  // 1
                [r*cos(a/2),r*sin(a/2), h/2],  // 2
                [r*cos(a)  ,r*sin(a)  ,-h/2]]; // 3
    faces    = [[0,2,1],
                [0,3,2], 
                [0,1,3],
                [1,2,3]];
   
   rotate([flip?180:0,0,flip?a/2:0]) {    
        for (rz=[0:a:360-a]) {
            rotate([0,0,rz])
                polyhedron(points, faces);
        }
        
        translate([0,0,-h/2])
            cylinder(h=h/2,r1=r,r2=0,$fn=segments);
        translate([0,0,-h/2-3])
            cylinder(h=3,r=r,$fn=segments);
    }
}
*zigzagDisk();
*zigzagDisk(true);

//Upper end cap
module SSNvB_uEndcap_stl() {
     stl("SSNvB_uEndcap");

    //Thread
    rotate([180,0,0])
    translate([0,0,-1])
        maleThread(l=13,top=-1);
    
    //Cap
    rotate_extrude() {        
        polygon([[         0  , 1],
                 [        30  , 1],
                 [        32  ,-1],
                 [        32  , 1],
        
        
                 [outerD/2+0.2, 1],
                 [outerD/2+0.2,-1],
                 [outerD/2+1  ,-1],
                 [outerD/2+1  , 3],
                 [outerD/2    , 4],
                 [         0  , 4]]);
    }
}
//clip(xmin=0)
*SSNvB_uEndcap_stl();

//Lower end cap
module SSNvB_lEndcap_stl() {
     stl("SSNvB_lEndcap");

    //Thread
    translate([0,0,-1])
        maleThread(l=13,top=-1);

    //Cap
    translate([0,0,0])
    rotate_extrude() {        
        polygon([[         0,-4],
                 [outerD/2-1,-4],
                 [outerD/2  ,-3],
                 [outerD/2  ,-1],
                 [      32  ,-1],
                 [      15.8,-1],
                 [      15.8, 1],
                 [       0  , 1],
                 [       0, -1]]);
    }

    //Dome
    translate([0,0,1])
    clip(zmin=0)
        sphere(d=31.6);
}
*clip(xmin=0)
SSNvB_lEndcap_stl();

//End cap thread
module SSNvB_EndcapThread_stl() {
     stl("SSNvB_EndcapThread");
   
     //Thread
     translate([0,0,-1])
        femaleThread(l=13,bot=-1);
    
     //Ring
     difference() {
         translate([0,0,-1])
             cylinder(h=1, d=outerD);
         translate([0,0,-2])
             cylinder(h=3, d=innerD);
     }
}
*clip(xmin=0)
//rotate([180,0,0])
SSNvB_EndcapThread_stl();

//Antenna mount thread
module SSNvB_antennaMountThread_stl() {
    stl("SSNvB_antennaMountThread");

    difference() {
       //Positive
       union() { 

            //Thread
            translate([0,0,5])
                femaleThread(l=10,d=innerD-10,top=-1);
        
            //Outer ring
            difference() {
                //Positive
                hull() {
                    translate([0,0,-5])
                        cylinder(h=20,d=innerD-10);            
               
                    translate([0,0,-5])
                        cylinder(h=18,d=innerD);                        
                }
                //Negative
                 translate([0,0,-10])
                    cylinder(h=40,d=innerD-11);                       
             }
            
            //Inner ring
            difference() {
                //Positive
                translate([0,0,-5])
                     cylinder(h=10,d=innerD);
                //Negative
                union() {
                    translate([0,0,-10])
                        cylinder(h=40,d=innerD-16);  
                    hull() {
                        translate([0,0,4])
                            cylinder(h=1,d=innerD-16);  
                        translate([0,0,5])
                            cylinder(h=1,d=innerD-15);  
                    }
                }        
            }
            
            //Zigzag ring  
            difference() {
                //Positive
                zigzagDisk();        
            //Negative
             translate([0,0,-10])
                cylinder(h=40,d=38);                       
            }
    
        }      
       //Negtive
       union() { 
           for(a=[0:30:360]) {
               rotate([0,0,a])
               translate([innerD/2,0,-10])
                   cylinder(h=40,d=10);
           }
       }
   }
}
*clip(xmin=0)
SSNvB_antennaMountThread_stl();

//Antenna mount fastener
module SSNvB_antennaMountFastener_stl() {
    stl("SSNvB_antennaMountFastener");

    translate([0,0,5])
        maleThread(l=10,do=innerD-10,di=54,bot=-1);

    difference() {
        union() {
            translate([0,0,5])
                cylinder(h=3, d=55);   

            translate([0,0,4])
                cylinder(h=1,d1=52,d2=54);   
          
            for (rz=[0:120:240]) {
                rotate([0,0,rz])
                    translate([0,0,10])
                        cube([55,2,10],center=true);
            }
        }
        union() {
           translate([0,0,-10]) 
                cylinder(h=40, d=24);                    
           translate([0,0,13]) 
                cylinder(h=3, d1=24,d2=30);                    
        }
    }
}
*clip(xmin=0)
SSNvB_antennaMountFastener_stl();
 
//Enclosure mount
module SSNvB_encMount_stl() {
    stl("SSNvB_encMount");

    w=20;
    connectorShape=[[ 0, 4],
                    [ 6, 2],   
                    [ 6,-2],   
                    [ 0,-4]];    

    difference() {
        //Positive
        union() {
            hull() {
                translate([-w/2,outerD/2-10,0])
                    rounded_cube_yz([w,10,140],r=4);
                translate([-w/2,outerD/2-10,0])
                    rounded_cube_yz([w,20,130],r=4);
                translate([-w/2,outerD/2-10,0])
                    cube([w,20,10]);
            }
            
            translate([0,outerD/2+4.5,0])
            rotate([0,90,0])
            linear_extrude(w/2) offset(r=-0.1) polygon(connectorShape);
                    
        }
        //Negative
        union() {            
            cylinder(h=400,d=outerD, center=true);
            
            translate([0,outerD/2+4.5,0])
            rotate([0,270,0])
            linear_extrude(w/2+1) offset(r=0.1) polygon(connectorShape);
      
            for (z=[20:40:100]) {
                translate([-20,outerD/2+1.4,z])            
                    rounded_cube_yz([40,6,20],r=2);
            }
        }
    }
}
SSNvB_encMount_stl();

//Optional cable guide
module SSNvB_cableGuide_stl() {
   stl("SSNvB_cableGuide");
 
    difference() {
       //Positive
       union() {            
            hull() {
            translate([0,0,0])
                cylinder(h=8,d=innerD);            
            translate([0,0,0])
                cylinder(h=10,d=innerD-2);                        
             translate([0,0,10])
                cylinder(h=4,d1=innerD-2,d2=10);                        
           }
        }      
       //Negtive
       union() { 
           
           translate([0,0,-10])
               cylinder(h=40,d=37); 

            hull() {
                translate([0,0,10])
                    cylinder(h=1,d=37);  
                translate([0,0,12])
                    cylinder(h=1,d=39);  
            }
       
           for(a=[0:30:360]) {
               rotate([0,0,a])
               hull() {
                   translate([innerD/2,0,-10])
                       cylinder(h=40,d=10);
                   translate([innerD/2-5,0,-10])
                       cylinder(h=40,d=10);                   
               }
           }
       }
   }    
}
*SSNvB_cableGuide_stl();    
    
if($preview) {    

}
