{-# LANGUAGE ViewPatterns,
             MultiParamTypeClasses #-}


module Util where

import Control.Monad
import Data.Ratio
import Data.Semigroup
import Data.List

interleave (x:xs) (y:ys) = [x, y] ++ (interleave xs ys)
interleave [] ys = ys
interleave ys [] = ys

log2 x = (log x) / (log 2)


-- iterateM is just like iterate, except it can keep track of
-- arbitrary state, and only (f state) ends up in the output list.
iterateM f g state = (f state) `mplus` (iterateM f g (g state))

compose [] = id
compose (f:fs) = f . (compose fs)

member xs  x = (not . null . (filter (==x))) xs
intersection xs = filter (member xs)
remove xs ys = filter (\y -> not (member xs y)) ys

rotate [] = []
rotate (x:xs) = xs ++ [x]

rotateN 0 = id
rotateN n = rotate . (rotateN (n - 1))

-- to enable pattern-matching against the ratio constructor
nd :: (Integral a) => Ratio a -> (a,a)
nd r = (numerator r, denominator r)


foldSG l = foldl1 (<>) l


-- foldSG' f e (x:[]) = f x e
-- foldSG' f e (x:xs) = f x (foldSG' f e xs)

uniq :: Eq a => [a] -> [a]
uniq = reverse . (u [])
  where u seen [] = seen
        u seen (x:xs) = if x `foundIn` seen
                        then u seen xs
                        else u (x:seen) xs

findWith eq c l = or $ map (eq c) l

foundIn :: Eq a => a -> [a] -> Bool
foundIn = findWith (==)

under op f = \x y -> op (f x) (f y)

x `divides` y = (y `div` x)*x == y

pairSortKey :: (Int, Int) -> Int
-- pairSortKey (x, y) = (abs x) + (abs y)
pairSortKey (x, y) = abs (x*y)

sortUnder f = sortBy (compare `under` f)

sortPairs = sortUnder pairSortKey


listDiff [] [] = []
listDiff a [] = a
listDiff [] a = a
listDiff (a:as) b = listDiff as (delete a b)


-- Cartesian product of two infinite lists, that is guaranteed to list
-- all pairs (eventually)
allPairs :: [a] -> [b] -> [(a, b)]
allPairs _ [] = []
allPairs [] _ = []
allPairs (a:as) (b:bs) = 
   (a, b) : ([(a, b) | b <- bs] `merge` 
             [(a, b) | a <- as] `merge` 
             allPairs as bs)
  where merge (x:xs) l = x : merge l xs
        merge []     l = l
