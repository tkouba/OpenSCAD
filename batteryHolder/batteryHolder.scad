/**************************************************************
 * Parametric battery holder version 1            (2023-05-03)*
 * Copyright (c) Tomas "Arci" Kouba, 2023                     * 
 * ---------------------------------------------------------- *
 * Licensed under terms of the                                *
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0  *
 * International (CC BY-NC-SA 4.0) license                    *
 * ---------------------------------------------------------- *
 * History:                                                   *
 *  1.0 (2023-05-03):                                         *
 *    * Created                                               *
 **************************************************************/
 

// Default values are for Makita 18V
/*[Model]*/
// Create test shape instead on holder
type = "holder"; // [holder, dimensioned, test]
/*[Battery]*/
// Battery total width
batteryWidth = 75;
// Width of battery lock rails
holderWidth = 63;
// Height if battery lock rails
holderHeight = 16;
// Length of battery lock rails
holderLength = 45;
// Nose under lock rails height
noseHeight = 5;
// Nose under lock rails 
noseWidth = 4;
/*[Holes]*/
// Hole size for srew Mx
holeSize = 3; // [3,4,5]
// Number of holes
holes = 2; // [1,2]
/*[Base]*/
baseHeight = 8;
bevel = 1;

/*[Hidden]*/
$fudge = 0.01;

$fn = $preview ? $fn : 64;

holderWall = (batteryWidth - holderWidth) / 2;
screwHoleSizes = [
  //[hole diameter, d2, k max]
  [3.2, 6.2, 1.7],
  [4.2, 8.2, 1.9],
  [5.2, 10.3, 2.4]
];
battPoly = [
  [0, 0],
  [batteryWidth, 0],
  [batteryWidth, baseHeight + holderHeight - bevel],
  [batteryWidth - bevel, baseHeight + holderHeight],
  [batteryWidth - holderWall - noseWidth + bevel, baseHeight + holderHeight],
  [batteryWidth - holderWall - noseWidth, baseHeight + holderHeight - bevel],
  [batteryWidth - holderWall - noseWidth, baseHeight + holderHeight - noseHeight + bevel],
  [batteryWidth - holderWall - noseWidth + bevel, baseHeight + holderHeight - noseHeight],
  [batteryWidth - holderWall, baseHeight + holderHeight - noseHeight],
  [batteryWidth - holderWall, baseHeight],
  [holderWall, baseHeight],
  [holderWall, baseHeight + holderHeight - noseHeight],
  [holderWall + noseWidth - bevel, baseHeight + holderHeight - noseHeight],
  [holderWall + noseWidth, baseHeight + holderHeight - noseHeight + bevel],
  [holderWall + noseWidth, baseHeight + holderHeight - bevel],
  [holderWall + noseWidth - bevel, baseHeight + holderHeight],
  [bevel, baseHeight + holderHeight],
  [0, baseHeight + holderHeight - bevel],
];

if (type == "test") {
  linear_extrude(3) polygon(battPoly);
}
if ((type == "holder") || (type == "dimensioned")) {
  difference(){
    linear_extrude(holderLength) polygon(battPoly);
    for (i = [1:1:holes])
      translate([batteryWidth/(holes+1)*i, baseHeight+$fudge, holderLength/2])
        rotate([90,0,0]){
          screwHole(
            screwHoleSizes[holeSize-3][0],
            screwHoleSizes[holeSize-3][1],
            screwHoleSizes[holeSize-3][2],
            baseHeight + 2*$fudge);
        }
  }
  if (type == "dimensioned" && $preview) {
    translate([0, 0, holderLength])
      rotate([-90,0,0]) measurement_line(batteryWidth, "batteryWidth", spacer = 10);
    translate([holderWall, baseHeight + 2, holderLength])
      rotate([-90,0,0]) measurement_line(holderWidth, "holderWidth", direction="dn", spacer = 1);    
    translate([0, baseHeight, holderLength])
      rotate([-90,0,90]) measurement_line(holderHeight, "holderHeight", direction="dn", spacer = 10);
    translate([batteryWidth - holderWall - noseWidth, baseHeight + holderHeight - noseHeight, holderLength])
      rotate([-90,0,90]) measurement_line(noseHeight, "noseHeight", direction="dn", spacer = 10, halign = "left");    
    translate([holderWall, baseHeight + holderHeight, holderLength])
      rotate([-90,0,0]) measurement_line(noseWidth, "noseWidth", direction="dn", spacer = 10);    
    rotate([0,-90,0]) measurement_line(holderLength, "holderLength", direction="dn", spacer = 10);        
  }
}


module screwHole(d1, d2, k, l)
{
  union() {
    cylinder(h=k,d1=d2,d2=d1);
    cylinder(h=l,d=d1);
  }
}

module measurement_line(length,text,direction="up",spacer=10,line_thickness=0.2,halign="center")
{
	color("Black")
	{ 
    translate([0,0, direction=="up" ? -spacer : spacer])
      cube([length,line_thickness,line_thickness]);
		translate([0,0, direction=="up" ? -spacer-1 : 0]) 
			cube([line_thickness,line_thickness,spacer+1]);
		translate([length-line_thickness,0,direction=="up" ? -spacer-1 : 0 ]) 
			cube([line_thickness,line_thickness,spacer+1]);

		translate([length/2,0,direction=="up" ? -spacer+1 : spacer+1]) rotate([90,0,0]) 
			text(str(text,"=", length),size=2, halign=halign, valign = "bottom");
	}
}