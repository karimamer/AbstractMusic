module Algebra (intervalMod, intervalDiv, intervalDivisors) where

import Music (intToFa, toInterval, Interval(..), FreeAbelian(..))
import Shortcuts

intervalMod i di
  | (i > unison) = intervalModPos i di
  | (i < unison) = intervalModNeg i di
  | otherwise = unison
  where
    intervalModPos i di
      | (i < unison) = undefined
      | (i ^-^ di) < unison = i
      | otherwise = intervalMod (i ^-^ di) di
    intervalModNeg i di
      | (i > unison) = undefined
      | (i ^+^ di) > unison = i
      | otherwise = intervalMod (i ^+^ di) di

intervalDiv i di
  | (i > unison) = intervalDivPos i di
  | (i < unison) = intervalDivNeg i di
  | otherwise = 0 :: Int
  where 
    intervalDivPos i di
      | (i < unison) = undefined
      | (i ^-^ di) < unison = 0
      | otherwise = 1 + (intervalDiv (i ^-^ di) di)
    intervalDivNeg i di
      | (i > unison) = undefined
      | (i ^+^ di) > unison = 0
      | otherwise = 1 + (intervalDiv (i ^+^ di) di)

x `divides` y = (y `div` x)*x == y

-- we want x,y where i = x*j + y*k
intervalDivisors i j k
  | (p == 0) = Nothing
  | not $ p `divides` r = Nothing
  | not $ p `divides` q = Nothing
  | otherwise = Just (r `div` p, q `div` p)
  where (m ::+ n) = intToFa i
        (a ::+ b) = intToFa j
        (c ::+ d) = intToFa k
        p = (a*d - b*c)
        q = (a*n - b*m)
        r = (d*m - c*n)
-- e.g., intervalDivisors comma _P5 _P8 = Just (12,-7), as expected.