include <../api/box.scad>

$fn = 180;

mainBoxSize = [8.4, 9.1, 10.5];
cylinderXSize = [8.5, 1.2, 1.2];
cylinderYSize = [0.8, 5.4, 0.8];
cylinderYRotation = [ 42, 0, 0];

mainBox = boxCreate ( mainBoxSize );
cylinderX = boxMoveLeftTo ( boxCreate ( cylinderXSize ), mainBox[ixmax] );
cylinderY = boxMoveFrontTo (
    boxMoveBottomTo (
        boxMoveLeftTo (
            boxRotate (
                boxCreate ( cylinderYSize )
                , cylinderYRotation )
            , cylinderX[ix] )
        , cylinderX[iy] )
    , cylinderX[iz]
);

color ( "White" )
boxRenderCube ( mainBox );

color ( "Red" )
boxRenderCylinderX ( cylinderX );

color ( "Green" )
boxRenderConeBack ( cylinderY );

