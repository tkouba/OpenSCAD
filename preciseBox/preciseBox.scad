/**************************************************************
 * PARAMETRIC PRECISE BOX version 1.5    (2022-02-24)         *
 * Copyright (c) Tomas "Arci" Kouba, 2021                     *
 * ---------------------------------------------------------- *
 * Licensed under terms of the                                *
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0  *
 * International (CC BY-NC-SA 4.0) license                    *
 * ---------------------------------------------------------- *
 * History:                                                   *
 *  1.6 (2022-03-10):                                         *
 *    * Add variable divider of box                           *
 *  1.5 (2022-02-24):                                         *
 *    * Add optional text on top part                         *
 *  1.4 (2021-08-31):                                         *
 *    * Fixed depth internal size calculation                 *
 *  1.3 (2021-08-26):                                         *
 *    * Add rounded interrior                                 *
 *  1.2 (2021-08-24):                                         *
 *    * Add external/internal dimensions switch               *
 *    * Add finger gap                                        *
 *  1.1 (2021-03-19):                                         *
 *    * Better/bigger rounded corners                         *
 *    * Fixed bottom part wall Z translation                  *
 *    * Simplified subtracted interiors                       *
 *  1.0 (2021-03-16):                                         *
 *    * Created                                               *
 **************************************************************/

// Preview
main();

/* [Box sizes] */
// Box width (external or internal dimension)
width = 40; // [10:1:200]
// Box height (external or internal dimension)
height = 30; // [10:1:200]
// Box depth (external or internal dimension)
depth = 10; // [5:1:200]
// Dimensions is external (true) or internal (false)
isExternal = true;
// Divide bottom/top (height percent)
divider_percent = 0; // [0:5:90]

/* [Finger gap] */
// Add finger gap
fingerGap = false;
// Finger gap size (25 mm is approx 1 inch)
fingerGapSize = 25; // [5:1:40]

/* [Round corners] */
// Use rounded exterior corners?
rounded = true;
// Corner radius of interrior
interrior_radius = 0; // [0:10]

/* [Texts] */
// Use text on top part
useTextOnTop = false;
// Text on top part
textOnTop = "Some text";
// Size of text on top part
textOnTopSize = 3; // [1:1:15]
// Depth of text on top part
textOnTopDepth = 0.15; // [0.1:0.01:0.4]

/* [Options] */
// Wall thickness (2 lines for small boxes)
wt = .86; // [0.4:.01:2]
// Lid tolerance (space between walls of bottom and top part)
lt = .1; // [0.05:.01:0.5]

/* [Render part] */
// Top part
topPart = true;
// Bottom part
bottomPart = true;

/* [Hidden] */
// Top tolerance (top space between botom walls and roof)
tt = .4;
// Inner round (manipulation enhancement)
ir = max(.4, wt / 2);
// Better rounds
$fn = $preview ? $fn : 20; 
// External dimensions (computed)
_width = isExternal ? width : width + 4 * wt + 2 * lt;
_height = isExternal ? height : height + 4 * wt + 2 * lt;
_depth = isExternal ? depth : depth + 4 * wt;
// minimal divider is 2*wt (bottom wall thickness)
// maximal divider is less than 2*wt bellow bottom part
_divider = min(max(2 * wt, _depth * 0.01 * divider_percent), _depth - 4*wt);

module main() {
  if (bottomPart) translate([0, 5, 0]) part_bottom();
  if (topPart) translate([0, 0 - height - 5, 0]) part_top();
}

module part_bottom() {
  difference(){
    union() {
      if (rounded) {
        r_cube([_width, _height, _divider], wt);
      }
      else {
        cube([_width, _height, _divider]);
      }
      translate([wt + lt, wt + lt, 0]) 
        r_cube([_width - 2 * wt - 2 * lt, _height - 2 * wt - 2 * lt, _depth - 2 * wt - tt], ir, false, false);
    }
    // Comparment hole
    translate([2 * wt + lt, 2 * wt + lt, 2 * wt]) 
      r_cube([_width - 4 * wt - 2 * lt, _height - 4 * wt - 2 * lt, _depth - 4 * wt], interrior_radius, true, false);
    if (fingerGap) {
      union() {
        translate([6 * wt + lt + fingerGapSize / 2, 0, 2 * wt + fingerGapSize / 2])
          rotate([-90, 0, 0])
            cylinder(d = fingerGapSize, h = _height); // Gap cylinder
        translate([6 * wt + lt, 0, 2 * wt + fingerGapSize / 2])
          cube([fingerGapSize, _height, _depth - (4 * wt + lt + fingerGapSize / 2)]);
      }
    }
  }
}

module part_top() {
  difference(){
    if (rounded) {
      r_cube([_width, _height, _depth - _divider], wt);
    }
    else {
      cube([_width, _height, _depth - _divider]);
    }
    translate([wt, wt, 2 * wt]) 
      cube([_width - 2 * wt, _height - 2 * wt, _depth]);
    if (useTextOnTop) {
      translate([wt + _width / 2, wt + _height / 2, 0])
        linear_extrude(textOnTopDepth)
          mirror([1, 0, 0])
            text(textOnTop, size = textOnTopSize, 
              halign = "center", valign = "center");
    }
  }    
}


// Helper module for rounded cube
module r_cube(size, radius, bottom_round = true, top_round = false) {
  if(radius == 0) {
    // Do simple cube
    cube(size);
  } else {
    // Do rounded corners
    points = [
      [radius, radius], 
      [size[0] - radius, radius],
      [size[0] - radius, size[1] - radius],
      [radius, size[1] - radius]
    ];
    hull() {
      translate([0, 0, radius]) 
      for(pos = points) {
        translate(pos) {
          if (bottom_round) 
            sphere(r = radius); 
          else 
            cylinder(r = radius, h = tt);
        }
      }
      translate([0, 0, size[2] - (top_round ? radius : tt)]) 
      for(pos = points) {
        translate(pos) {
          if (top_round) 
            sphere(r = radius); 
          else {
            cylinder(r = radius, h = tt);
          }
        }
      }
    }
  }
}
