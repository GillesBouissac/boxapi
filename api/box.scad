//
// Author:     Gilles Bouissac
// Descripion: Boxes (box) API
// 
// History:
//     2016-12-30: API V001 released on thingiverse
//     2017-05-25: API V001 released on github
//

// Conventions
//  - right of the box is the face which center X position is the highest
//  - left of the box is the face which center X position is the lower
//  - top of the box is the face which center Z position is the highest
//  - bottom of the box is the face which center Z position is the lower
//  - back of the box is the face which center Y position is the highest
//  - front of the box is the face which center Y position is the lower

// Indexes in box array

// Box size in Global coordinates ie with after all rotations are applied
idx   = 0;
idy   = idx+1;
idz   = idy+1;

// Position of box center, not the barycenter
ix    = idz+1;
iy    = ix+1;
iz    = iy+1;

// Rotation angle in degree
irx    = iz+1;
iry    = irx+1;
irz    = iry+1;

// Global coordinates of envelope
ileft = irz+1;
ifront = ileft+1;
ibottom = ifront+1;
iright = ibottom+1;
iback = iright+1;
itop = iback+1;

// Local coordinates ie before rotations

// Box size
ildx   = itop+1;
ildy   = ildx+1;
ildz   = ildy+1;

// Local coordinates of center
ilx   = ildz+1;
ily   = ilx+1;
ilz   = ily+1;

// Local coordinates of envelope
illeft = ilz+1;
ilfront = illeft+1;
ilbottom = ilfront+1;
ilright = ilbottom+1;
ilback = ilright+1;
iltop = ilback+1;

ilast = iltop;

// Internal names (more readable on generic code)
ixmin = ileft;
iymin = ifront;
izmin = ibottom;
ixmax = iright;
iymax = iback;
izmax = itop;
ilxmin = illeft;
ilymin = ilfront;
ilzmin = ilbottom;
ilxmax = ilright;
ilymax = ilback;
ilzmax = iltop;


function boxGetCenter (o) = [ o[ix], o[iy], o[iz] ];
function boxGetMin (o) = [ o[ixmin], o[iymin], o[izmin] ];
function boxGetMax (o) = [ o[ixmax], o[iymax], o[izmax] ];
function boxGetSize (o) = [ o[idx], o[idy], o[idz] ];
function boxGetLocalSize (o) = [ o[ildx], o[ildy], o[ildz] ];
function boxGetBarycenter(o) = [ (o[ixmax]+o[ixmin])/2, (o[iymax]+o[iymin])/2, (o[izmax]+o[izmin] )/2 ];
function boxGetLocalBarycenter(o) = [ (o[ilxmax]+o[ilxmin])/2, (o[ilymax]+o[ilymin])/2, (o[ilzmax]+o[ilzmin] )/2 ];

// Don't move the box, just its center to the new position
// This also changes the relative position of this center from the box, then local center is also changed
function boxMoveCenter ( o, pos ) = [ for ( i = [0:len(o)-1] ) 
    i==ix ? pos[0] :
    i==iy ? pos[1] :
    i==iz ? pos[2] :
    i==ilx ? pos[0] - o[ix] :
    i==ily ? pos[1] - o[iy] :
    i==ilz ? pos[2] - o[iz] :
    o[i]
];
// Move the center to the barycenter of the box
function boxSetBarycenter ( o ) = boxMoveCenter ( o, boxGetBarycenter(o) );

// Add missing values in array
function boxFillArray( o ) = concat ( o, len(o)-1<ilast ? [ for ( i = [len(o):ilast] ) undef ] : [] );

// Reset the box: set its center to its barycenter, then move the box to origin
function boxResetCenter ( o ) = boxMoveTo ( boxSetBarycenter(o), [0,0,0] );

