$fn=200;

thickness = 3;
radius = 40;
heightBottom=3;
heightTotal=120;
fixingPlateWidth = 20;
fixingPlateDepth = thickness+3;


spiralBandWidth=7;
spiralNbTurn = 2;
spiralRotationHeight=(heightTotal-spiralBandWidth/1.7)/(spiralNbTurn-0.5);
spiralRadius = radius + thickness /2;
spiralCircleLength = 2*PI*spiralRadius*(spiralNbTurn-0.5);
spiralAngle = atan(spiralRotationHeight/spiralCircleLength );


module screw(){
    screwHeadRadius=4;
    screwThreadRadius=1;
    screwPlateWidth=0.7;
    cylinder(h=3, r1=screwHeadRadius, r2=0);
    translate([0,0,-4]) cylinder(h=4 + screwPlateWidth, r=screwHeadRadius);
    translate([0,0, 1.5]) cylinder(h=20, r=screwThreadRadius);
    
};

/* bottom */

cylinder(h=thickness, r=radius+thickness);


/* bottom border */

translate([0,0,thickness]){
    difference(){
        cylinder(h=heightBottom, r=radius+thickness);
        cylinder(h=heightBottom+1, r=radius);
    }
}


/* fixing plate */

difference(){
    translate([radius-2, -fixingPlateWidth/2, 0]){
            linear_extrude(height = heightTotal-2)
            square([fixingPlateDepth, fixingPlateWidth]);
    };
    {
        translate([0,0,-5])   cylinder(h=heightTotal+10, r=radius);
        translate([radius,0,heightTotal/5]) rotate([0,90,0])screw();
        translate([radius,0,heightTotal*4/5]) rotate([0,90,0])screw();
    }
}


difference(){
    for(h=[0:1:spiralBandWidth]){
        translate([0,0,h])
        rotate([0,0,180]) {
            linear_extrude(height = heightTotal-spiralBandWidth, center = false, convexity = 10, twist = 360*spiralNbTurn-180)
            translate([spiralRadius, 0, 0])
            square([thickness+2, spiralBandWidth], center=true);
            
            linear_extrude(height = heightTotal-spiralBandWidth, center = false, convexity = 10, twist = -(360*spiralNbTurn-180))
            translate([spiralRadius, 0, 0])
            square([thickness+2, spiralBandWidth], center=true);
        }
    }
    /* polish inside and outside */
    {
      translate([0,0,-5])cylinder(h=heightTotal+10, r=radius);

      difference(){
        translate([0,0,-5])cylinder(h=heightTotal+10, r=radius+100);
        translate([0,0,-10])cylinder(h=heightTotal+20, r=radius+thickness);

      }
      translate([0,0,-50]) cylinder(h=50, r=radius+thickness+5);
      translate([0,0, heightTotal]) cylinder(h=50, r=radius+thickness+5);
    }

}
/* closing properly the top of the fixing plate */
difference(){
    {
        yTop=fixingPlateWidth/2*heightTotal/spiralCircleLength;
        translate([radius-2, 0, heightTotal-2])
        rotate([90,0,90]) 
        linear_extrude(height=fixingPlateDepth) 
        polygon(points= [[0,yTop], [-fixingPlateWidth/2, 0], [fixingPlateWidth/2, 0]]);
        echo([[0,yTop], [-fixingPlateWidth/2, 0], [fixingPlateWidth/2, 0]]);
    }
    translate([0,0,-5])cylinder(h=heightTotal+10, r=radius);

}
/*
difference(){
    for( alpha = [0:360/$fn:(360*spiralNbTurn-180)]){
        rotate([0,0,alpha+180]){
            translate([spiralRadius, 0, alpha/360*spiralRotationHeight]){
                rotate([spiralAngle, 0,0]){
                    linear_extrude(height = spiralBandWidth)
                        square([thickness, 20], center=true);
                }
            }
        }
        rotate([0,0,-alpha-180]){
            translate([spiralRadius, 0, alpha/360*spiralRotationHeight]){
                rotate([-spiralAngle, 0,0]){
                    linear_extrude(height = spiralBandWidth)
                    square([thickness, 20], center=true);
                }
            }
        }

    }
    {
      translate([0,0,-5])cylinder(h=heightTotal+10, r=radius);

      difference(){
        translate([0,0,-5])cylinder(h=heightTotal+10, r=radius+100);
        translate([0,0,-10])cylinder(h=heightTotal+20, r=radius+thickness);

      }
      translate([0,0,-50]) cylinder(h=50, r=radius+thickness+5);
      translate([0,0, heightTotal]) cylinder(h=50, r=radius+thickness+5);
    }
}
*/