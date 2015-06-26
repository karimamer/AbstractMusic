{-# LANGUAGE EmptyDataDecls, 
             MultiParamTypeClasses, 
             UndecidableInstances, 
             IncoherentInstances, 
             DataKinds,
             FunctionalDependencies,
             FlexibleContexts,
             RankNTypes,
             ImpredicativeTypes,
             OverlappingInstances,
             TypeSynonymInstances,
             ScopedTypeVariables,
             UnicodeSyntax,
             GADTSyntax,
             GADTs,
             TypeFamilies,
             ConstraintKinds,
             InstanceSigs,
             GeneralizedNewtypeDeriving,
             StandaloneDeriving,
             ViewPatterns,
             ExplicitForAll,
             FlexibleInstances #-}

module Analysis (simultaneous, flattenUntil, makeContext,
                 goRight, goLeft, goUp, goDown, (-:),
                 countDursUntil, countDursRec, reconstructPhrase, reconstructUntil) where

import Music (Music(..), Note(..), AbstractNote(..), AbstractPhrase(..),
              countDurs, extractDur, foldPhrase, foldPhrase1, isConn, flattenPhrase,
              isNote, countDursRec, emptyPhrase)

import Util (uniq)

import Shortcuts

data PhraseContext n where
  PhraseContext :: (Note p i d) =>
                   [(AbstractPhrase (AbstractNote p i d), AbstractPhrase (AbstractNote p i d))] -> AbstractNote p i d -> PhraseContext (AbstractNote p i d)

instance Show (PhraseContext n) where
  show (PhraseContext cs n) = "{{Focus:" ++ (show n) ++ "}|{Contexts:" ++ (show cs) ++ "}}"

-- reconsturct entire phrase from any of its contexts
reconstructPhrase :: PhraseContext t -> AbstractPhrase t
reconstructPhrase (PhraseContext [] n) = AbstractPhrase [n]
reconstructPhrase (PhraseContext ((l, r):ps) n) = reconstructPhrase $ PhraseContext ps (Conn $ (l <> (AbstractPhrase [n]) <> r))

-- reconstruct phrase partially: missing out intermediate Conn
-- elements, and the right-hand-sides of contexts, and only up to the
-- given context
-- fixme: cope with Conns right at the beginning of the tree
reconstructUntil :: PhraseContext t -> AbstractPhrase t
reconstructUntil (PhraseContext [] n) = AbstractPhrase [n]
reconstructUntil (PhraseContext ((AbstractPhrase l, _):ps) n) = reconstructUntil $ PhraseContext ps (Conn $ (l' <> (AbstractPhrase [n])))
  where l' = AbstractPhrase $ filter (not . isConn) l -- get rid of intermediate Conns: we only want a 'straight' line, all the way to the context, in the reconstruction

phraseHead :: AbstractPhrase n -> n
phraseHead (AbstractPhrase p) = head p

phraseTail :: AbstractPhrase n -> AbstractPhrase n
phraseTail (AbstractPhrase p) = AbstractPhrase (tail p)

phraseLast :: AbstractPhrase n -> n
phraseLast (AbstractPhrase p) = last p

phraseInit :: AbstractPhrase n -> AbstractPhrase n
phraseInit (AbstractPhrase p) = AbstractPhrase (init p)

makeContext :: AbstractPhrase t -> PhraseContext t
makeContext (AbstractPhrase (n:ns)) = PhraseContext [(AbstractPhrase [], AbstractPhrase ns)] n

goRight :: PhraseContext t -> PhraseContext t
goRight (PhraseContext ((l, r):ps) n) = PhraseContext ((l <> (AbstractPhrase [n]), (phraseTail r)):ps) (phraseHead r)

goLeft :: PhraseContext t -> PhraseContext t
goLeft (PhraseContext ((l, r):ps) n) = PhraseContext (((phraseInit l), (AbstractPhrase [n]) <> r):ps) (phraseLast l)

goUp :: PhraseContext t -> PhraseContext t
goUp (PhraseContext ((l, r):ps) n) = PhraseContext ps (Conn $ (l <> (AbstractPhrase [n]) <> r))

goDown :: PhraseContext t -> PhraseContext t
goDown (PhraseContext ps (Conn p)) = PhraseContext ((AbstractPhrase [], phraseTail p):ps) (phraseHead p)

editContext :: t -> PhraseContext t -> PhraseContext t
editContext n (PhraseContext ps _) = PhraseContext ps n


x -: func = func x

countDursUntil :: Note p i d => PhraseContext (AbstractNote p i d) -> d
countDursUntil = countDursRec . reconstructUntil

-- apply predicate to all contexts, with behaviour dependent on generic rule
traverseContexts ::
  (Bool -> [PhraseContext t] -> [PhraseContext t] -> [PhraseContext t] -> [PhraseContext t]) -> ((PhraseContext t) -> Bool) -> (PhraseContext t) -> [PhraseContext t]
traverseContexts rule pred c@(PhraseContext ((l, r):cs) n) =
  let right = if r == emptyPhrase
              then []
              else traverseUntil pred (c -: goRight)
      down = case n of (Conn p) -> traverseUntil pred (c -: goDown)
                       _ -> []
  in rule (pred c) [c] right down


-- list all contexts accessible from a given top-context (going right
-- and/or down as appropriate)
-- fixme: does not pick up last context of each phrase
listContexts :: PhraseContext t -> [PhraseContext t]
listContexts = traverseContexts (\_ c r d -> c ++ r ++ d) (\_ -> True)

-- return contexts for which (pred context) turns true, but stop
-- searching along branch as soon as a result is found
traverseUntil :: ((PhraseContext t) -> Bool) -> (PhraseContext t) -> [PhraseContext t]
traverseUntil = traverseContexts q
  where q pred c r d = if pred
                       then c
                       else r ++ d

-- keep going through all the contexts, returning those for which (pred context) is true
traverseFilter :: ((PhraseContext t) -> Bool) -> (PhraseContext t) -> [PhraseContext t]
traverseFilter = traverseContexts q
  where q pred c r d = if pred
                       then c ++ r ++ d
                       else r ++ d



-- all contexts (in the overall phrase-tree derivable from the given
-- context) that occur at the same absolute time as the given one (as
-- calculated by adding up durations)

simultaneous c =
  let d = countDursUntil c
      phraseTree = (makeContext . reconstructPhrase) c
  in traverseUntil ((==d) . countDursUntil) phraseTree

-- original, slower, implementation:
-- simultaneous' c =
  -- let allContexts = (listContexts . makeContext . reconstructPhrase) c
      -- d = countDursUntil c
  -- in filter ((==d) . countDursUntil) allContexts




-- a single flattened out phrase leading up to the context
flattenUntil :: (PhraseContext t) -> (AbstractPhrase t)
flattenUntil c =
  let p = reconstructUntil c
  in flattenPhrase p



example1 = AbstractPhrase (zipWith note [c,d,e,f] (repeat cr)) <> (conn $ AbstractPhrase (zipWith note [g,g] (repeat cr))) <> (AbstractPhrase (zipWith note [a,a] (repeat cr)))

example1durs = example1 -: makeContext -: goRight -: goRight -: goRight -: goRight -: goDown -: goRight -: countDursUntil

example2 = (conn $ AbstractPhrase (zipWith note [c,d] (repeat cr))) <> (AbstractPhrase (zipWith note [a,b] (repeat cr)))