// Creates the box given input size [dx, dy, dz]
function boxCreate ( size=[0,0,0] ) = boxResetCenter ( let ( o=boxFillArray(size) ) [ for ( i = [0:len(o)-1] ) 
    i==idx ? size[0] :
    i==idy ? size[1] :
    i==idz ? size[2] :
    i==ix ? 0 :
    i==iy ? 0 :
    i==iz ? 0 :
    i==irx ? 0 :
    i==iry ? 0 :
    i==irz ? 0 :
    i==ixmin ? - o[idx]/2 :
    i==iymin ? - o[idy]/2 :
    i==izmin ? - o[idz]/2 :
    i==ixmax ? + o[idx]/2 :
    i==iymax ? + o[idy]/2 :
    i==izmax ? + o[idz]/2 :
    i==ildx ? size[0] :
    i==ildy ? size[1] :
    i==ildz ? size[2] :
    i==ilx ? 0 :
    i==ily ? 0 :
    i==ilz ? 0 :
    i==ilxmin ? - o[idx]/2 :
    i==ilymin ? - o[idy]/2 :
    i==ilzmin ? - o[idz]/2 :
    i==ilxmax ? + o[idx]/2 :
    i==ilymax ? + o[idy]/2 :
    i==ilzmax ? + o[idz]/2 :
    o[i]
]);

// Move the bounding box by translating it along the given vector
// Local coordinates are not affected
function boxTranslate ( o, v ) = [ for ( i = [0:len(o)-1] ) 
    i==ix ? o[ix] + v[0] :
    i==iy ? o[iy] + v[1] :
    i==iz ? o[iz] + v[2] :
    i==ixmin ? o[ixmin] + v[0] :
    i==iymin ? o[iymin] + v[1] :
    i==izmin ? o[izmin] + v[2] :
    i==ixmax ? o[ixmax] + v[0] :
    i==iymax ? o[iymax] + v[1] :
    i==izmax ? o[izmax] + v[2] :
    o[i]
];
function boxTranslateX ( o, x ) = let ( v=[ x, 0, 0 ] ) boxTranslate ( o, v) ;
function boxTranslateY ( o, y ) = let ( v=[ 0, y, 0 ] ) boxTranslate ( o, v) ;
function boxTranslateZ ( o, z ) = let ( v=[ 0, 0, z ] ) boxTranslate ( o, v) ;

// Move the bounding box by specifiying the new coordinates of its center, min or max points
function boxMoveTo ( o, p )     = boxTranslate ( o, [ p[0]-o[ix],       p[1]-o[iy],         p[2]-o[iz] ] ) ;
function boxMoveXTo ( o, v )   = boxTranslate  ( o, [ v-o[ix], 0, 0 ] ) ;
function boxMoveYTo ( o, v )   = boxTranslate  ( o, [ 0, v-o[iy], 0 ] ) ;
function boxMoveZTo ( o, v )   = boxTranslate  ( o, [ 0, 0, v-o[iz] ] ) ;
function boxMoveMinTo ( o, p ) = boxTranslate ( o, [ p[0]-o[ixmin],   p[1]-o[iymin],      p[2]-o[izmin] ] ) ;
function boxMoveMaxTo ( o, p ) = boxTranslate ( o, [ p[0]-o[ixmax],   p[1]-o[iymax],     p[2]-o[izmax] ] ) ;

// Move the bounding box by specifiying the new coordinates of one face
function boxMoveLeftTo ( o, x ) = boxTranslateX ( o, x-o[ixmin]) ;
function boxMoveFrontTo ( o, y ) = boxTranslateY ( o, y-o[iymin]) ;
function boxMoveBottomTo ( o, z ) = boxTranslateZ ( o, z-o[izmin]) ;
function boxMoveRightTo ( o, x ) = boxTranslateX ( o, x-o[ixmax]) ;
function boxMoveBackTo ( o, y ) = boxTranslateY ( o, y-o[iymax]) ;
function boxMoveTopTo ( o, z ) = boxTranslateZ ( o, z-o[izmax]) ;

