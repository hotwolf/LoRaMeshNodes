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

module SN_scrutonM40_stl() {
    vitamin("SN_scrutonM40");
    scruton(conduit_M40);
}
//SN_scrutonM40_stl();

//Battery holder for a 32700 LiFePo4 cell
//=======================================



