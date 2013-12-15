module Graphics.UI.Threepenny.Canvas (
    -- * Synopsis
    -- | Partial binding to the HTML5 canvas API.
    
    -- * Documentation
    Canvas,
    Vector,
    drawImage, clearCanvas,
    fillText, strokeText,
    rect, fillRect, strokeRect, clearRect,
    fill, stroke, beginPath, closePath,
    clip, moveTo, lineTo,
    quadraticCurveTo, bezierCurveTo,
    arc, arcTo
    ) where

import Graphics.UI.Threepenny.Core

{-----------------------------------------------------------------------------
    Canvas
------------------------------------------------------------------------------}
type Canvas = Element

type Vector = (Int,Int)
type DoubleFake = Int

-- | Draw the image of an image element onto the canvas at a specified position.
drawImage :: Element -> Vector -> Canvas -> UI ()
drawImage image (x,y) canvas =
    runFunction $ ffi "%1.getContext('2d').drawImage(%2,%3,%4)" canvas image x y

-- | XXX write doc
fillText :: String -> Vector -> Canvas -> UI ()
fillText text (x,y) canvas =
    runFunction $ ffi "%1.getContext('2d').fillText(%2,%3,%4)" canvas text x y

-- | XXX write doc
strokeText :: String -> Vector -> Canvas -> UI ()
strokeText text (x,y) canvas =
    runFunction $ ffi "%1.getContext('2d').strokeText(%2,%3,%4)" canvas text x y


rect :: Vector -> Int -> Int -> Canvas -> UI ()
rect (x,y) width height canvas =
    runFunction $ ffi "%1.getContext('2d').rect(%2,%3,%4,%5)" canvas x y width height

fillRect :: Vector -> Int -> Int -> Canvas -> UI ()
fillRect (x,y) width height canvas =
    runFunction $ ffi "%1.getContext('2d').fillRect(%2,%3,%4,%5)" canvas x y width height

strokeRect :: Vector -> Int -> Int -> Canvas -> UI ()
strokeRect (x,y) width height canvas =
    runFunction $ ffi "%1.getContext('2d').strokeRect(%2,%3,%4,%5)" canvas x y width height

clearRect :: Vector -> Int -> Int -> Canvas -> UI ()
clearRect (x,y) width height canvas =
    runFunction $ ffi "%1.getContext('2d').clearRect(%2,%3,%4,%5)" canvas x y width height

fill :: Canvas -> UI ()
fill canvas = runFunction $ ffi "%1.getContext('2d').fill()" canvas

stroke :: Canvas -> UI ()
stroke canvas = runFunction $ ffi "%1.getContext('2d').stroke()" canvas

beginPath :: Canvas -> UI ()
beginPath canvas = runFunction $ ffi "%1.getContext('2d').beginPath()" canvas

closePath :: Canvas -> UI ()
closePath canvas = runFunction $ ffi "%1.getContext('2d').closePath()" canvas

clip :: Canvas -> UI ()
clip canvas = runFunction $ ffi "%1.getContext('2d').clip()" canvas

moveTo :: Vector -> Canvas -> UI ()
moveTo (x,y) canvas =
    runFunction $ ffi "%1.getContext('2d').moveTo(%2,%3)" canvas x y

lineTo :: Vector -> Canvas -> UI ()
lineTo (x,y) canvas =
    runFunction $ ffi "%1.getContext('2d').lineTo(%2,%3)" canvas x y

quadraticCurveTo :: Vector -> Vector -> Canvas -> UI ()
quadraticCurveTo (cpx,cpy) (x,y) canvas =
    runFunction $ ffi "%1.getContext('2d').quadraticCurveTo(%2,%3,%4,%5)" canvas cpx cpy x y

bezierCurveTo :: Vector -> Vector -> Vector -> Canvas -> UI ()
bezierCurveTo (cpx1,cpy1) (cpx2,cpy2) (x,y) canvas =
    runFunction $ ffi "%1.getContext('2d').bezierCurveTo(%2,%3,%4,%5,%6,%7)" canvas cpx1 cpy1 cpx2 cpy2 x y

arc :: Vector -> DoubleFake -> DoubleFake -> DoubleFake -> Canvas -> UI ()
arc (x,y) r sAngle eAngle canvas = do
    runFunction $ ffi "%1.getContext('2d').arc(%2,%3,%4,%5,%6)" canvas x y r sAngle eAngle

arcTo :: Vector -> Vector -> DoubleFake -> Canvas -> UI ()
arcTo (x1,y1) (x2,y2) r canvas = do
    runFunction $ ffi "%1.getContext('2d').arcTo(%2,%3,%4,%5,%6)" canvas x1 y1 x2 y2 r

-- scale
-- rotate
-- translate
-- transform
-- setTransform

-- | Clear the canvas
clearCanvas :: Canvas -> UI ()
clearCanvas = runFunction . ffi "%1.getContext('2d').clear()"