// Rotate the box around one of its axis
// The rotation is computed from its center
// Local min and max coordinates are not affected by rotation
// Rotations are executed in that order: x then y then z
// The new rotations are applied after the current rotations of the box
// The rendering functions render the box before rotation and then rotate the rendered object
// Rotation matrix from there: https://en.wikipedia.org/wiki/Rotation_matrix
//  With rotation: [u, v, w]
function boxRotatePoint ( c, deg ) = let ( u=deg[0], v=deg[1], w=deg[2] ) [
      c[0]*(cos(w)*cos(v)) + c[1]*(cos(w)*sin(v)*sin(u)-sin(w)*cos(u)) + c[2]*(cos(w)*sin(v)*cos(u)+sin(w)*sin(u))
    , c[0]*(sin(w)*cos(v)) + c[1]*(sin(w)*sin(v)*sin(u)+cos(w)*cos(u)) + c[2]*(sin(w)*sin(v)*cos(u)-cos(w)*sin(u))
    , c[0]*(-sin(v)) + c[1]*(cos(v)*sin(u)) + c[2]*(cos(v)*cos(u))
];

// Compute the rotation ignoring previous rotations
function boxRotateFromStart ( o, deg ) = let (
    cx = o[ilx],
    cy = o[ily],
    cz = o[ilz],
    pt1=boxRotatePoint([ o[ilxmin]-cx, o[ilymin]-cy, o[ilzmin]-cz ], deg),
    pt2=boxRotatePoint([ o[ilxmin]-cx, o[ilymin]-cy, o[ilzmax]-cz ], deg),
    pt3=boxRotatePoint([ o[ilxmin]-cx, o[ilymax]-cy, o[ilzmax]-cz ], deg),
    pt4=boxRotatePoint([ o[ilxmin]-cx, o[ilymax]-cy, o[ilzmin]-cz ], deg),
    pt5=boxRotatePoint([ o[ilxmax]-cx, o[ilymin]-cy, o[ilzmin]-cz ], deg),
    pt6=boxRotatePoint([ o[ilxmax]-cx, o[ilymin]-cy, o[ilzmax]-cz ], deg),
    pt7=boxRotatePoint([ o[ilxmax]-cx, o[ilymax]-cy, o[ilzmax]-cz ], deg),
    pt8=boxRotatePoint([ o[ilxmax]-cx, o[ilymax]-cy, o[ilzmin]-cz ], deg),
    xmin = min(pt1[0], pt2[0], pt3[0], pt4[0], pt5[0], pt6[0], pt7[0], pt8[0]),
    ymin = min(pt1[1], pt2[1], pt3[1], pt4[1], pt5[1], pt6[1], pt7[1], pt8[1]),
    zmin = min(pt1[2], pt2[2], pt3[2], pt4[2], pt5[2], pt6[2], pt7[2], pt8[2]),
    xmax =max(pt1[0], pt2[0], pt3[0], pt4[0], pt5[0], pt6[0], pt7[0], pt8[0]),
    ymax = max(pt1[1], pt2[1], pt3[1], pt4[1], pt5[1], pt6[1], pt7[1], pt8[1]),
    zmax = max(pt1[2], pt2[2], pt3[2], pt4[2], pt5[2], pt6[2], pt7[2], pt8[2])
    ) [ for ( i = [0:len(o)-1] ) 
    i==idx ? xmax-xmin :
    i==idy ? ymax-ymin :
    i==idz ? zmax-zmin :
    i==irx ? deg[0] :
    i==iry ? deg[1] :
    i==irz ? deg[2] :
    i==ixmin ? xmin+o[ix] :
    i==iymin ? ymin+o[iy] :
    i==izmin ? zmin+o[iz] :
    i==ixmax ? xmax+o[ix] :
    i==iymax ? ymax+o[iy] :
    i==izmax ? zmax+o[iz] :
    o[i]
];

// Add new rotations to the existing ones
// Be carefull, the new rotation is not applied from current box status,
// The given deg angles are added one by one to the existing ones and the rotation is applied from start
function boxRotate ( o, deg ) = boxRotateFromStart ( o, [ deg[0]+o[irx], deg[1]+o[iry], deg[2]+o[irz] ] ) ;

