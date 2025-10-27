//###############################################################################
//# LoRaMeshNodes - Common Components                                           #
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
//#   Common components which are used throughout this repository.              #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   September 27, 2025                                                        #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <./LMN_Config.scad>
//include <../vitamins/LMN_conduits.scad>
$fn=32;
//Star profile to fit the inside of the antenna pole
//==================================================
module starProfile(type=conduit_M40) {
    
    intersection() {
        union () {
            for (a=[0:45:135]) {
                rotate([0,0,a]) square([4,50], center=true);                
            }
        }
        union () {
            circle(d=conduit_innerD(type));
            
        }
    }    
}
//starProfile();

//NEC2 geometry cards
//===================
//GW - Wire
module nec2GW(cols) {
    tag  = cols[0];       //Tag
    segs = cols[1];       //Number of segments
    x1   = cols[2]*1000;  //First end point
    y1   = cols[3]*1000;  //First end point
    z1   = cols[4]*1000;  //First end point
    x2   = cols[5]*1000;  //Second end point
    y2   = cols[6]*1000;  //Second end point
    z2   = cols[7]*1000;  //Second end point
    r    = cols[8]*1000;  //Wire radius
    
    hull() {
        translate([x1,y1,z1]) sphere(r=r+$slack); 
        translate([x2,y2,z2]) sphere(r=r+$slack); 
    }
}
//nec2GW([0,0,0,0,0,0.02,0.03,0.04,0.004]);

//GH - Helix
module nec2GH(cols) {
    tag  = cols[0];       //Tag
    segs = cols[1];       //Number of segments
    spc  = cols[2]*1000;  //Spacing between turns
    hl   = cols[3]*1000;  //Length of the helix
    a1   = cols[4]*1000;  //Radius in x at z=0
    b1   = cols[5]*1000;  //Radius in y at z=0
    a2   = cols[6]*1000;  //Radius in x at z=hl
    b2   = cols[7]*1000;  //Radius in y at z=hl
    r    = cols[8]*1000;  //Wire radius
 
    turns = hl/spc;
    aoffs = 0;
    aend  = 360*turns;
    step  = 360/$fn;      
    //echo("turns=",turns)
    //echo("aend=",aend)
    //echo("step=",step)
       
    for (a=[aoffs:step:aend-step+aoffs]) {
        xcur = (((a-aoffs)/aend)*(a2-a1)+a1)*cos(a);
        ycur = (((a-aoffs)/aend)*(b2-b1)+b1)*sin(a);
        zcur = ((a-aoffs)/aend)*hl;
        xnxt = (((a+step-aoffs)/aend)*(a2-a1)+a1)*cos(a+step);
        ynxt = (((a+step-aoffs)/aend)*(b2-b1)+b1)*sin(a+step);
        znxt = ((a+step-aoffs)/aend)*hl;
   
        //echo(((a-aoffs)/aend)*(a2-a1)+a1);
        hull() {     
            translate([xcur,ycur,zcur])
            rotate([0,0,a])
                sphere(r=r);
            translate([xnxt,ynxt,znxt])
            rotate([0,0,a+step])
                sphere(r=r);
        }
    }
}
//nec2GH([0,0,0.0045,0.045,0.014,0.016,0.007,0.008,0.0009]);  
    
//GM - Transformation
module nec2GM(cols) {
    tag  = cols[0];       //Tag increment
    nrpt = cols[1];       //Number new structures
    rotx = cols[2];       //Rotation around the X-axis
    roty = cols[3];       //Rotation around the Y-axis
    rotz = cols[4];       //Rotation around the Z-axis
    trnx = cols[5]*1000;  //Translation in X direction
    trny = cols[6]*1000;  //Translation in Y direction
    trnz = cols[7]*1000;  //Translation in Z direction

    if (nrpt == 0) {
        translate([trnx,trny,trnz])
        rotate([rotx,roty,rotz])
            children();
    } else {  
        for (i=[0:nrpt]) {
            translate([i*trnx,i*trny,i*trnz])
            rotate([i*rotx,i*roty,i*rotz])
                children();
        }
    }
}

   