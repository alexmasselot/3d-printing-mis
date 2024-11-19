handleLength= 100;
handleDepth = 5;
handleHeight=20;
pivotDepth=15;
axisWidth = 7;
axisLength = 12;
nailDist=4;
nailRadius = 0.5;
nailHeadRadius = 1.5;


n=100;
$fn=n;

function cosh(x) = (exp(x) + exp(-x)) / 2;

function catenary(alpha, tMax, n) = 
    [for (i = [0 : n - 1]) 
        let(t = i * tMax / (n - 1)) 
        [t, alpha * cosh(t / alpha)]
    ];
    
 function normalizePoints(points, factor) = 
    let(
        xMax = max([ for (p = points) p[0]]),
        xMin = min([ for (p = points) p[0]]),
        yMax = max([ for (p = points) p[1]]),
        yMin = min([ for (p = points) p[1]]),
        m = max(xMax-xMin, yMax-yMin)

     )
     [for (p = points) [p[0]-xMin, p[1]-yMin]/m*factor];

function dist(p1, p2) = 
     let (
        v = p2-p1
     )
     sqrt(v[0]*v[0]+v[1]*v[1]);


function mid(p1, p2) = 
    [ for (x = (p2-p1)) x/2]+p1;
     
function angle(p1, p2) = 
    (p2[0]==p1[0])?(90 *sign(p2[1]-p1[1])):atan((p2[1]-p1[1])/(p2[0]-p1[0]));
     
function perpPoint(points, i, dist) = 
     let (
        p = points[i],
        iMax  = len(points)-1,
        pA = (i==0) ? (2*p-points[1]) : points[i-1],
        pB = (i==iMax)? (2*p-points[iMax-1]) : points[i+1],
        v = pB-pA,
        lenV = dist(pA, pB),
        vPerp = [-v[1]/lenV*dist, v[0]/lenV*dist]
     )
     p+vPerp;
     


catPoints = normalizePoints(catenary(0.5, 1.5, n),handleLength);
polyPoints = concat(catPoints, [for (i = [0:n-1]) perpPoint(catPoints, i, handleDepth)]);

pMidTail = mid(polyPoints[0], polyPoints[n]);
radiusMidTail = dist(polyPoints[0], polyPoints[n])/2;
pMidAnchor = mid(polyPoints[n-1], polyPoints[2*n-1]);


rotate([0,0,90-angle(polyPoints[n-1], polyPoints[n-2])])
translate(-polyPoints[n-1]){
    linear_extrude(handleHeight)
        polygon(points=polyPoints, paths = [concat([for(i=[0:n-1]) i], [for (i=[2*n-1:-1:n])i])]);
    translate(pMidTail)
        cylinder(handleHeight, r =radiusMidTail);
}

rotate([0, -90, 0]){
    difference(){
        linear_extrude(pivotDepth)
            square([handleHeight, handleHeight], center=false);
        {
        translate([handleHeight/2, handleHeight/2, handleHeight-axisLength])
            linear_extrude(axisLength+5)
                square([axisWidth, axisWidth], center=true);
        }
        translate([-1, handleHeight/2, pivotDepth-nailDist])
            rotate([0, 90, 0]){
                cylinder(h=handleHeight+2, r=nailRadius);
                cylinder(h=3, r=nailHeadRadius);
            }
    }
}