// Add an amount around all the box without changing its center position
// garray is an array of amounts: [xmin, xmax, ymin, ymax, zmin, zmax]
function boxResizeWithArray ( o, garray ) = 
    let (
        lxmin = o[ilxmin] - garray[0],
        lymin = o[ilymin] - garray[2],
        lzmin = o[ilzmin] - garray[4],
        lxmax = o[ilxmax] + garray[1],
        lymax = o[ilymax] + garray[3],
        lzmax = o[ilzmax] + garray[5]
    ) boxRotateFromStart ( [ for ( i = [0:len(o)-1] ) 
        i==ildx ? lxmax-lxmin :
        i==ildy ? lymax-lymin :
        i==ildz ? lzmax-lzmin :
        i==ilxmin ? lxmin :
        i==ilymin ? lymin :
        i==ilzmin ? lzmin :
        i==ilxmax ? lxmax :
        i==ilymax ? lymax :
        i==ilzmax ? lzmax :
        o[i]
    ],
    [ o[irx], o[iry], o[irz] ]
    );
function boxResize ( o, g ) = boxResizeWithArray ( o, [ g, g, g, g, g, g ] );
function boxResizeX ( o, g ) = boxResizeWithArray ( o, [ g, g, 0, 0, 0, 0 ] );
function boxResizeLeft ( o, g ) = boxResizeWithArray ( o, [ g, 0, 0, 0, 0, 0 ] );
function boxResizeRight ( o, g ) = boxResizeWithArray ( o, [ 0, g, 0, 0, 0, 0 ] );
function boxResizeY ( o, g ) = boxResizeWithArray ( o, [ 0, 0, g, g, 0, 0 ] );
function boxResizeFront ( o, g ) = boxResizeWithArray ( o, [ 0, 0, g, 0, 0, 0 ] );
function boxResizeBack ( o, g ) = boxResizeWithArray ( o, [ 0, 0, 0, g, 0, 0 ] );
function boxResizeZ ( o, g ) = boxResizeWithArray ( o, [ 0, 0, 0, 0, g, g ] );
function boxResizeBottom ( o, g ) = boxResizeWithArray ( o, [ 0, 0, 0, 0, g, 0 ] );
function boxResizeTop ( o, g ) = boxResizeWithArray ( o, [ 0, 0, 0, 0, 0, g ] );

// Extrude one wall to the given absolute position
function boxExtrudeLeft ( o, p ) = boxResizeWithArray ( o, [ o[ileft]-p, 0, 0, 0, 0, 0 ] );
function boxExtrudeRight ( o, p ) = boxResizeWithArray ( o, [ 0, p-o[iright], 0, 0, 0, 0 ] );
function boxExtrudeFront ( o, p ) = boxResizeWithArray ( o, [ 0, 0, o[ifront]-p, 0, 0, 0 ] );
function boxExtrudeBack ( o, p ) = boxResizeWithArray ( o, [ 0, 0, 0, p-o[iback], 0, 0 ] );
function boxExtrudeBottom ( o, p ) = boxResizeWithArray ( o, [ 0, 0, 0, 0, o[ibottom]-p, 0 ] );
function boxExtrudeTop ( o, p ) = boxResizeWithArray ( o, [ 0, 0, 0, 0, 0, p-o[itop] ] );

// Merges 2 boxes in place
// The resulting box is the bounding box of the 2 centered at the barycenter at [0,0,0]
// Rotations are reset during the operation
function boxUnion ( o1, o2 ) = let (
    dx = max(o1[ixmax],o2[ixmax]) - min(o1[ixmin],o2[ixmin]),
    dy = max(o1[iymax],o2[iymax]) - min(o1[iymin],o2[iymin]),
    dz = max(o1[izmax],o2[izmax]) - min(o1[izmin],o2[izmin])
) [ for ( i = [0:len(o1)-1] ) 
    i==idx ? dx :
    i==idy ? dy :
    i==idz ? dz :
    i==ix ? 0 :
    i==iy ? 0 :
    i==iz ? 0 :
    i==irx ? 0 :
    i==iry ? 0 :
    i==irz ? 0 :
    i==ixmin ? - dx/2 :
    i==iymin ? - dy/2 :
    i==izmin ? - dz/2 :
    i==ixmax ? + dx/2 :
    i==iymax ? + dy/2 :
    i==izmax ? + dz/2 :
    i==ildx ? dx :
    i==ildy ? dy :
    i==ildz ? dz :
    i==ilx ? 0 :
    i==ily ? 0 :
    i==ilz ? 0 :
    i==ilxmin ? - dx/2 :
    i==ilymin ? - dy/2 :
    i==ilzmin ? - dz/2 :
    i==ilxmax ? + dx/2 :
    i==ilymax ? + dy/2 :
    i==ilzmax ? + dz/2 :
    o[i]
];

