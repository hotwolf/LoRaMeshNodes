//###############################################################################
//# LoRaMeshNodes - Statc Solar Node Variant A - Scruton Helix                  #
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
//#   A Scruton helix for Static Solar Node variant A.                          #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   October 6, 2025                                                           #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
include <LMN_Config.scad>

//Scruton helix for the antenna pole
//==================================
module scruton(type=conduit_M40) {

    wallT  =  0.4;                     //wall thickness
    poleD  = conduit_outerD(type)+0.4; //pole diameter
    outerD = 60;                       //outer diameter
    pitch  = 4*poleD;                  //pitch
    segH   = pitch;                    //segment height
    segCnt = 1;                        //number of segments
    $fn    = 256;
    
    difference() {
        union() {
             translate([0,0,0]) cylinder(h=segCnt*segH, d=poleD+2*wallT);            
           
             linear_extrude(height=segCnt*segH, twist=segCnt*360 )
             translate([0,0,0]) square([outerD,2*wallT],center=true);
            
        }
        union() {
            translate([0,0,-10]) cylinder(h=segCnt*segH+20, d=poleD);            
        }
    }
}
//scruton();

module SSNvA_scrutonM40_stl() {
    vitamin("SSNvA_scrutonM40");
    scruton(conduit_M40);
}
//SSNvA_scrutonM40_stl();

if($preview) {    
   *SSNvA_scrutonM40_stl();
}
