/**************************************************************
 * DIN RAIL OBJECTS version 1.0 (2022-09-21)                  *
 * Copyright (c) Tomas "Arci" Kouba, 2022                     *
 * ---------------------------------------------------------- *
 * Licensed under terms of the                                *
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0  *
 * International (CC BY-NC-SA 4.0) license                    *
 **************************************************************/

// OpenSCAD model of DIN rail
//DIN_Rail(x = 100, holes = true);
module DIN_Rail(x = 10, holes = false) {
  t = 1; /* DIN Rail thickness */
  r = 0.8; /* DIN Rail inner round */
  a = 35;
  b = 25;
  c = 7.5;
  difference() {
    rotate([90,0,90]) {
      linear_extrude(height=x) {
        difference(){
          square([a,c]); 
          translate([(a-b)/2,t]) { 
            hull() {
              translate([r,r])
                circle(r, $fn = 16);        
              translate([0,c-t-r])
                square(r);
              translate([b-r,c-t-r])
                square(r);
              translate([b-r,r])
                circle(r, $fn = 16);
            }
          }
          hull() {
            square(r);
            translate([0,c-t-r])
              square(r);
            translate([(a-b)/2-r-t,c-t-r])
              circle(r, $fn = 16);
            translate([(a-b)/2-r-t,0])
              square(r);
          }
          translate([(a-b)/2+b+t,0]) {
            hull() {
              square(r);
              translate([r,c-t-r])
                circle(r, $fn = 16);
              translate([(a-b)/2-r-t,c-t-r])
                square(r);
              translate([(a-b)/2-r-t,0])
                square(r);
            }
          }
          translate([r+t+(a-b)/2-t,r+t]) {
            difference() {
              translate([-r-t,-r-t])
                square(r+t);
              circle(r+t, $fn = 16); 
            }
          }
          translate([(a-b)/2+b-r,r+t]) {
            difference() {
              translate([0,-r-t])
                square(r+t);
              circle(r+t, $fn = 16); 
            }
          }
          translate([(a-b)/2+b+r+t,c-r-t]) {
            difference() {
              translate([-2*t,0])
                square(2*t);
              circle(r+t, $fn = 16); 
            }
          }
          translate([(a-b)/2-t-r,c-r-t]) {
             difference() {        
              square(2*t);
              circle(r+t, $fn = 16); 
            }
          }
        } 
      }
    }
    if (holes) {
      translate([0,a/2,0])
        DIN_Rail_Holes(length = x);
    }
  }
}

// Helper module for DIN rail holes
//DIN_Rail_Holes();
module DIN_Rail_Holes(t = 1, length = 100) {
  a = 18;
  b = 25;
  d = 5.2;
  intersection() {
    translate([0,-d/2,0])
      cube([length,d,t]);
    for(i = [0:b:length]) {
      echo(i);
      translate([i-a/2+d/2,0,0])
      hull() {
        cylinder(h = t, d = d);
        translate([a-d,0,0])
          cylinder(h = t, d = d);
      }
    }
  }
}


// Simple DIN rail clip without base
// Original: https://gist.github.com/mprymek/cfc0b6979d5cefa8eac7e2f9fb66a6f2 
//DIN_Rail_Clip(6, n = 0);
module DIN_Rail_Clip(z = 6 /* Z thickness */,
  a = 7 /* Clip width (from rail) */,
  k = 25 /* Nose first part height */,
  l = 0 /* DIN rail spacer (max 5.5) */, 
  m = 2 /* Nose step */,
  n = 10 /* Nose second part height */) {
    // a
    b = 1.2; // metal sheet thickness, should be ~ 1
    c = 2.5; // Nose thickness
    d = 4;
    e = 2.5; // Depends on f
    f = 4.5; // Depends on e
    g = 4;
    h = 13; // Should be 13, but with 13.3
    i = 1.5;
    j = 2;
    // k    
    // l    
    // m
    // n

    //echo("this should be 35 ... ", e+f+g+h+g+f+e);

    linear_extrude(height=z)
    polygon(points=[
        [j+e+f+g+h+g+f+e+d, 0],
        [j+e+f+g+h+g+f+e+d, a+b+c],
        [j+e+f+g+h+g+f, a+b+c],
        //[j+e+f+g+h+g+f, a+b],
        [j+e+f+g+h+g+f, a+b+(c/4)],
        [j+e+f+g+h+g+f+e, a+b],
        [j+e+f+g+h+g+f+e, a],
        [j+e+f+g+h+g, a],
        [j+e+f+g+h+g, a+l],
        [j+e+f+g+h, a+l],
        [j+e+f+g+h, a],
        [j+e+f+g, a],
        [j+e+f+g, a+l],
        [j+e+f, a+l],
        [j+e+f, a],
        [j+i, a],
        [j+i, 0],
        [j, 0],
        [j, a+b],
        [j+e, a+b],
        [j+e, a+b+(c/3)],
        [j, a+b+c],
        [-k, a+b+c],
        //[-k, a+b],
        [-k, a+b+c-m],
        [-k-n, a+b+c-m],
        [-k-n, a+b-m],
        [-k+c, a+b-m],
        [-k+c, a+b],
        [0, a+b],
        [0, 0]
    ]);

    // demo base
    //translate([-3,-3,0]) cube([3+j+e+f+g+h+g+f+e+d+3, 3, z]);
}