// Glue the second box to the first one. One method for each face
// The resulting box is the bounding box of the 2 centered at the barycenter at [0,0,0]
function boxGlueOnLeft ( o, o1 ) =boxUnion ( o, boxMoveRightTo ( o1, o[ileft] ) );
function boxGlueOnRight ( o, o1 ) =boxUnion ( o, boxMoveLeftTo ( o1, o[iright] ) );
function boxGlueOnFront ( o, o1 ) =boxUnion ( o, boxMoveBackTo ( o1, o[ifront] ) );
function boxGlueOnBack ( o, o1 ) =boxUnion ( o, boxMoveFrontTo ( o1, o[iback] ) );
function boxGlueOnBottom ( o, o1 ) =boxUnion ( o, boxMoveTopTo ( o1, o[ibottom] ) );
function boxGlueOnTop ( o, o1 ) =boxUnion ( o, boxMoveBottomTo ( o1, o[itop] ) );

// Render the box as a cube
module boxRenderCube ( o ) {
    // The rendered object is centered to the barycenter, not to the box center point
    translate ( boxGetBarycenter (o) )
    rotate ( [ o[irx], o[iry], o[irz] ] )
    cube ( boxGetLocalSize (o), center=true ) ;
}

function boxRotationFromOrientation ( orientation ) = 
    orientation==ixmax ? [0,90,0] :
    orientation==ixmin ? [0,-90,0] :
    orientation==iymax ? [-90,0,0] :
    orientation==iymin ? [90,0,0] :
    orientation==izmax ? [0,0,0] :
    [0,180,0]
;

// Render the box as a cylinder rotated as specified
module boxRenderCylinder ( o, d1, d2, h, orientation ) {
    // The rendered object is centered to the barycenter, not to the box center point
    translate ( boxGetBarycenter (o) )
    rotate ( [ o[irx], o[iry], o[irz] ] )
    rotate ( boxRotationFromOrientation (orientation) )
    cylinder( r1=d1/2, r2=d2/2, h=h, center = true );
}

// Render the box as a cylinder which axis is oriented on X, Y or Z
// The cylinder diameter is computed in order to use the most space while still in the box
module boxRenderCylinderX ( o ) boxRenderCylinder ( o, min(o[ildy],o[ildz]), min(o[ildy],o[ildz]), o[ildx], iright );
module boxRenderCylinderY ( o ) boxRenderCylinder ( o, min(o[ildx],o[ildz]), min(o[ildx],o[ildz]), o[ildy], iback );
module boxRenderCylinderZ ( o ) boxRenderCylinder ( o, min(o[ildx],o[ildy]), min(o[ildx],o[ildy]), o[ildz], itop );

// Render the box as a cone which small diameter (sd) point to the specified direction
// The cylinder diameter large diameter is computed in order to use the most space while still in the box
module boxRenderCone ( o, sd=0, orientation ) boxRenderCylinder ( o, min(o[idy],o[idz]), sd, o[idx], orientation );
module boxRenderConeRight ( o, sd=0 ) boxRenderCylinder ( o, min(o[ildy],o[ildz]), sd, o[ildx], iright );
module boxRenderConeLeft ( o, sd=0 ) boxRenderCylinder ( o, min(o[ildy],o[ildz]), sd, o[ildx], ileft );
module boxRenderConeBack ( o, sd=0 ) boxRenderCylinder ( o, min(o[ildx],o[ildz]), sd, o[ildy], iback );
module boxRenderConeFront ( o, sd=0 ) boxRenderCylinder ( o, min(o[ildx],o[ildz]), sd, o[ildy], ifront );
module boxRenderConeTop ( o, sd=0 ) boxRenderCylinder ( o, min(o[ildx],o[ildy]), sd, o[ildz], itop );
module boxRenderConeBottom ( o, sd=0 ) boxRenderCylinder ( o, min(o[ildx],o[ildy]), sd, o[ildz], ibottom );

