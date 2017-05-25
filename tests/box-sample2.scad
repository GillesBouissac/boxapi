include <../api/box.scad>

// Test of some modules
test =
    boxRotate (
        boxMoveTo (
            boxRotate (
                boxCreate ( [2, 10, 20] )
                , [110,30,20]
            )
            , [10, 20, 30]
        )
        , [10,0,0]
    )
;
testResized = boxResize ( test, 1 );
plane = boxCreate ( [0.0001, 10, 10] );
difference() {
    boxRenderCube( testResized );
    boxRenderCube( boxResizeX ( test, 1 ) );
    boxRenderCube( boxResizeY ( test, 1 ) );
    boxRenderCube( boxResizeZ ( test, 1 ) );
}
boxRenderCylinderX ( boxResizeX ( test, 1 ), $fn=100 );
boxRenderCylinderY ( boxResizeY ( test, 1 ), $fn=100 );
boxRenderCylinderZ ( boxResizeZ ( test, 1 ), $fn=100 );
// boxRenderCylinderZ( test );
#translate( [ testResized[ixmax], testResized[iy], testResized[iz] ] ) rotate( [0,0,0] ) boxRenderCube( plane );
#translate( [ testResized[ixmin], testResized[iy], testResized[iz] ] ) rotate( [0,0,0] ) boxRenderCube( plane );
#translate( [ testResized[ix], testResized[iymax], testResized[iz] ] ) rotate( [0,0,90] ) boxRenderCube( plane );
#translate( [ testResized[ix], testResized[iymin], testResized[iz] ] ) rotate( [0,0,90] ) boxRenderCube( plane );
#translate( [ testResized[ix], testResized[iy], testResized[izmax] ] ) rotate( [0,90,0] ) boxRenderCube( plane );
#translate( [ testResized[ix], testResized[iy], testResized[izmin] ] ) rotate( [0,90,0] ) boxRenderCube( plane );

