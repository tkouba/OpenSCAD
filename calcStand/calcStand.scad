
/*[Stand]*/
// Calculator width
calcWidth = 147; //[10:1:200]
// Calculator height
calcHeight = 150; //[10:1:200]
// Stand height
standHeight = 47; //[5:1:70]
// Stand corner radius
cornerRadius = 7; //[1:1:10]

/*[Interrior]*/
interriorWidth = 80; //[0:5:200]
interriorHeight = 80; //[0:5:200]

/*[Text]*/
// Text
textContent = "Calculator stand";
// Text size
textSize = 5; //[5:1:15]
// Text depth
textDepth = 0.4; //[0.1:0.1:1]
// Text bottom position
textBottom = 20; //[0:1:150]

/*[Barrier]*/
// Barrier bottom position
barrierBottom = 10; //[0:1:25]
// Barrier top position
barrierTop = 0; //[0:1:25]
// Barrier left position
barrierLeft = 3; //[0:1:25]
// Barrier right position
barrierRight = 3; //[0:1:25]
// Barrier width
barrierWidth = 1; //[0.2:0.1:3]
// Barrier height
barrierHeight = 3; //[0.2:0.2:5]

/*[Other]*/
// Wall thickness
wt = 0.3; //[0.2:0.1:2]



/*[Hidden]*/
$fn = $preview ? $fn : 32;

width = calcWidth + (barrierBottom == 0 ? barrierWidth : 0) + (barrierTop == 0 ? barrierWidth : 0);
height = calcHeight + (barrierLeft == 0 ? barrierWidth : 0) + (barrierRight == 0 ? barrierWidth : 0);
a = 90 - acos(standHeight/height);
wBottom = (barrierBottom == 0 ? barrierWidth/2 : barrierBottom + barrierWidth/2);
wTop = (barrierTop == 0 ? barrierWidth/2 : barrierTop + barrierWidth/2);
wLeft = (barrierLeft == 0 ? barrierWidth/2 : barrierLeft + barrierWidth/2);
wRight = (barrierRight == 0 ? barrierWidth/2 : barrierRight + barrierWidth/2);

main();



module main(){
  difference() {
    union() {
      hull() {
        linear_extrude(wt)
        {
          r_square([width, height], cornerRadius);
        }
        rotate([a, 0, 0])
          linear_extrude(wt)
            r_square([width, height], cornerRadius);          
      }
      rotate([a, 0, 0]) {
        hull() {
          translate([(wBottom >= cornerRadius) ? wLeft : max(wLeft, cornerRadius + barrierWidth), wBottom, barrierHeight-barrierWidth/2]) sphere(d=barrierWidth);
          translate([(wBottom >= cornerRadius) ? wLeft : max(wLeft, cornerRadius + barrierWidth), wBottom, 0]) cylinder(h=wt,d=barrierWidth);
          translate([(wBottom >= cornerRadius) ? width - wRight : min(width - wRight, width - cornerRadius - barrierWidth), wBottom, barrierHeight-barrierWidth/2]) sphere(d=barrierWidth);
          translate([(wBottom >= cornerRadius) ? width - wRight : min(width - wRight, width - cornerRadius - barrierWidth), wBottom, 0]) cylinder(h=wt,d=barrierWidth);
        }
        hull() {
          translate([width - wRight, max(wBottom, cornerRadius - barrierWidth), barrierHeight-barrierWidth/2]) sphere(d=barrierWidth);
          translate([width - wRight, max(wBottom, cornerRadius - barrierWidth), 0]) cylinder(h=wt,d=barrierWidth);
          translate([width - wRight, min(height - wTop, height - cornerRadius - barrierWidth), barrierHeight-barrierWidth/2]) sphere(d=barrierWidth);
          translate([width - wRight, min(height - wTop, height - cornerRadius - barrierWidth), 0]) cylinder(h=wt,d=barrierWidth);
        }
        hull() {
          translate([wLeft, max(wBottom, cornerRadius - barrierWidth), barrierHeight-barrierWidth/2]) sphere(d=barrierWidth);
          translate([wLeft, max(wBottom, cornerRadius - barrierWidth), 0]) cylinder(h=wt,d=barrierWidth);
          translate([wLeft, min(height - wTop, height - cornerRadius - barrierWidth), barrierHeight-barrierWidth/2]) sphere(d=barrierWidth);
          translate([wLeft, min(height - wTop, height - cornerRadius - barrierWidth), 0]) cylinder(h=wt,d=barrierWidth);
        }
        hull() {
          translate([max(wLeft, cornerRadius + barrierWidth), height - wTop, barrierHeight-barrierWidth/2]) sphere(d=barrierWidth);
          translate([max(wLeft, cornerRadius + barrierWidth), height - wTop, 0]) cylinder(h=wt,d=barrierWidth);
          translate([min(width - wRight, width - cornerRadius - barrierWidth), height - wTop, barrierHeight-barrierWidth/2]) sphere(d=barrierWidth);
          translate([min(width - wRight, width - cornerRadius - barrierWidth), height - wTop, 0]) cylinder(h=wt,d=barrierWidth);
        }
      }
    }
    if (interriorWidth > 0 && interriorHeight > 0) {
      hull() {
          linear_extrude(wt)
          {
             translate([(width - interriorWidth) / 2, (height - interriorHeight) / 2])
              r_square([interriorWidth, interriorHeight], cornerRadius);
          }
          rotate([a, 0, 0])
            linear_extrude(wt)
              translate([(width - interriorWidth) / 2, (height - interriorHeight) / 2])
                r_square([interriorWidth, interriorHeight], cornerRadius);
      }
    }
    rotate([a, 0, 0]) {
      translate([width / 2, textBottom, wt - textDepth]) {
        linear_extrude(2*textDepth)
          text(textContent, size=textSize, halign="center", valign="center");    
      }
    }
  }
}

module r_square(size = [1, 1], radius = 0) {
  if (radius == 0)
    square(size, false);
  else {
    x = size[0];
    y = size[1];
    hull() {
      translate([radius, radius, 0]) circle(radius);
      translate([x - radius, radius, 0]) circle(radius);
      translate([x - radius, y - radius, 0]) circle(radius);
      translate([radius, y - radius, 0]) circle(radius);
    }
  }
}
