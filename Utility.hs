module Utility where

import Data.Tuple
import Data.Bool
import Data.List
import Control.Applicative

-- Import this module qualified, some names may be or become common.

modDiv :: Integral b => b -> b -> (b, b)
a `modDiv` b = swap (a `divMod` b)

guarded :: Alternative f => (a -> Bool) -> a -> f a
guarded p x = bool empty (pure x) (p x)

digits :: Integral a => a -> [a]
digits = unfoldr (fmap (`modDiv` 10) . guarded (0 /=))

digits' :: Integral a => a -> [a]
digits' = unfoldr ((`modDiv` 10) <.> guarded (0 /=))

(<.>) :: (Functor f) => (a -> b) -> (t -> f a) -> t -> f b
(f <.> g) x = f <$> g x  -- Applicative version of (f . g) x = f $ g x
infixl 9 <.>

-- That gets rid of the pesky fmaps you always have in code like this, so you
-- can write it more naturally as: unfoldr ((`modDiv` 10) <.> guarded (0 /=))
-- 748291

asAppliedTo :: (a -> b) -> a -> a -> b
asAppliedTo f a _ = f a

-- dibblego's lazy reverse, can reverse . reverse infinite lists
rev xs = let go (_:xs) ~(y:ys) = y : go xs ys
             go [] ~[] = []
         in  go xs (rev xs)

-- ['a'..'d'] -> [('a',"bcd"), ('b',"acd"), ('c',"abd"), ('d',"abc")]
-- doesn't need Eq
select :: [a] -> [(a, [a])]
select [] = []
select (x:xs) = (x,xs) : [(y,x:ys) | (y,ys) <- select xs]
